NULL

#' IWantHue palette generator.
#'
#' @field v8 The V8 engine context.
#' @export
IWantHue <- setRefClass("IWantHue",
  fields = list(v8 = "ANY"),
  methods = list(
  	initialize = function() {
  		v8 <<- new_context();
		v8$source(system.file("chroma.js", package = "rwantshue"))
		v8$source(system.file("chroma.palette-gen.js", package = "rwantshue"))
		v8$source(system.file("lodash.js", package = "rwantshue"))
  	},
    hex = function(n = 8, force_mode = FALSE, quality = 50, ...) {
	  	js_code <- sprintf("
			filter_colors = function(color) {
			    var hcl = color.hcl();
			    return hcl[0]>=0 && hcl[0]<=360
			      && hcl[1]>=0 && hcl[1]<=3
			      && hcl[2]>=0 && hcl[2]<=1.5;
			}
			var colors = paletteGenerator.generate(%d, filter_colors, %s, %d);
			colors = paletteGenerator.diffSort(colors);
			colors = _.map(colors, function(color) { return color.hex(); });
			JSON.stringify(colors);
	    ", n, ifelse(force_mode, "true", "false"), quality)
	  	fromJSON(v8$eval(js_code))
	}
  )
)

#' @export
iwanthue <- function() {
	IWantHue$new()
}