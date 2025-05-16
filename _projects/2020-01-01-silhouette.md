---
title: Silhouette Codec
date: 2020-01-01
subtitle: Dyadic Decomposition for Point Cloud Compression
image: '/images/silhouette/silhouette.png'
---

The majority of point cloud geometry compression techniques are based on octree representations, which, while efficient, may not fully exploit spatial and temporal redundancies in voxelized point cloud data.
As the demand for lossless and compact representation of dynamic point clouds grows—especially in applications like telepresence, autonomous navigation, and 3D scanning—alternative methods are needed to improve compression efficiency without sacrificing fidelity.

<h2>Proposed Solution</h2>

This project explores a codec based on dyadic decomposition, which partitions a voxelized point cloud into silhouettes along a chosen axis.
Each silhouette summarizes a region using binary images derived from boolean OR operations across voxel slices.
These silhouettes form the nodes of a binary tree used to guide context-based arithmetic encoding.

Two versions of the codec have been developed:

- Silhouette 3D (S3D): For intra-frame compression, using 2D and 3D context images to guide encoding.
- Silhouette 4D (S4D): For inter-frame compression, extending context sourcing to include corresponding regions in a reference frame (temporal redundancy).

A recent extension introduces context selection, a pre-processing step that dynamically chooses the most informative context pixels from a large candidate set across 2D, 3D, and 4D regions.
This results in improved compression, outperforming previous versions by up to 10% on JPEG Pleno datasets, while remaining competitive with state-of-the-art lossy codecs like MPEG G-PCC.

<h2>Potential Impact</h2>

Silhouette coding provides a mathematically elegant, context-adaptive alternative to traditional octree-based methods.
Its recursive structure, context flexibility, and compatibility with arithmetic coding make it particularly well-suited for high-fidelity applications where lossless compression is critical.
The modular design also allows extensions for learning-based optimizations and cross-modal encoding, making it a strong candidate for future point cloud compression standards.

<h2>References</h2>

O. T. Komatsu, E. Medeiros, L. M. Alves and E. Peixoto, "Multithreaded Algorithms for Lossless Intra Compression of Point Cloud Geometry Based on the Silhouette 3d Coder," 2023 IEEE International Conference on Image Processing (ICIP), Kuala Lumpur, Malaysia, 2023, pp. 1880-1884, doi: 10.1109/ICIP49359.2023.10222713.

E. Ramalho, E. Peixoto and E. Medeiros, "Silhouette 4D With Context Selection: Lossless Geometry Compression of Dynamic Point Clouds," in IEEE Signal Processing Letters, vol. 28, pp. 1660-1664, 2021, doi: 10.1109/LSP.2021.3102525

E. Peixoto, E. Medeiros and E. Ramalho, "Silhouette 4d: An Inter-Frame Lossless Geometry Coder Of Dynamic Voxelized Point Clouds," 2020 IEEE International Conference on Image Processing (ICIP), Abu Dhabi, United Arab Emirates, 2020, pp. 2691-2695, doi: 10.1109/ICIP40778.2020.9190648

D. R. Freitas, E. Peixoto, R. L. de Queiroz and E. Medeiros, "Lossy Point Cloud Geometry Compression Via Dyadic Decomposition," 2020 IEEE International Conference on Image Processing (ICIP), Abu Dhabi, United Arab Emirates, 2020, pp. 2731-2735, doi: 10.1109/ICIP40778.2020.9190910

E. Peixoto, "Intra-Frame Compression of Point Cloud Geometry Using Dyadic Decomposition," in IEEE Signal Processing Letters, vol. 27, pp. 246-250, 2020, doi: 10.1109/LSP.2020.2965322

R. Rosário and E. Peixoto, "Intra-Frame Compression of Point Cloud Geometry using Boolean Decomposition," 2019 IEEE Visual Communications and Image Processing (VCIP), Sydney, NSW, Australia, 2019, pp. 1-4, doi: 10.1109/VCIP47243.2019.8965783.

<h2>Colaborators</h2>

- Prof. Eduardo Peixoto, University of Brasília.
- Prof. Ricardo L de Queiroz, University of Brasilia.
- Otho T Komatsu, Master's in Computer Science, University of Brasília.
- Evaristo Ramalho, Master's in Computer Science, University of Brasília.
- Lucas M Alves, University of Brasília.
- Davi R Freitas, University of Brasília.
- Eduardo Lemos Rocha, University of Brasília.
- Estevam Albuquerque, University of Brasília.
- Rodrigo Borba Pinheiro, University of Brasília.
