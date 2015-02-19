context("hcl")

test_that("all presets are valid hcl color space definitions", {
  for (color_space in hcl_presets) {
  	expect_true(is.valid_color_space(color_space))
  }
})