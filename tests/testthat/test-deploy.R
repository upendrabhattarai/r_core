library(rcore)

test_that("scrnaseq", {
  path <- withr::local_tempdir()
  copy_templates(path, "singlecell")
  all_files <- fs::dir_ls(path, all = TRUE)
  expect_gt(length(all_files), 0L)
  # apps folder should be created
  expect_true(fs::dir_exists(file.path(path, "apps")))
})

test_that("base copy", {
  path <- withr::local_tempdir()
  rcore_templates(type = "base", outpath = path)
  expect_true(file.exists(file.path(path, ".gitignore")))
  expect_true(file.exists(file.path(path, "information.R")))
  expect_gt(length(fs::dir_ls(path, all = TRUE)), 0L)
})

test_that("rnaseq copy", {
  path <- withr::local_tempdir()
  rcore_templates(type = "rnaseq", outpath = path)
  expect_gt(length(fs::dir_ls(path, all = TRUE)), 0L)
})
