---
title: A Formal and Cryptographic Evaluation of the Cashu Protocol
date: 2025-12-02
image: ""
---

## Context and Motivation

[Cashu](https://cashu.space/) is a modern e-cash protocol based on [blind signatures](https://link.springer.com/chapter/10.1007/978-1-4757-0602-4_18) and [discrete-log equality proofs](https://github.com/bitcoin/bips/blob/master/bip-0374.mediawiki) (DLEQ).
Inspired by Chaum’s original e-cash design, the protocol allows a user to create tokens against a custodial issuer (the mint).
These tokens can't be tracked by the mint as the user make payments with them, preserving privacy while preventing double-spend.

Cashu has grown rapidly, with multiple mints and client implementations now operating in production.
However, its cryptographic foundations are not yet consolidated into a unified academic treatment.
The essential concepts — [Schnorr signatures](https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki), sigma protocols, DLEQ proofs, blinding and unblinding mechanisms — are spread across documentation, code, and informal technical discussions.

This creates a clear academic opportunity: there is no structured, rigorous, pedagogical exposition of the Cashu cryptosystem, nor a formal assessment of its assumptions, guarantees, or limitations.
For an undergraduate thesis, this topic combines accessible mathematics with meaningful real-world relevance.

1. To formally study, systematize, and evaluate the cryptographic foundations of the Cashu protocol, producing a rigorous exposition and a critical assessment of its guarantees and limitations.
2. The project involves theoretical study, technical synthesis, and analytical evaluation, providing a “mini-survey” of the protocol from first principles up to its current design.

## Objectives

Develop a clear, rigorous academic monograph that explains, formalizes, and critically evaluates the cryptographic structure of the Cashu protocol, with particular emphasis on blind signatures, token issuance, and DLEQ proofs.

Specific Objectives:

1. Explain clearly the cryptographic primitives underlying Cashu: Schnorr signatures, Sigma protocols, Discrete-log equality (DLEQ) proofs, classical and modern blind-signature schemes.
2. Reconstruct formally the core Cashu workflows: token issuance and redemption, blinding and unblinding operations, prevention of double-spending, how DLEQ proofs ensure correctness without compromising privacy.
3. Compare Cashu with Chaum’s traditional e-cash constructions, noting similarities and differences.
4. Evaluate critically: security assumptions of the protocol, the role and sufficiency of the DLEQ proofs, possible design limitations, ambiguity in the specification, or edge-case behavior, consistency between the written specification and reference implementations.
5. Identify avenues for improvement, including open questions or potential protocol extensions.

## Expected Contributions

1. A pedagogical, mathematically precise exposition of Cashu’s cryptographic mechanisms;
2. A formal reconstruction of Cashu’s token lifecycle, expressed with diagrams, equations, and clear definitions;
3. A structured evaluation of the protocol’s privacy and security guarantees;
4. A critical discussion identifying gaps, open points, or areas for further development.

Even without producing original cryptographic research, a systematic and rigorous exposition is already a significant contribution to a rapidly emerging protocol that is beginning to attract academic interest.

## Possible Extensions (Optional)

For more ambitious students, the thesis may include:

1. Formalizing Cashu’s security properties (e.g., unlinkability, correctness, blindness) in an adversarial model;
2. Proposing extensions or refinements to the protocol;
3. Implementing a minimal DLEQ demonstration module in Rust or Python, with educational test vectors;
4. Conducting a small survey comparing Cashu’s design with other modern Chaumian or e-cash systems;
5. Producing a “cryptography handbook” style appendix to accompany the protocol.

These extensions are optional and should not compromise the clarity or depth of the main analysis.
