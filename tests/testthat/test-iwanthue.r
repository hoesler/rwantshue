context("iwanthue")

test_that("hex creates a vector of hex values", { 
  # when
  palette <- iwanthue()

  # then
  expect_is(palette, "character")
  expect_match(palette, "#[0-9A-F]{6}")
})

test_that("hex creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n)

  # then
  expect_equal(length(palette), n)
})

test_that("rgb creates a matrix of 3 rgb values", { 
  # when
  palette <- iwanthue(mode = "rgb")

  # then
  expect_is(palette, "matrix")
  expect_true(is.numeric(palette))
  expect_equal(ncol(palette), 3)
})

test_that("rgb creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n, mode = "rgb")

  # then
  expect_equal(nrow(palette), n)
})

test_that("palette method aceepts a valid color space", { 
  # when
  palette <- iwanthue(color_space = list(c(0, 360), c(0, 3), c(0, 1.5)))

  # then
  expect_is(palette, "character")
})