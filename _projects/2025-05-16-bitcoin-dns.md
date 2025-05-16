---
title: BitDNS
date: 2025-05-16
subtitle: Decentralized DNS Resolution via Bitcoin and Nostr
image: '/images/bit-dns/bitdns.png'
---

Traditional DNS systems rely on hierarchical and centralized trust models, which introduce single points of failure, censorship risks, and reliance on certificate authorities.
Efforts to decentralize DNS have emerged over time, but many face usability or coordination challenges.
A key missing element is a reliable, censorship-resistant method for cryptographically proving domain ownership without relying on centralized registrars.

<h2>Proposed Solution</h2>

This project explores the development of a decentralized DNS service in which ownership of subdomains is anchored in the Bitcoin blockchain, and DNS records are stored as Nostr events on relays.

Domain ownership is established and proven through Bitcoin transactions, where the possession of a particular UTXO corresponds to control over a given subdomain.
This model mirrors some of the mechanics behind NFTs, where a spendable output acts as a transferable token of ownership.

DNS record metadata—such as IP addresses, TXT records, and service declarations—is published using the Nostr protocol.
The use of Nostr relays allows DNS records to be widely distributed, tamper-resistant, and resilient to censorship.
Verification of domain record authenticity is made possible by linking the signature of the Nostr events to the corresponding Bitcoin UTXO holder.

<h2>Potential Impact</h2>

BitDNS presents a novel, user-controlled model for DNS that combines the censorship resistance and immutability of Bitcoin with the real-time, flexible publish-subscribe capabilities of Nostr.
It offers an alternative naming and resolution infrastructure for applications seeking trust minimization and resilience.
This project could serve as a foundation for decentralized websites, identity systems, and service directories rooted in Bitcoin-native ownership semantics.

<!-- <h2>References</h2> -->
<!-- [Granola Cash](https://github.com/GranolaCash) -->

<h2>Students</h2>

- 2024-2025: Luigi Minardi Ferreira Maia, Computer Engineering Program, University of Brasília.
- 2024-2025: Emanuel Silva de Medeiros, Computer Engineering Program, University of Brasília.
