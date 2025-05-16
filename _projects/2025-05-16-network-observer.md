---
title: Bitcoin Network Observatory
date: 2025-05-16
subtitle: Long-Term Monitoring of Bitcoin’s Peer-to-Peer Network
image: '/images/bitcoin-observatory/bitcoin-observatory.png'
---

Bitcoin’s P2P network is a critical component of its decentralization and censorship resistance.
However, it is also one of the least understood aspects of the system in practice.
There is limited visibility into how information propagates through the network, how nodes discover and connect with peers, and how adversarial or faulty behavior can affect network topology, performance, or resilience.

While projects like those by 0xB10C have shed light on various operational aspects of the Bitcoin network, there remains a significant need for sustained, systematic monitoring efforts that can track long-term trends, detect anomalies, and support research into protocol-level improvements.

<h2>Proposed Solution</h2> 

The Bitcoin Network Observatory is a long-term initiative to monitor, log, and analyze the behavior of the Bitcoin P2P network.
It aims to produce open datasets and reproducible studies that deepen our understanding of the network’s dynamics and evolution over time.

The first subproject focuses on the propagation and influence of **address relay messages**.
These messages are used by nodes to share information about other peers in the network.
Understanding how these messages are broadcast, selected, and consumed by nodes can shed light on the network’s peer discovery mechanisms and their influence on node connectivity and topology.

To study this, we are building a controlled set of monitoring nodes capable of observing and logging addr-related traffic, analyzing message frequency, peer behavior patterns, and potential biases or inefficiencies in peer selection and connection strategies.

<h2>Potential Impact</h2>

This project aims to provide empirical insight into one of Bitcoin’s most opaque layers:
its P2P network.
By analyzing address relay behavior, we hope to uncover patterns or vulnerabilities that could inform improvements in peer selection algorithms, privacy protections, or anti-censorship mechanisms.
Over time, the Observatory could grow into a vital resource for researchers, developers, and protocol designers focused on strengthening Bitcoin’s network layer.

<h2>References</h2>
[0xb10c projects](https://b10c.me)
[Decentralized Systems and Network Services Research Group - KASTEL](https://www.dsn.kastel.kit.edu/bitcoin/index.html)


<h2>Students</h2>

- 2025: David Herbert de Souza Brito, Computer Engineering Program, University of Brasília.
- 2025: Maycon Vinnicyus Silva Fabio, Computer Science Program, University of Brasília.
