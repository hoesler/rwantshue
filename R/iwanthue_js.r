#' @include color_space.r
NULL

#' IWantHue palette generator.
#'
#' @field v8 The V8 context.
IWantHue <- setRefClass("IWantHue",
  fields = list(v8 = "ANY"),
  methods = list(
  	initialize = function(context) {
  		v8 <<- context;
		v8$source(system.file("chroma_1.6.2.js", package = "rwantshue"))
		v8$source(system.file("lodash.js", package = "rwantshue"))
		v8$source(system.file("chroma.palette-gen.new.js", package = "rwantshue"))
		v8$eval("
			normalize_lch = function(lch) {
				// normalize output of chroma.lch() to [0,100] [0,100] [0,360]
				var l = lch[0] / 1.0000000386666655;
			    var c = lch[1] / 1.3380761485376166;
				var h = ((lch[2] + 360) % 360);
				return [l, c, h];
			}

			iwanthue = function(n, force_mode, quality, color_space) {
				filter_colors = function(color) {
				    var lch = color.lch();
				    var normalized_lch = normalize_lch(lch);

				    // normalize
				    var l = normalized_lch[0];
				    var c = normalized_lch[1];
				    var h = normalized_lch[2];

				    var l_lower = color_space['L'][0];
				    var l_upper = color_space['L'][1];
				    var c_lower = color_space['C'][0];
				    var c_upper = color_space['C'][1];
				    var h_lower = color_space['H'][0];
				    var h_upper = color_space['H'][1];

				    return l >= l_lower && l <= l_upper &&
				    	c >= c_lower && c <= c_upper &&
				    	h >= h_lower && h <= h_upper;
				}
				var colors = paletteGenerator.generate(n, filter_colors, force_mode, quality);
				colors = paletteGenerator.diffSort(colors);
				colors = _.map(colors, function(color) { return color.hex(); });
				return JSON.stringify(colors);
			}
		")
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