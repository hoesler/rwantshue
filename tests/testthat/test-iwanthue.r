context("iwanthue")

test_that("ga creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n, mode = "ga")

  # then
  expect_equal(length(palette), n)
})

test_that("kmeans creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n, mode = "kmeans")

  # then
  expect_equal(length(palette), n)
})

test_that("js_kmeans creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n, mode = "js_kmeans")

  # then
  expect_equal(length(palette), n)
})

test_that("js_force creates the correct number of colors", {
  # given 
  n <- 10
  
  # when
  palette <- iwanthue(n, mode = "js_force")

  # then
  expect_equal(length(palette), n)
})

test_that("palette method aceepts a valid color space", { 
  # when
  palette <- iwanthue(color_space = list(L = c(0, 100), C = c(0, 100), H = c(0, 360)))

  # then
  expect_is(palette, "character")
})