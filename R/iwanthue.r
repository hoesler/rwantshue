#' @include color_space.r
#' @include iwanthue_native.r
NULL

#' IWantHue palette generator.
#'
#' @field v8 The V8 context.
IWantHue <- setRefClass("IWantHue",
  fields = list(v8 = "ANY"),
  methods = list(
  	initialize = function(context) {
  		v8 <<- context;
		v8$source(system.file("chroma.js", package = "rwantshue"))
		v8$source(system.file("chroma.palette-gen.js", package = "rwantshue"))
		v8$source(system.file("lodash.js", package = "rwantshue"))
		v8$eval("iwanthue = function(n, force_mode, quality, color_space) {
			filter_colors = function(color) {
			    var hcl = color.hcl();
			    return hcl[0] >= color_space['L'][0] && hcl[0] <= color_space['L'][1]
			      && hcl[1] >= color_space['C'][0] && hcl[1] <= color_space['C'][1]
			      && hcl[2] >= color_space['H'][0] && hcl[2] <= color_space['H'][1];
			}
			var colors = paletteGenerator.generate(n, filter_colors, force_mode, quality);
			colors = paletteGenerator.diffSort(colors);
			colors = _.map(colors, function(color) { return color.hex(); });
			return JSON.stringify(colors);
		}")
  	},
  	palette = function(n, force_mode, quality = 50, color_space) {
  		"Generate a new iwanthue palette"
  		assert_that(is.numeric(n), length(n) == 1)
  		assert_that(is.logical(force_mode), length(force_mode) == 1)
  		assert_that(is.numeric(quality), length(quality) == 1)
  		assert_that(is.valid_color_space(color_space))

  		json <- v8$call("iwanthue", as.integer(n), force_mode, as.integer(quality), color_space)
  		jsonlite::fromJSON(json)
  	}
  )
)

#' The environemnt that holds a IWantHue instance
singletonEnv <- new.env()

#' IWantHue instance accessor
inwanthueInstance <- function() {
	if (!exists("IWantHueInstance", envir = singletonEnv)) {
		assign("IWantHueInstance", IWantHue$new(V8::new_context()), envir = singletonEnv)
	}
	get("IWantHueInstance", envir = singletonEnv)
}

#' Generate a new iwanthue palette
#' 
#' @param n number of colors in the palette.
#' @param color_space the upper and lower limts of the hcl colors to put in the palette. Expects a list of three numerics (See \code{\link{hcl_presets}}).
#' @param mode the algorithm to use.
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
