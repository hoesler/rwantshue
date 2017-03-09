context("hcl")

test_that("all presets are valid hcl color space definitions", {
  for (color_space in names(hcl_presets)) {
  	expect_true(is.hcl(hcl_presets[[color_space]]), info = color_space)
  }
})