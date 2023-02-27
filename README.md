# An automated pipeline to create an atlas of *in situ* hybridization gene expression data in the adult marmoset brain

We provide the code for **An automated pipeline to create an atlas of *in situ* hybridization gene expression data in the adult marmoset brain**, by Charissa Poon, Muhammad Febrian Rachmadi, Michal Byra, Matthias Schlachter, Tomomi Shimogori, and Henrik Skibbe, to be presented in ISBI 2023. (to be linked soon)

## Abstract
We present the first automated pipeline to create an atlas of *in situ* hybridization (ISH) gene expression in the adult marmoset brain in the same stereotaxic space. The pipeline consists of segmentation of gene expression from microscopy images and registration of images to a standard space. Automation of this pipeline is necessary to analyze the large volume of data in the genome-wide whole brain dataset, and to process images that have varying intensity profiles and gene expression patterns with minimal human bias. To reduce the number of labelled images required for training, we develop a semi-supervised segmentation model. We further develop an iterative algorithm to register images to a standard space, enabling comparative analysis between genes and concurrent visualization with other imaging data, thereby facilitating a more holistic understanding of primate brain development, structure, and function.

## ISH images
ISH images of the neonate and adult marmoset have been collected by the Shimogori Lab at RIKEN CBS as part of the [Brain Mapping by Integrated Neurotechnologies for Disease Studies](https://brainminds.jp/en/) project in Japan. Images can be accessed in the [Marmoset Gene Atlas](https://gene-atlas.brainminds.jp/).
The following publications describe data collection and ISH processing:
- [Shimogori, T., *et al.*, Digital gene atlas of neonate common marmoset brain, Neurosci Res. 2018 128:1-13. doi: 10.1016/j.neures.2017.10.009.](https://pubmed.ncbi.nlm.nih.gov/29111135/)
- [Kita, Y., *et al.*, Cellular-resolution gene expression profiling in the neonatal marmoset brain reveals dynamic species- and region-specific differences, PNAS 2021 118(18):e2020125118. doi: 10.1073/pnas.2020125118.](https://www.markdownguide.org/basic-syntax/)

## Segmentation
The segmentation model has a U-Net architecture and uses the contrastive loss and augmentations presented in the [SimCLR paper](https://arxiv.org/abs/2002.05709).

## Registration
We first register ISH gene images to backlit and blockface images within each marmoset. Aligned images are then registered to the [Brain/Minds Marmoset Connectivity Atlas](https://www.biorxiv.org/content/10.1101/2022.06.06.494999v1) template. 
- [Skibbe, H., *et al.*, The Brain/MINDS Marmoset Connectivity Atlas: exploring bidirectional tracing and tractography in the same stereotaxic space, bioRxiv 2022.06.06.494999. doi: https://doi.org/10.1101/2022.06.06.494999 ](https://www.biorxiv.org/content/10.1101/2022.06.06.494999v1)
