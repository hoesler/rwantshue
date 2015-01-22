context("iwanthue")

test_that("iwanthue creates a vector of hex values", {
  # given 
  scheme <- iwanthue()
  
  # when
  palette <- scheme$hex()

  # then
  expect_is(palette, "character")
  expect_match(palette, "#[0-9A-F]{6}")
})

test_that("iwanthue creates the correct number of colors", {
  # given 
  scheme <- iwanthue()
  n <- 10
  
  # when
  palette <- scheme$hex(n)

  # then
  expect_equal(length(palette), n)
})