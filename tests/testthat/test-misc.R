library(rcore)


test_that("rnaseq samplesheet", {

  expect_no_error(bcbio_nfcore_check(system.file("extdata", "rnaseq_good.csv", package = "rcore")))
  expect_error(bcbio_nfcore_check(system.file("extdata", "rnaseq_missing_col.csv", package = "rcore")))
  expect_error(bcbio_nfcore_check(system.file("extdata", "rnaseq_wnumber.csv", package = "rcore")))
  expect_warning(bcbio_nfcore_check(system.file("extdata", "rnaseq_na.csv", package = "rcore")))
})
