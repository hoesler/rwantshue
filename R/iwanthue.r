#' @include hcl.r
NULL

#' IWantHue palette generator.
#'
#' @field v8 The V8 context.
#' @export
IWantHue <- setRefClass("IWantHue",
  fields = list(v8 = "ANY"),
  methods = list(
  	initialize = function(context, seed) {
  		v8 <<- context;
		v8$source(system.file("chroma.js", package = "rwantshue"))
		v8$source(system.file("chroma.palette-gen.js", package = "rwantshue"))
		v8$source(system.file("lodash.js", package = "rwantshue"))
		v8$source(system.file("mersenne-twister.js", package = "rwantshue"))
		if (is.numeric(seed)) {
			v8$assign("seed", as.integer(seed))
			v8$eval("var rng = new MersenneTwister(seed)")
		} else {
			v8$eval("var rng = new MersenneTwister()")
		}
		v8$eval("iwanthue = function(n, force_mode, quality, js_color_mapper, color_space) {
			filter_colors = function(color) {
			    var hcl = color.hcl();
			    return hcl[0] >= color_space[0][0] && hcl[0] <= color_space[0][1]
			      && hcl[1] >= color_space[1][0] && hcl[1] <= color_space[1][1]
			      && hcl[2] >= color_space[2][0] && hcl[2] <= color_space[2][1];
			}
			var colors = paletteGenerator.generate(n, filter_colors, force_mode, quality, false, rng.random.bind(rng));
			colors = paletteGenerator.diffSort(colors);
			colors = _.map(colors, js_color_mapper);
			return JSON.stringify(colors);
		}")
  	},
  	palette = function(n = 8, force_mode = FALSE, quality = 50, color_space = hcl_presets$full,
  		js_color_mapper = "function(color) { return color.hex(); }") {
  		"Generate a new iwanthue palette"
  		assert_that(is.numeric(n), length(n) == 1)
  		assert_that(is.logical(force_mode), length(force_mode) == 1)
  		assert_that(is.numeric(quality), length(quality) == 1)
  		assert_that(is.hcl(color_space))
  		assert_that(is.character(js_color_mapper))
  		json <- v8$call("iwanthue", as.integer(n), force_mode, as.integer(quality), JS(js_color_mapper), color_space)
  		jsonlite::fromJSON(json)
  	},
    hex = function(...) {
	  	"Generate a vector of colors in hex format"
	  	.self$palette(...)	  	
	},
	rgb = function(...) {
		"Generate a matrix of colors in rgb format"
		.self$palette(..., js_color_mapper = "function(color) { return color.rgb; }")
	}
  )
)

#' The environemnt that holds a IWantHue instance
singletonEnv <- new.env()

#' IWantHue instance accessor
#' @param seed The seed for the rng
#' @param force_init If true, force recreation of the instance
inwanthueInstance <- function(seed, force_init) {
	if (force_init == TRUE || !exists("IWantHueInstance", envir = singletonEnv)) {
		assign("IWantHueInstance", IWantHue$new(V8::new_context(), seed), envir = singletonEnv)		
	}
	get("IWantHueInstance", envir = singletonEnv)
}

#' Get the \linkS4class{IWantHue} instance.
#' @inheritParams inwanthueInstance
#' 
#' @export
iwanthue <- function(seed = NULL, force_init = FALSE) {
	inwanthueInstance(seed, force_init)
}
