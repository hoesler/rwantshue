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
		v8$eval("iwanthue = function(n, force_mode, quality, js_color_mapper) {
			filter_colors = function(color) {
			    var hcl = color.hcl();
			    return hcl[0]>=0 && hcl[0]<=360
			      && hcl[1]>=0 && hcl[1]<=3
			      && hcl[2]>=0 && hcl[2]<=1.5;
			}
			var colors = paletteGenerator.generate(n, filter_colors, force_mode, quality);
			colors = paletteGenerator.diffSort(colors);
			colors = _.map(colors, js_color_mapper);
			return JSON.stringify(colors);
		}")
  	},
  	iwanthue = function(n = 8, force_mode = FALSE, quality = 50, js_color_mapper) {
  		json <- v8$call("iwanthue", n, force_mode, quality, js_color_mapper)
  		fromJSON(json)
  	},
    hex = function(...) {
	  	"Generate a vector of colors in hex format"
	  	.self$iwanthue(..., js_color_mapper = I("function(color) { return color.hex(); }"))	  	
	},
	rgb = function(...) {
		"Generate a matrix of colors in rgb format"
		.self$iwanthue(..., js_color_mapper = I("function(color) { return color.rgb; }"))
	}
  )
)

#' Create a new \linkS4class{IWantHue} object.
#' 
#' @export
iwanthue <- function() {
	IWantHue$new(new_context())
}