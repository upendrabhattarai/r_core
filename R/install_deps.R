# ---- Dependency registry -------------------------------------------------------
# All packages used across rcore templates, classified by source.
# This is the single source of truth — update here to add/remove dependencies.

.rcore_deps <- list(

  # Packages available on CRAN
  cran = c(
    "caTools", "clustree", "cowplot", "data.table", "DT",
    "future", "ggplot2", "ggpubr", "ggrepel", "ggvenn",
    "glue", "gridExtra", "hdf5r", "httr", "janitor",
    "kableExtra", "knitr", "lme4", "Matrix", "msigdbr",
    "optparse", "patchwork", "pheatmap", "purrr", "qs",
    "quadprog", "rmarkdown", "rstudioapi", "scales",
    "Seurat", "SeuratObject", "Signac", "tidyverse",
    "UpSetR", "viridis", "viridisLite"
  ),

  # Packages available on Bioconductor
  bioc = c(
    "apeglm",
    "ChIPpeakAnno",
    "ChIPseeker",
    "ComplexHeatmap",
    "DEGreport",
    "DESeq2",
    "DiffBind",
    "EnhancedVolcano",
    "EnsDb.Hsapiens.v86",
    "fgsea",
    "IlluminaHumanMethylationEPICv2anno.20a1.hg38",
    "IlluminaHumanMethylationEPICv2manifest",
    "MAST",
    "methylclock",
    "minfi",
    "rtracklayer",
    "sccomp",
    "SingleCellExperiment",
    "speckle",
    "SummarizedExperiment"
  ),

  # Packages only available via GitHub (owner/repo format)
  github = c(
    "prabhakarlab/Banksy",
    "sqjin/CellChat",
    "satijalab/seurat-wrappers",
    "dmcable/spacexr"
  )
)

# ---- Analysis-type subsets -----------------------------------------------------
# Maps each analysis type to the packages it specifically needs.
# Core packages (ggplot2, tidyverse, knitr, etc.) are always installed.

.rcore_analysis_deps <- list(
  base       = character(0),
  rnaseq     = c("DESeq2", "DEGreport", "apeglm", "EnhancedVolcano",
                 "fgsea", "msigdbr", "pheatmap", "ggrepel", "DT"),
  chipseq    = c("DESeq2", "DEGreport", "ChIPpeakAnno", "ChIPseeker",
                 "DiffBind", "rtracklayer", "UpSetR", "pheatmap",
                 "ggrepel", "DT", "janitor"),
  singlecell = c("Seurat", "SeuratObject", "Signac", "SingleCellExperiment",
                 "SummarizedExperiment", "DESeq2", "DEGreport", "MAST",
                 "EnhancedVolcano", "harmony", "clustree", "patchwork",
                 "qs", "pheatmap", "viridis", "speckle", "sccomp",
                 "future", "lme4"),
  spatial    = c("Seurat", "SeuratObject", "Signac", "qs", "patchwork",
                 "EnsDb.Hsapiens.v86", "prabhakarlab/Banksy",
                 "dmcable/spacexr", "ComplexHeatmap"),
  methylation = c("minfi", "methylclock",
                  "IlluminaHumanMethylationEPICv2manifest",
                  "IlluminaHumanMethylationEPICv2anno.20a1.hg38",
                  "DEGreport", "pheatmap"),
  multiomics = c("Seurat", "SeuratObject", "Signac", "SingleCellExperiment",
                 "EnsDb.Hsapiens.v86", "qs", "patchwork", "future",
                 "ComplexHeatmap"),
  cellchat   = c("sqjin/CellChat", "Seurat", "qs", "patchwork")
)


