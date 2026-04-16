# rcore

[![R-CMD-check](https://github.com/upendrabhattarai/rcore/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/upendrabhattarai/rcore/actions/workflows/R-CMD-check.yaml)

> **Built on the shoulders of giants.**
> `rcore` is a personal extension of the excellent [`bcbioR`](https://github.com/bcbio/bcbioR) package developed by the [Harvard Chan Bioinformatics Core (HBC)](https://bioinformatics.sph.harvard.edu/). The original design, template structure, and core workflows were built as part of the HBC team — this package carries that work forward with a refreshed visual theme, colorblind-friendly palettes, streamlined dependency management, and a few extra flavors on top of that foundation. All credit for the underlying framework goes to the folks at HBC.

The goal of `rcore` is to create guidelines for NGS data interpretation based on the experience of the Harvard Chan Bioinformatics Core and everybody who contributes to this package.

## Installation

Install the package directly from GitHub:

```r
# Option 1 — remotes (most common)
install.packages("remotes")
remotes::install_github("upendrabhattarai/rcore")

# Option 2 — pak (faster, handles dependencies better)
install.packages("pak")
pak::pkg_install("upendrabhattarai/rcore")
```

Then install the dependencies for the analysis type you need:

```r
library(rcore)

rcore::install_rcore_deps("rnaseq")       # RNA-seq templates
rcore::install_rcore_deps("chipseq")      # ChIP-seq templates
rcore::install_rcore_deps("singlecell")   # Single-cell RNA-seq templates
rcore::install_rcore_deps("spatial")      # Spatial transcriptomics templates
rcore::install_rcore_deps("methylation")  # Methylation templates
rcore::install_rcore_deps("multiomics")   # Multi-omics templates
rcore::install_rcore_deps("cellchat")     # Cell-cell communication templates
rcore::install_rcore_deps("all")          # Everything (takes a while)
```

`install_rcore_deps()` handles CRAN, Bioconductor, and GitHub-only packages automatically and skips anything already installed. To see what each type needs before installing:

```r
rcore::list_rcore_deps()
```

## Quick start

### Set base project

use `setwd()` to set your current directory to the place where you want to work. The rcore functions will automatically write to whatever directory you have set.

```         
setwd("/path/to/analysis/folder")
```

The following code will pop up a Rmd template will populate that folder with HCBC data structure guidelines

```         
path="/path/to/analysis/folder"
rcore_templates(type="base", outpath=path)
rcore_templates(type="rnaseq", outpath=path)
rcore_templates(type="singlecell", outpath=path)
```

### Set RNAseq report folder

This code will populate the folder with HCBC data structure guidelines and Rmd code: **You do not need to create a reports folder prior to running this code. This will create and populate the reports folder.**

```         
rcore_templates(type="rnaseq", outpath="/path/to/analysis/folder/reports")
```

## Supported analyses

-   base/reports/example.Rmd: ![](https://img.shields.io/badge/status-stable-green)
-   [rnaseq-reports](https://github.com/bcbio/rnaseq-reports):
    -   01_quality_assessment/QC.Rmd ![](https://img.shields.io/badge/status-stable-green)
    -   02_differential_expression/DEG.Rmd ![](https://img.shields.io/badge/status-stable-green)
    -   03_functional/Nonmodel_Organism_Pathway_Analysis.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   03_functional/GSVA.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   03_functional/Immune-deconvolution.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   03_comparative/Pair-wise-comparison-analysis.Rmd: ![](https://img.shields.io/badge/status-alpha-yellow)
    -   03_comparative/Intersections.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   04_gene_patterns/WGCNA.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   05_gene_patterns/DEGpattern.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
-   [single-cell](https://github.com/bcbio/rnaseq-reports)
    -   singlecell/01_quality_assessment/scRNA_QC.Rmd
    -   01_quality_assessment/scATAC_QC.Rmd ![](https://img.shields.io/badge/status-draft-grey)
    -   02_differential_expression/scRNA_MAST.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   02_differential_expression/scRNA_pseudobulk.Rmd ![](https://img.shields.io/badge/status-alpha-yellow)
    -   singlecell/04_compositional/propeller.Rmd ![](https://img.shields.io/badge/status-draft-grey)
    -   04_compositional/sccomp.Rmd ![](https://img.shields.io/badge/status-draft-grey)
    -   05_signaling/cellchat.Rmd: ![](https://img.shields.io/badge/status-draft-grey)
-   [chipseq/02_diffbind/diffbind.Rmd](inst/templates/chipseq/02_diffbind/diffbind.Rmd): ![](https://img.shields.io/badge/status-alpha-yellow)
-   [chipseq/01_quality_assessment/QC.Rmd](inst/templates/chipseq/01_quality_assessment/QC.Rmd): ![](https://img.shields.io/badge/status-alpha-yellow)
-   [spatial/visium/01_quality_assessment/qc.Rmd](inst/templates/spatial/visium/01_quality_assessment/qc.Rmd): ![](https://img.shields.io/badge/status-draft-grey)
-   [spatial/cosmx/01_quality_assessment/QC.Rmd](inst/templates/spatial/cosmx/01_quality_assessment/QC.Rmd): ![](https://img.shields.io/badge/status-draft-grey)

### Discover more…

Go to the vignette to know more `vignette("rcore_quick_start", package="rcore")`

## How to Contribute

### Open an issue

-   If you find a bug
-   If you want a new feature
-   If you want to add code to the templates

### Modify the code

-   Clone the repository
-   Make sure you are in the `devel` branch
-   Create a new branch `git checkout -b feature1`
-   Modify you code, add and commit
-   Push to GitHub the new branch
-   Create a PR from your branch to `devel`
-   Assignt the PR to me or Alex

Some best practices when developing:

-   install `devtools`
-   Use `usethis::use_import_from("stringr","str_replace_all")` to add a new function you are using in the code.

### Contributors

-   Lorena Pantano
-   Alex Bartlett
-   Emma Berdan
-   Heather Wick
-   James Billingsley
-   Zhu Zhuo
-   Elizabeth Partan
-   Noor Sohail
-   Meeta Mistry
-   Will Gammerdinger
-   Upen Bhattarai
-   Shannan Ho Sui
