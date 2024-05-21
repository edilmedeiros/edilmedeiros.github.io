---
layout: post
title: Creating a custom bitcoin signet
date: 2024-05-10 11:24 -0300
tags:   [bitcoin]
---

Bitcoin is composed by four networks, not just one. 
The first is called `mainnet`, this is where the valuable tokens live and is usually what we refer to as the bitcoin network.
The other three are test networks intended for developers to experiment before deploying applications in the main network: `testnet`, `regtest`, and `signet`.

signet is standardized in [BIP 325](https://github.com/bitcoin/bips/blob/master/bip-0325.mediawiki) and is intended to be "a new type of test network where signatures are used in addition to proof of work for block progress, enabling much better coordination and robustness (be reliably unreliable), for persistent, longer-term testing scenarios involving multiple independent parties."

signet is a valuable resource not only for testing applications, but also for instructional purposes.
The [bitcoin wiki](https://en.bitcoin.it/wiki/Signet) has instructions about how to setup a custom signet.
Unfortunately, the instructions consider an old version of bitcoin core and have to be adapted to be useful with descriptor wallets.
This post provides updated instructions.


## Preliminaries

We will set up a Bitcoin Core full node and a mining process.
I'm using MacOS, should be the same on Linux.
Start by cloning the source files and creating a `datadir` folder to hold the network data.
```bash
cd ~
git clone https://github.com/bitcoin/bitcoin.git
mkdir bitcoin-datadir
export BTC_PATH=~/bitcoin/src
export SIGNET_DATADIR=~/bitcoin-datadir
```

I prefer to compile from source.
You may use the precompiled binaries published in the [Bitcoin Core website](https://bitcoincore.org/) but we will need the sources anyway to get the mining script.
See [my post about dependencies in MacOS](https://edil.com.br/blog/compile-bitcoin-core-with-macports).
```bash
cd ~/bitcoin
./autogen.sh
./configure
make -j$(nproc)
```

Let's create some aliases and environment variables to save typing.
```bash
# Bitcoin client
alias btcd="$BTC_PATH/src/bitcoind -datadir=$SIGNET_DATADIR"

# Bitcoin CLI
alias bcli="$BTC_PATH/src/bitcoin-cli -datadir=$SIGNET_DATADIR"

# Mining script
alias miner="$BTC_PATH/../contrib/signet/miner"

# Bitcoin-util, a tool that computes proof of work
alias grinder="$BTC_PATH/bitcoin-util grind"

# datadir cleanup, in case we need to start the network from scratch
alias miner-datadir-cleanup="rm $SIGNET_DATADIR; mkdir $SIGNET_DATADIR"
```

Finally, install `jq` with your system's package manager.
Not strictly needed, but convenient.


## Create the signet challenge.

The signet network requires an additional consensus parameter called the **challenge**, which characterizes each signet.
The challenge is a traditional `scriptPubKey` (or locking script) which follows the same semantics as for transactions.
Each valid block should present `scriptSig` and `scriptWitness` that fullfil the signet challenge (see [BIP 325](https://github.com/bitcoin/bips/blob/master/bip-0325.mediawiki)).

We are going to create a simple `p2wpkh` locking script for our signet challenge.
But we need to have a private key so that we can create valid signatures later.
The strategy is to use regtest to create and export keys so we can start the signet node.

Get the node up and running on regtest.
```bash
btcd -regtest -daemon
```

Create a new wallet for the issuer node.
```bash
bcli -regtest createwallet "signer"
```

Get wallet info, including private keys.
```bash
DESCRIPTORS=$(bcli -regtest listdescriptors true | jq -r .descriptors)
```

Create an address for the signet challenge.
```bash
ADDR=$(bcli -regtest -named getnewaddress address_type="bech32")
```

Get the signet challenge.
```bash
SIGNET_CHALLENGE=$(bcli -regtest -named getaddressinfo $ADDR | jr -r .scriptPubKey)
```

We are done with regtest, stop the node.
```bash
bcli -regtest stop
```

## Run the signet miner

Create the config file.
This will be used by the connecting nodes too.
```bash
echo "signet=1
[signet]
daemon=1
signetchallenge=001427d3c92caf78e46124d297a165879e6876a9965a" > $SIGNET_DATADIR/bitcoin.conf
```

Start the issuer node.
```bash
btcd
```

Create a wallet and import the keys we created earlier.
```bash
bcli createwallet "miner"
bcli importdescriptors "$DESCRIPTORS"
```

Create a new address for the miner to receive funds from coinbase transactions.
```bash
MINER_ADDR=$(bcli -named getnewaddress address_type="bech32")
```

Mine the first block setting the block time to current time.
```bash
miner --cli "bcli" generate --address $MINER_ADDR --grind-cmd "grinder" --min-nbits --set-block-time $(date +%s)
```

Keep mining new blocks.
```bash
miner --cli "bcli" generate --address $MINER_ADDR --grind-cmd "grinder" --min-nbits --ongoing
```

## Connecting nodes

You can start a new node from the same machine to connect to the miner.
Start by creating a new datadir and aliases.
```bash
# Create datadir folder
mkdir ~/bitcoin-datadir-node1
export NODE1_DATADIR="~/bitcoin-datadir-node1"

# Aliases
alias btcd-node="$BTC_PATH/bitcoind -datadir=$NODE1_DATADIR"
alias bcli-node="$BTC_PATH/bitcoin-cli -datadir=$NODE1_DATADIR"
alias node-datadir-cleanup="rm $NODE1_DATADIR; mkdir $NODE1_DATADIR"
```

Copy bitcoin.conf with the signet challenge and edit the file.
We have to use a different network port so that is does not conflitc with the miner.
```bash
cp $SIGNET_DATADIR/bitcoin.conf $NODE1_DATADIR/bitcoin.conf
echo "rpcallowip=127.0.0.1
rpcbind=127.0.0.1:18343
rpcport=18343
bind=127.0.0.1:18344" >> $NODE1_DATADIR/bitcoin.conf
```

Start the node.
```bash
btcd-node
```

Connect to the miner node.
```bash
bcli-node addnode 127.0.0.1:38333 add
```

You may check the connection with `getpeerinfo`.
From here you may create a wallet and receive bitcoin from the miner.


## Note about the network difficulty

During the writing of this post I engaged in a discussion about the difficulty behavior that seemed odd.
I understood that the miner script tries to keep the 10 minute pacing on the network block mining.
It does so by managing an internal timer.
With minimal network difficulty (which is what we are using here) any modern machine can find a few blocks per second.
So, instead of increasing difficulty and "wasting" resources to mine, the miner grinds a new block and halt.

It does worth checking out the discussion: <https://github.com/bitcoin/bitcoin/issues/30091>.

Happy signet mining.
