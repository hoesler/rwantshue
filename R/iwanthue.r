#' @include hcl.r
NULL

#' IWantHue palette generator.
#'
#' @field v8 The V8 context.
#' @export
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
  	palette = function(n = 8, force_mode = FALSE, quality = 50, color_space = hcl_presets$fancy_light,
  		js_color_mapper = "function(color) { return color.hex(); }") {
  		"Generate a new iwanthue palette"
  		assert_that(is.numeric(n), length(n) == 1)
  		assert_that(is.logical(force_mode), length(force_mode) == 1)
  		assert_that(is.numeric(quality), length(quality) == 1)
  		assert_that(is.hcl(color_space))
  		assert_that(is.character(js_color_mapper))
  		json <- v8$call("iwanthue", as.integer(n), force_mode, as.integer(quality), I(js_color_mapper), color_space)
  		fromJSON(json)
  	},
    hex = function(...) {
	  	"Generate a vector of colors in hex format"
	  	.self$palette(...)	  	
	},
	rgb = function(...) {
		"Generate a matrix of colors in rgb format"
		.self$palette(..., js_color_mapper = I("function(color) { return color.rgb; }"))
	}
  )
)

#' Create a new \linkS4class{IWantHue} object.
#' 
#' @export
iwanthue <- function() {
	IWantHue$new(new_context())
}