library(rcore)

# ---- cb_friendly_cols -------------------------------------------------------

test_that("cb_friendly_cols returns correct hex strings", {
  col <- cb_friendly_cols("deep_teal")
  expect_type(col, "character")
  expect_match(col, "^#[0-9A-Fa-f]{6}$")
})

test_that("cb_friendly_cols returns multiple colours as named vector", {
  cols <- cb_friendly_cols("deep_teal", "hot_pink", "indigo")
  expect_length(cols, 3L)
  expect_named(cols)
})

test_that("cb_friendly_cols stops on unknown colour name", {
  expect_error(cb_friendly_cols("not_a_colour"))
})

# ---- list_cb_friendly_cols --------------------------------------------------

test_that("list_cb_friendly_cols returns a named character vector", {
  cols <- list_cb_friendly_cols()
  expect_type(cols, "character")
  expect_true(length(cols) >= 16L)
  expect_true("deep_teal" %in% names(cols))
  expect_true("hot_pink"  %in% names(cols))
})

# ---- cb_friendly_pal --------------------------------------------------------

test_that("cb_friendly_pal returns a function", {
  pal <- cb_friendly_pal("main")
  expect_type(pal, "closure")
})

test_that("cb_friendly_pal function generates n colours", {
  pal  <- cb_friendly_pal("main")
  cols <- pal(5L)
  expect_length(cols, 5L)
  expect_match(cols, "^#[0-9A-Fa-f]{6}$")
})

test_that("cb_friendly_pal errors on unknown palette", {
  expect_error(cb_friendly_pal("nope"))
})

# ---- scale_color_cb_friendly / scale_fill_cb_friendly ----------------------

test_that("scale_color_cb_friendly returns a ggplot2 Scale object", {
  sc <- scale_color_cb_friendly()
  expect_s3_class(sc, "Scale")
})

test_that("scale_fill_cb_friendly returns a ggplot2 Scale object", {
  sc <- scale_fill_cb_friendly()
  expect_s3_class(sc, "Scale")
})

test_that("scale_color_cb_friendly accepts palette argument", {
  sc <- scale_color_cb_friendly(palette = "teal")
  expect_s3_class(sc, "Scale")
})