#' Install rcore template dependencies
#'
#' Installs all R packages required to run rcore report templates.
#' Handles CRAN, Bioconductor, and GitHub-only packages automatically.
#'
#' @param type Character; which set of dependencies to install.
#'   `"core"` installs only the lightweight packages needed to load rcore
#'   itself.  `"all"` installs every package used across all templates.
#'   Named analysis types install only what that workflow needs:
#'   `"rnaseq"`, `"chipseq"`, `"singlecell"`, `"spatial"`,
#'   `"methylation"`, `"multiomics"`, `"cellchat"`.
#'   Default: `"core"`.
#' @param ask Logical; passed to [BiocManager::install()]. Set `FALSE` for
#'   non-interactive / scripted installs.  Default `TRUE`.
#' @param upgrade Character; passed to [BiocManager::install()].
#'   `"never"`, `"default"`, or `"always"`. Default `"never"`.
#'
#' @return Invisibly returns a list with elements `cran`, `bioc`, and
#'   `github` listing what was attempted.
#' @export
#'
#' @examples
#' \dontrun{
#'   # Minimal install (just rcore itself works)
#'   install_rcore_deps()
#'
#'   # Install everything needed for RNA-seq reports
#'   install_rcore_deps("rnaseq")
#'
#'   # Install everything needed for single-cell reports
#'   install_rcore_deps("singlecell")
#'
#'   # Install ALL dependencies (takes a while)
#'   install_rcore_deps("all")
#' }
install_rcore_deps <- function(type = "core",
                               ask     = TRUE,
                               upgrade = "never") {

  # ---- Validate type ----
  valid_types <- c("core", "all", names(.rcore_analysis_deps))
  if (!type %in% valid_types) {
    stop(
      "'type' must be one of: ",
      paste(valid_types, collapse = ", ")
    )
  }

  # ---- Resolve package lists ----
  if (type == "core") {
    pkgs_cran   <- c("remotes", "BiocManager", "ggplot2", "knitr",
                     "rmarkdown", "DT", "patchwork", "qs")
    pkgs_bioc   <- character(0)
    pkgs_github <- character(0)
  } else if (type == "all") {
    pkgs_cran   <- .rcore_deps$cran
    pkgs_bioc   <- .rcore_deps$bioc
    pkgs_github <- .rcore_deps$github
  } else {
    analysis_pkgs <- .rcore_analysis_deps[[type]]
    all_cran   <- .rcore_deps$cran
    all_bioc   <- .rcore_deps$bioc
    all_github <- .rcore_deps$github
    all_github_names <- sub(".*/", "", all_github)

    pkgs_cran   <- intersect(analysis_pkgs, all_cran)
    pkgs_bioc   <- intersect(analysis_pkgs, all_bioc)
    # Match by repo basename (e.g. "Banksy" from "prabhakarlab/Banksy")
    pkgs_github <- all_github[all_github_names %in% analysis_pkgs]
  }

  # ---- Ensure BiocManager is available ----
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    message("Installing BiocManager from CRAN...")
    install.packages("BiocManager", repos = "https://cloud.r-project.org")
  }

  # ---- Install CRAN packages ----
  if (length(pkgs_cran) > 0) {
    need_cran <- pkgs_cran[!vapply(pkgs_cran, requireNamespace,
                                   logical(1), quietly = TRUE)]
    if (length(need_cran) > 0) {
      message("\nInstalling ", length(need_cran),
              " CRAN package(s):\n  ",
              paste(need_cran, collapse = ", "))
      BiocManager::install(need_cran, ask = ask, update = FALSE,
                           upgrade = upgrade)
    } else {
      message("All CRAN packages already installed.")
    }
  }

  # ---- Install Bioconductor packages ----
  if (length(pkgs_bioc) > 0) {
    need_bioc <- pkgs_bioc[!vapply(pkgs_bioc, requireNamespace,
                                   logical(1), quietly = TRUE)]
    if (length(need_bioc) > 0) {
      message("\nInstalling ", length(need_bioc),
              " Bioconductor package(s):\n  ",
              paste(need_bioc, collapse = ", "))
      BiocManager::install(need_bioc, ask = ask, update = FALSE,
                           upgrade = upgrade)
    } else {
      message("All Bioconductor packages already installed.")
    }
  }

  # ---- Install GitHub-only packages ----
  if (length(pkgs_github) > 0) {
    if (!requireNamespace("remotes", quietly = TRUE)) {
      install.packages("remotes", repos = "https://cloud.r-project.org")
    }
    github_names <- sub(".*/", "", pkgs_github)
    need_gh <- pkgs_github[!vapply(github_names, requireNamespace,
                                   logical(1), quietly = TRUE)]
    if (length(need_gh) > 0) {
      message("\nInstalling ", length(need_gh),
              " GitHub package(s):\n  ",
              paste(need_gh, collapse = ", "))
      for (repo in need_gh) {
        message("  -> remotes::install_github('", repo, "')")
        remotes::install_github(repo, upgrade = upgrade)
      }
    } else {
      message("All GitHub packages already installed.")
    }
  }

  message("\nDone! Load the package with: library(rcore)")
  invisible(list(cran = pkgs_cran, bioc = pkgs_bioc, github = pkgs_github))
}


#' List rcore dependencies by analysis type
#'
#' Prints a summary of all packages required for each analysis type.
#'
#' @return Invisibly returns the dependency list.
#' @export
#'
#' @examples
#' list_rcore_deps()
list_rcore_deps <- function() {
  message("rcore package dependencies by analysis type")
  message(strrep("=", 50))

  for (nm in names(.rcore_analysis_deps)) {
    pkgs <- .rcore_analysis_deps[[nm]]
    if (length(pkgs) == 0L) pkgs <- "(none beyond core)"
    message(sprintf("%-14s %s", paste0(nm, ":"),
                    paste(pkgs, collapse = ", ")))
  }

  message("\nGitHub-only packages (any workflow that needs them):")
  message(paste(" ", .rcore_deps$github, collapse = "\n"))

  invisible(.rcore_analysis_deps)
}
