---
layout: post
title: Compile bitcoin core on macOS with macports
date: 2024-01-15 16:47 -0300
tags:   [bitcoin]
---

Last year I decided to dive deep into the bitcoin protocol development and
contribute to the [Bitcoin Core](https://github.com/bitcoin/bitcoin)
development. One of the most basic tasks is to be able to build the source code
and run the tests. The
[documentation](https://github.com/bitcoin/bitcoin/tree/master/doc) covers the
build process for the major platforms, including build for macOS, which is my
case.

Unfortunately, the officially supported way to install dependencies on macOS is
through [Homebrew](https://brew.sh/). Brew is the most popular package manager
for macOS. If unsure, go for it. I don't use Brew, though, in favor on
[Macports](https://www.macports.org/). Macports offers a more unix-like
experience, better control over installed packages, and it does not mess that
much with the filesystem permissions.

I considered the possibility of sending a PR, but:

- support for Macports has been dropped in 2019 in v0.18, quite a long time ago,
  for the lack of active maintainers for it (see [PR
#15175](https://github.com/bitcoin/bitcoin/pull/15175));
- the project uses [macOS images from Github
  CI](https://github.com/actions/runner-images) which will include Brew but not
  Macports.

So, it probably does not worth the maintenance burden to get just a handful of
people covered. Additionally, other than me, who uses macOS for serious stuff,
anyway? Hackers should be using black plastic Linux boxes not these
fancy-aluminum state-of-the-art-performance ARM boxes. 

In what follows, I assume you have read the [official build
docs](https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md).

## Required Dependencies

Install the required dependencies.

```bash
sudo port install autoconf automake libtool pkgconfig libevent python311 boost181
```
<br>
`boost181` is the most recent version available in macports by the time of this
writing. The default `boost` port will install version 1.76 which will compile fine,
but will not enable [external
signer](https://github.com/bitcoin/bitcoin/blob/master/doc/external-signer.md)
support.

This will install Python 3.11 as a dependency for `boost` which is fine as we
are going to need it anyway. We ask for it so macports don't clean it up in
eventual maintenance routines you come to perform later. Set Macports' Python as
default with:

```bash
sudo port select --set python python311
sudo port select --set python3 python311
```
<br>
The key is to correctly set the environment variables (it took me a while to
find them all right):

```bash
export CPPFLAGS="$CPPFLAGS -isystem /opt/local/include"
export LIBS="$LIBS -L/opt/local/lib"
export EVENT_CFLAGS="-I/opt/local/include"
export EVENT_LIBS="-L/opt/local/lib -levent"
```
<br>

## Optional Dependencies

For legacy wallet support, we need `berkeley-db`.

```bash
sudo port install db48

export CPPFLAGS="$CPPFLAGS -I/opt/local/include/db48"
export LIBS="$LIBS -L/opt/local/lib/db48"
export BDB_CFLAGS="-I/opt/local/include/db48"
```
<br>
To build the GUI, we need `qt`.

```bash
sudo port install qt5
```
<br>
Install `qrencode` to include support for QR codes in the GUI.

```bash
sudo port install qrencode
```
<br>
`miniupnpc` may be used for UPnP port mapping.

```bash
sudo port install miniupnpc

export MINIUPNPC_CPPFLAGS="-isystem /opt/local/include"
export MINIUPNPC_LIBS="-L/opt/local/lib"
```
<br>
`libnatpmp` may be used for NAT-PMP port mapping. Unfortunately, there is no
port available for it (maybe I should write it...).

Install `zmq` for ZMQ notifications.

```bash
sudo port install zmq
```
<br>

## Build Bitcoin Core

If you haven't yet, clone the Bitcoin Core repository.

```bash
git clone https://github.com/bitcoin/bitcoin.git
```
<br>
In the source code folder, don't forget to configure the package by mentioning
the `boost` library location.

```bash
./autogen.sh
./configure --with-boost=/opt/local/libexec/boost/1.81
```
<br>
If you installed all the optional dependencies I mentioned, you should get
something like this at the end.

```
Options used to compile and link:
  external signer = yes
  multiprocess    = no
  with libs       = yes
  with wallet     = yes
    with sqlite   = yes
    with bdb      = yes
  with gui / qt   = yes
    with qr       = yes
  with zmq        = yes
  with test       = yes
  with fuzz binary = yes
  with bench      = yes
  with upnp       = yes
  with natpmp     = no
  use asm         = yes
  USDT tracing    = no
  sanitizers      =
  debug enabled   = no
  gprof enabled   = no
  werror          = no
  LTO             = no
```
<br>
Now `make` it.

Happy hacking.
