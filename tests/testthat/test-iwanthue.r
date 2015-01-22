context("iwanthue")

test_that("iwanthue creates a vector of hex values", {
  # given 
  generator <- iwanthue()
  
  # when
  palette <- generator$generate()

  # then
  expect_is(palette, "character")
  expect_match(palette, "#[0-9A-F]{6}")
})

test_that("iwanthue creates the correct number of colors", {
  # given 
  generator <- iwanthue()
  n <- 10
  
  # when
  palette <- generator$generate(n)

  # then
  expect_equal(length(palette), n)
})