options(repos = c(CRAN = "https://cloud.r-project.org"))
options(BioC_mirror = "https://bioconductor.org")

install.packages("BiocManager")
BiocManager::install("renv")
BiocManager::install(renv::dependencies(path = ".")[["Package"]])
BiocManager::install("dmcable/spacexr")
BiocManager::install("prabhakarlab/Banksy")
BiocManager::install("satijalab/seurat-wrappers")

# Only scan "scripts/" and "analysis.R"
renv::snapshot(
  prompt = FALSE,
  packages = renv::dependencies(path = ".")[["Package"]]
)
