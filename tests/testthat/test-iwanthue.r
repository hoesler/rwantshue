context("iwanthue")

test_that("hex creates a vector of hex values", {
  # given 
  scheme <- iwanthue()
  
  # when
  palette <- scheme$hex()

  # then
  expect_is(palette, "character")
  expect_match(palette, "#[0-9A-F]{6}")
})

test_that("hex creates the correct number of colors", {
  # given 
  scheme <- iwanthue()
  n <- 10
  
  # when
  palette <- scheme$hex(n)

  # then
  expect_equal(length(palette), n)
})

test_that("rgb creates a matrix of 3 rgb values", {
  # given 
  scheme <- iwanthue()
  
  # when
  palette <- scheme$rgb()

  # then
  expect_is(palette, "matrix")
  expect_true(is.numeric(palette))
  expect_equal(ncol(palette), 3)
})

test_that("rgb creates the correct number of colors", {
  # given 
  scheme <- iwanthue()
  n <- 10
  
  # when
  palette <- scheme$rgb(n)

  # then
  expect_equal(nrow(palette), n)
})