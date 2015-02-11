#' @include hcl.r
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
		v8$eval("iwanthue = function(n, force_mode, quality, js_color_mapper, color_space) {
			filter_colors = function(color) {
			    var hcl = color.hcl();
			    return hcl[0] >= color_space[0][0] && hcl[0] <= color_space[0][1]
			      && hcl[1] >= color_space[1][0] && hcl[1] <= color_space[1][1]
			      && hcl[2] >= color_space[2][0] && hcl[2] <= color_space[2][1];
			}
			var colors = paletteGenerator.generate(n, filter_colors, force_mode, quality);
			colors = paletteGenerator.diffSort(colors);
			colors = _.map(colors, js_color_mapper);
			return JSON.stringify(colors);
		}")
  	},
  	palette = function(n, force_mode, quality, color_space, js_color_mapper) {
  		"Generate a new iwanthue palette"
  		assert_that(is.numeric(n), length(n) == 1)
  		assert_that(is.logical(force_mode), length(force_mode) == 1)
  		assert_that(is.numeric(quality), length(quality) == 1)
  		assert_that(is.hcl(color_space))
  		assert_that(is.character(js_color_mapper))
  		json <- v8$call("iwanthue", as.integer(n), force_mode, as.integer(quality), I(js_color_mapper), color_space)
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
#' @param force_mode use force vector algorithm instead of k-means.
#' @param color_space the upper and lower limts of the hcl colors to put in the palette. Expects a list of three numerics (See \code{\link{hcl_presets}}).
#' @param quality the number of steps the algorithm should try to improve the color palette.
#' @param mode the mode of the returned colors. Supported are "hex" (default) and "rgb" at the moment.
#' 
#' @return a new color palette of length \code{n}. Depending on the \code{mode}, the returned object is a vector (hex) or a matrix (rgb).
#' 
#' @export
iwanthue <- function(n = 8, force_mode = FALSE, quality = 50, color_space = hcl_presets$full, mode = "hex") {
	scheme <- inwanthueInstance()
	js_color_mapper <- if (mode == "hex") {
		"function(color) { return color.hex(); }"
	} else if (mode == "rgb") {
		"function(color) { return color.rgb; }"
	} else {
		stop("Unsupported mode: ", mode)
	}
	scheme$palette(n, force_mode, quality, color_space, js_color_mapper)
}
