
Templates with ![](https://img.shields.io/badge/status-stable-green) revision indicates that the components or processes have undergone comprehensive parameterization and testing.

Templates with ![](https://img.shields.io/badge/status-alpha-yellow) revision indicates that the components or processes are currently being tested. There is some test data available, but there are parameters that need to be set up manually within the code.

Templates with ![](https://img.shields.io/badge/status-draft-grey) revision indicates that the components or processes are not fully tested. There is no test data available, parameters need to be set up manually within the code, and specific code changes are required based on the data used.

# Guidelines for downstream analysis

- Set the working directory to the directory containing this README. We recommend using a [Project](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects) in Rstudio.
- Use [install_dependencies.R](install_dependencies.R) to install all packages used in these reports.

## Quick Start

This repository contains templates for COSMX and Visium[HD] data. Inside each folder you will find the different analyses we have available now.

### Install Dependencies with Rstudio

```
source("install_depedencies.R")
```
### Install Test Data with Rstudio

**Visium HD**

This script will download the [test data](https://zenodo.org/records/15784846) needed for the visium reports.

```
source("visium/download-test-data.R")
```

## Downstream analysis

Before using any template, go the `VISUM` or `COSMX` folder and:

1. **Modify** [information.R](information.R) with the right information. You can use this file with any template to include the project/analysis information.
2. **Modify** the `YAML` header of the `qmd` files to choose the right parameters for that report.

- For Visium, we work from Seurat objects.

### Quality assessment

![](https://img.shields.io/badge/status-draft-grey) [cosmx/01_quality_assessment/qc.Rmd](cosmx/01_quality_assessment/qc.Rmd) is a template for **COSMX** QC metrics.

![](https://img.shields.io/badge/status-draft-grey) [visium/01_quality_assessment/qc.Rmd](cosmx/01_quality_assessment/quality_assessment.qmd) is a template for **Visium[HD]** QC metrics. [See an example](https://bcbio.github.io/spatial-reports/visium/01_quality_assessment/quality_assessment.html).

### Clustering and Annotation

![](https://img.shields.io/badge/status-draft-grey) [visium/02_clustering_annotation/02_Clustering_Annotation.rmd](visium/02_clustering_annotation/02_Clustering_Annotation.rmd) is a template for clustering and annotation with Seurat and [Banksy](https://github.com/prabhakarlab/Banksy) (clustering spatial omics data) and [spacexr](https://github.com/dmcable/spacexr) (cell type identification and cell type-specific differential expression in spatial transcriptomics). [See an example](https://bcbio.github.io/spatial-reports/visium/02_clustering_annotation/02_Clustering_Annotation.html).
