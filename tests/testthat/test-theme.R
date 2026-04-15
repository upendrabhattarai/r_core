library(rcore)

test_that("theme_rcore returns a ggplot2 theme", {
  th <- theme_rcore()
  expect_s3_class(th, "theme")
})

test_that("theme_rcore accepts base_size argument", {
  th <- theme_rcore(base_size = 14)
  expect_s3_class(th, "theme")
})

test_that("theme_rcore can be added to a ggplot", {
  p <- ggplot2::ggplot(data.frame(x = 1:3, y = 1:3), ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    theme_rcore()
  expect_s3_class(p, "ggplot")
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("rcore_inject_css returns the CSS string invisibly", {
  # Capture output — we just check no error is thrown and CSS is non-empty
  out <- capture.output(css <- rcore_inject_css())
  expect_type(css, "character")
  expect_true(nchar(css) > 100L)
  expect_true(any(grepl("<style>", out)))
})
