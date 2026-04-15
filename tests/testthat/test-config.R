library(rcore)

# Use a temp directory so tests never touch the real user config
withr::local_envvar(
  R_USER_DATA_DIR = withr::local_tempdir(),
  R_USER_CONFIG_DIR = withr::local_tempdir(),
  .local_envir = parent.frame()
)

test_that("rcore_get_config returns NULL before setup", {
  expect_null(rcore_get_config())
})

test_that("rcore_setup stores and retrieves author and org", {
  rcore_setup(author = "Test Lab", email = "test@example.com", org_abbr = "tlab")
  cfg <- rcore_get_config()
  expect_false(is.null(cfg))
  expect_equal(cfg[["author"]], "Test Lab")
  expect_equal(cfg[["email"]],  "test@example.com")
  expect_equal(cfg[["orgabbr"]], "tlab")
})

test_that("rcore_setup normalises org_abbr to lowercase alnum", {
  rcore_setup(author = "My Lab!", email = "", org_abbr = "My-Lab 2")
  cfg <- rcore_get_config()
  expect_equal(cfg[["orgabbr"]], "mylab2")
})

test_that("rcore_setup errors on empty author", {
  expect_error(
    rcore_setup(author = "  ", email = "", org_abbr = "x"),
    regexp = "empty"
  )
})

test_that("rcore_setup returns invisibly", {
  result <- rcore_setup(author = "Silent Lab", email = "", org_abbr = "sl")
  expect_type(result, "list")
  expect_named(result, c("author", "email", "org_abbr"))
})
