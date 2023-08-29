# Analysis of High-Grade Gastroenteropancreatic Neuroendocrine Neoplasms Dataset: Feature Selection using RENT and UBayFS
## Overview

This repository is intended to provide supplementary material for the experiments conducted in the following research article preprint:

[A. Jenul, H. L. Stokmo, S. Schrunner, M.-E. Revheim, G. O. Hjortland, and O. Tomic (2023): Towards Understanding the Survival of Patients with High-Grade Gastroenteropancreatic Neuroendocrine Neoplasms: An Investigation of Ensemble Feature Selection in the Prediction of Overall Survival, arXiv.org:2302.10106](https://doi.org/10.48550/arXiv.2302.10106)

## Structure

Experiments have been conducted in R (UBayFS) and Python (RENT), evaluations have been made in R only. The following code is available in this repository:

- Although the dataset cannot be distributed, a detailed overview of the blocks, features, and encodings is given in directory <tt>feature_overview</tt>. See [Feature overview](feature_overview/feature_overview.md).
- Code to reproduce the selected features can be found in the directories <tt>RENT</tt> and <tt>UBayFS</tt>, respectively. Feature sets produced by each method are stored as csv-files.
- In directory <tt>evaluations</tt>, scripts are provided to compute evaluation metrics and visualizations used in the abovementioned paper. See [Experiment 1](evaluations/Experiment_1.md) and [Experiment 2](evaluations/Experiment_2.md), respectively.

## Contact

For questions and suggestions, please contact the following contributors:

  - <b>Code \& methodology</b>: Anna Jenul (Norwegian University of Life Sciences) <anna.jenul@nmbu.no>
  - <b>Dataset properties \& clinical interpretation</b>: Henning Langen Stokmo (Oslo University Hospital) <h.l.stokmo@studmed.uio.no>
