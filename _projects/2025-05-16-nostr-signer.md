---
title: NostrSigner
date: 2025-05-16
subtitle: Portable Hardware-Backed Identity for the Nostr Protocol
image: '/images/nostr-signer/nostr-signer.png'
---

Users of Nostr-based platforms, such as Primal, must currently expose their private keys (nsecs) to software clients in order to sign events.
Even when using browser extensions like Alby, which store keys locally, users must still trust general-purpose, network-connected devices to manage their cryptographic identity.
For security-conscious users—such as those who rely on hardware keys like YubiKeys for PGP and authentication—this situation is suboptimal.

There is currently no portable, hardware-native solution for managing and signing Nostr events in a way that preserves security and usability across platforms.
This limits the ability of users to safely engage with the Nostr protocol from multiple devices without compromising key custody.

<h2>Proposed Solution</h2>

This project explores the design of a hardware-based Nostr identity module.
The goal is to allow users to securely carry their Nostr identity and sign events on any device, without ever exposing their private key to untrusted software environments.

We are investigating whether existing capabilities of devices like YubiKey—such as OpenPGP Card, PIV, or FIDO2—can be adapted for Nostr’s Ed25519 signature requirements.
If not, two alternative approaches are under consideration:

- Challenge-Response Signing Module:
  Inspired by Blockstream Jade, this approach would use a blind oracle protocol to implement a "virtual secure element," allowing the user to sign Nostr events via challenge-response without the private key ever leaving the secure interface.
- Dedicated Nostr Hardware Signer:
  A specialized hardware wallet-like device tailored to signing Nostr events.
  This would support offline identity portability and offer multisig or delegated access capabilities in future iterations.

<h2>Potential Impact</h2>

A hardware-based signing solution for Nostr would fill a critical gap in the decentralized identity ecosystem.
It would empower privacy-focused users to interact with Nostr clients without compromising their keys, reduce the attack surface of Nostr identities, and extend the usability of the protocol into high-security, high-mobility contexts.
This project could also influence the development of standards around cryptographic identity portability in decentralized social protocols.

<!-- <h2>References</h2> -->
<!-- [Granola Cash](https://github.com/GranolaCash) -->

<h2>Students</h2>

- 2025: David Herbert de Souza Brito, Computer Engineering Program, University of Brasília.
