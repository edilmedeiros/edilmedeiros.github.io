# Sequence Diagrams of the Bitcoin P2P Protocol

## Handshake

```mermaid
sequenceDiagram
  Alice->>Bob: version
  Bob->>Alice: verack
  Bob->>Alice: version
  Alice->>Bob: verack
```

## Address propagation

```mermaid
sequenceDiagram
        Alice->>Bob: getaddr
        Bob->>Alice: addr
        Bob->>Alice: addr
        Bob->>Alice: addr
```

## IBD

Headers only

```mermaid
sequenceDiagram
        Alice->>Bob: getheaders
        Bob->>Alice: headers
```

Blocks

```mermaid
sequenceDiagram
        Alice->>Bob: getblocks
        Bob->>Alice: inv
        Alice->>Bob: getdata
        Bob->>Alice: [block]
```

## Normal tx and block announcement

Normal tx and block announcement

```mermaid
sequenceDiagram
        Alice->>Bob: inv
        Bob->>Alice: getdata
        Alice->>Bob: [tx, block]
```

## Mempool

```mermaid
sequenceDiagram
        Alice->>Bob: mempool
        Bob->>Alice: inv
        Alice->>Bob: getdata
        Bob->>Alice: [tx]
```

## Compact block

```mermaid
sequenceDiagram
        participant Miner
        participant Alice
        participant Bob

        Miner->>Alice: block
        activate Alice
        Alice->>Alice: Validate block
        deactivate Alice
        Alice->>Bob: headers or inv
        Bob->>Alice: getdata
        Alice->>Bob: block
```

High bandwidth

```mermaid
sequenceDiagram
        participant Miner
        participant Alice
        participant Bob

        Bob->>Alice: sendcmpct(1)
        Miner->>Alice: block
        activate Alice
        Alice->>Bob: cmpctblock
        Bob->>Alice: getblocktxn
        Alice->>Alice: Validate block
        deactivate Alice
        Alice->>Bob: blocktxn
```

Low bandwidth

```mermaid
sequenceDiagram
        participant Miner
        participant Alice
        participant Bob

        Bob->>Alice: sendcmpct(0)
        Miner->>Alice: block
        activate Alice
        Alice->>Alice: Validate block
        deactivate Alice
        
        Alice->>Bob: headers or inv
        Bob->>Alice: getdata(CMPCT)
        Alice->>Bob: cmpctblock
        Bob->>Alice: getblocktxn
        Alice->>Bob: blocktxn
```
