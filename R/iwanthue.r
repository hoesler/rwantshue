#' @include color_space.r
#' @include iwanthue_native.r
#' @include iwanthue_js.r
NULL

#' Generate a new iwanthue palette
#' 
#' @param n number of colors in the palette.
#' @param color_space the upper and lower limts of the hcl colors to put in the palette. Expects a list of three numerics (See \code{\link{hcl_presets}}).
#' @param mode the algorithm to use. One of ("ga", "kmenas", "js_kmeans", "js_force")
#' 
#' @return a new rgb hex color palette of length \code{n}.
#' 
#' @export
iwanthue <- function(n = 8, color_space = list(L = c(0,100), C = c(0,100), H = c(0,360)), mode = "ga", ...) {
	assert_that(is.numeric(n), length(n) == 1)
	if (is.character(color_space)) {
		assert_that(length(color_space) == 1)
		if (color_space %in% names(hcl_presets)) {
			color_space <- hcl_presets[color_space]
		} else {
			stop("No preset defined for ", color_space)
		}
	} else {
		assert_that(is.valid_color_space(color_space))
	}
	assert_that(is.character(mode), length(mode) == 1)

	switch(mode,
	  kmeans = iwanthue.kmeans(n, color_space, ...),
	  ga = iwanthue.ga(n, color_space, ...),
	  js_kmeans = inwanthueInstance()$palette(n, force_mode = FALSE, color_space = color_space),
	  js_force = inwanthueInstance()$palette(n, force_mode = TRUE, color_space = color_space),
	  stop(sprintf("Unsupported mode: %s", mode))
	)
}
