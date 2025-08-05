---
layout: post
title: Bitcoin Core Tracing
tags:
- bitcoin
- tracing
date: 2025-06-01 17:02 -0300
---

I've started to try to reproduce some of the work of [0xb10c](https://b10c.me) on network monitoring.
In particular, I'm interested in running his [`peer-observer`](https://github.com/0xB10C/peer-observer) project.
It is based on an instrumented Bitcoin Core node with [eBPF trace points](https://en.wikipedia.org/wiki/EBPF) enabled.
This post documents how I'm poking Core's trace points.

## Setup the environment

eBPF is a linux-specific techonology[^1].
I'm on a Mac, so I'll need a linux virtual machine.
I decided to try out `lima`[^2]:

[^1]: It seems [it's possible to attach to trace points in Macos](https://github.com/bitcoin/bitcoin/pull/25541) too. I'll try it next time.

[^2]: I use [`nix-darwin`](https://github.com/nix-darwin/nix-darwin) as a package manager.

```bash
nix-shell -p lima
```

Lima requires a config file, similar to a Dockerfile.
Mine is called `ubuntu-core-usdt.yaml`.

```
# Ubuntu 22.04 with SystemTap and dev tools

vmType: "qemu"

images:
  - location: "https://cloud-images.ubuntu.com/releases/jammy/release-20250516/ubuntu-22.04-server-cloudimg-amd64.img"
    arch: "x86_64"
    digest: "sha256:a037d6d0299171ba62019f3c3f895eb902c271f8e9676cfe0f22e38070344579"
  - location: "https://cloud-images.ubuntu.com/releases/jammy/release-20250516/ubuntu-22.04-server-cloudimg-arm64.img"
    arch: "aarch64"
    digest: "sha256:a83795b1ff39e13314e31001bf358081be6e7f7eb3ae93a72cc494ceef51462e"

  # Fallback to the latest release image.
  # Hint: run `limactl prune` to invalidate the cache

  - location: https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-amd64.img
    arch: x86_64
  - location: https://cloud-images.ubuntu.com/releases/jammy/release/ubuntu-22.04-server-cloudimg-arm64.img
    arch: aarch64

cpus: 4
memory: "6GiB"
disk: "30GiB"

user:
  name: lima
  home: /home/lima
  

mounts:
  - location: "~"
    writable: true
  - location: "~/2-development/bitcoin/usdt-test"
    mountPoint: "/home/lima/dev"
    writable: true

provision:
  - mode: system
    script: |
      # Update package index
      apt-get update

      # Kernel debug required packages
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
        linux-headers-$(uname -r) systemtap systemtap-runtime libc6-dbg

      # Bitcoin core dependencies
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential cmake pkgconf python3 \
        libevent-dev libboost-dev \
        libsqlite3-dev libzmq3-dev \
        systemtap-sdt-dev

      # Tracing dependencies
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bpftrace bpfcc-tools

      # Ensure other useful tools
      DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git curl python3-pip

      # Config user shell
      echo "TERM=xterm-256color" > /home/lima/.bash_profile

containerd:
  system: false
```

`vmType` asks Lima to use [`qemu`](https://www.qemu.org) as the virtualization backend.
Lima is capable of using [Apple's Virtualization Framework](https://developer.apple.com/documentation/virtualization) which provides better vm performance, but the trace points don't seem to behave well.

<!-- Comment about kernel versions. -->

The `mounts` section is needed to map a folder on my environment to the virtual machine.
The first mounting point is needed otherwise the linux processes get confused and we can't compile Bitcoin Core.

Launch the vm with
```bash
limactl start ./ubuntu-core-usdt.yaml
```

Open a shell on the vm with
```bash
limactl shell ubuntu-core-usdt
```

### SystemTap Support

The kernel must support SystemTap's user-space probes (uprobes).
This is standard in most modern kernels, but we double-check using the script provided by the [`bpftrace`](https://github.com/bpftrace/bpftrace/tree/master) tool.

```bash
wget https://raw.githubusercontent.com/bpftrace/bpftrace/refs/heads/release/0.23.x/scripts/check_kernel_features.sh
chmod +x check_kernel_features.sh
./check_kernel_features.sh
```

You should see:
```
All required features present!
```

If it's not set, you won’t be able to use USDT tracing unless you recompile your kernel.


## Compile Bitcoin Core

We need to compile Bitcoin Core with USDT support.

```bash
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout v29.0
cmake -B build -DWITH_USDT=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build build -j 4
```

In my experiments, `-DCMAKE_BUILD_TYPE=Debug` is key to make it work smooth.
The regular build will include debug symbols, but not all of them and it will cause parse errors when trying to attach to the tracing probes.

You can check if the `bitcoind` binary was built with the required symbols with

```bash
readelf -n src/bitcoind | grep NT_STAPSD
```

If you see NT_STAPSD entries, the tracepoints are properly compiled in.

To list the available probes, do:

```bash
sudo bpftrace -l 'usdt:build/bin/bitcoind:*'
```

## See the probes in action

Let's start two nodes and trace some messages between them.

I'll use a script based on [contrib/tracing/log_p2p_traffic.bt](https://github.com/bitcoin/bitcoin/blob/f490f5562d4b20857ef8d042c050763795fd43da/contrib/tracing/log_p2p_traffic.bt):
The original script won't work with the `bpftrace v0.14.0` available on ubuntu 22.04 because it strips some symbols and the `BEGIN` macro won't run.

```
#!/usr/bin/env bpftrace

usdt:./build/bin/bitcoind:net:inbound_message
{
  $peer_id = (int64) arg0;
  $peer_addr = str(arg1);
  $peer_type = str(arg2);
  $msg_type = str(arg3);
  $msg_len = arg4;
  printf("inbound '%s' msg from peer %d (%s, %s) with %d bytes\n", $msg_type, $peer_id, $peer_type, $peer_addr, $msg_len);
}

usdt:./build/bin/bitcoind:net:outbound_message
{
  $peer_id = (int64) arg0;
  $peer_addr = str(arg1);
  $peer_type = str(arg2);
  $msg_type = str(arg3);
  $msg_len = arg4;
  printf("outbound '%s' msg to peer %d (%s, %s) with %d bytes\n", $msg_type, $peer_id, $peer_type, $peer_addr, $msg_len);
}
```

Open a `tmux` session:

```bash
tmux
```

On the first terminal:

```bash
tmux
mkdir data1
./build/bin/bitcoind -regtest -datadir=data1 -daemon -port=18000 -rpcport=1900
sudo ./log_p2p_traffic.bt
```

Open a new terminal with `Ctrl+"` and launch a second node.

```bash
mkdir data2
./bin/bitcoind -regtest -datadir=../data2 -port=18001 -rpcport=19001 -connect=127.0.0.1:18000 -daemon
```

You should see something like this on the terminal of the first node:

```
Attaching 2 probes...
outbound 'version' msg to peer 0 (manual, 127.0.0.1:18000) with 102 bytes
inbound 'version' msg from peer 0 (inbound, 127.0.0.1:52362) with 102 bytes
outbound 'version' msg to peer 0 (inbound, 127.0.0.1:52362) with 102 bytes
outbound 'wtxidrelay' msg to peer 0 (inbound, 127.0.0.1:52362) with 0 bytes
outbound 'sendaddrv2' msg to peer 0 (inbound, 127.0.0.1:52362) with 0 bytes
...
```

## References

https://github.com/bitcoin/bitcoin/blob/589b56192f53ceb7345746e26b2f80c7b3cc6180/doc/tracing.md

https://github.com/bitcoin/bitcoin/tree/589b56192f53ceb7345746e26b2f80c7b3cc6180/contrib/tracing

https://github.com/bpftrace/bpftrace/tree/master

https://github.com/iovisor/bcc
