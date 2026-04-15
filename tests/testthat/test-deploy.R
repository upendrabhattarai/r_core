library(rcore)


test_that("scrnaseq",{
  path <- withr::local_tempdir()
  print(path)
  copy_templates(path, "singlecell")
  expect_length(fs::dir_ls(path,all=T),8)
  expect_true(grepl("scRNAseq_qc_app",
                    fs::dir_ls(file.path(path, "apps"), recurse=T, all=T)[2]))
})

test_that("base copy",{
  path <- withr::local_tempdir()
  print(path)
  rcore_templates(type="base", outpath=path)
  expect_length(fs::dir_ls(path,all=T),10)
  expect_true(file.exists(file.path(path,".gitignore")))
})

test_that("rnaseq copy",{
  path <- withr::local_tempdir()
  print(path)
  rcore_templates(type="rnaseq", outpath=path)
  expect_length(fs::dir_ls(path,all=T),6)
})
