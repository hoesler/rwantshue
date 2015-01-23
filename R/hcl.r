NULL

is.hcl <- function(color_space) {
	return(is.list(color_space) && length(color_space) == 3
	&& all(sapply(color_space, function(pair) {is.numeric(pair) && length(pair) == 2}))
	&& color_space[[1]][1] < color_space[[1]][2] && color_space[[1]][1] >= 0 && color_space[[1]][2] <= 360
	&& color_space[[2]][1] < color_space[[2]][2] && color_space[[2]][1] >= 0 && color_space[[2]][2] <= 3
	&& color_space[[3]][1] < color_space[[3]][2] && color_space[[3]][1] >= 0 && color_space[[3]][2] <= 1.5)
}

#' A list of color space presets as defined in \url{http://tools.medialab.sciences-po.fr/iwanthue/js/presets.js}.
#' 
#' @export
hcl_presets = list(
	full = list(c(0, 360), c(0, 3), c(0, 1.5)),
	fancy_light = list(c(0, 360), c(0.4, 1.2), c(1, 1.5)),
	fancy_dark = list(c(0, 360), c(0.2, 1.2), c(0.1, 0.6)),
	shades = list(c(0, 240), c(0, 0.4), c(0, 1.5)),
	tarnish = list(c(0, 360), c(0, 0.4), c(0.4, 1.1)),
	pastel = list(c(0, 360), c(0, 0.9), c(1, 1.5)),
	pimp = list(c(0, 360), c(0.9, 3), c(0.4, 1)),
	intense = list(c(0, 360), c(0.6, 3), c(0.2, 1.1)),
	fluo = list(c(0, 300), c(1, 3), c(1.1, 1.5)),
	red_roses = list(c(20, 330), c(0.3, 3), c(0.5, 1.5)),
	ochre_sand = list(c(20, 60), c(0.3, 1.6), c(0.5, 1.5)),
	yellow_lime = list(c(60, 90), c(0.3, 3), c(0.5, 1.5)),
	green_mint = list(c(90, 150), c(0.3, 3), c(0.5, 1.5)),
	ice_cube = list(c(150, 200), c(0, 3), c(0.5, 1.5)),
	blue_ocean = list(c(220, 260), c(0.2, 2.5), c(0, 0.8)),
	indigo_night = list(c(260, 290), c(1.2, 3), c(0.5, 1.5)),
	purple_white = list(c(290, 330), c(0, 3), c(0, 0.6))
)