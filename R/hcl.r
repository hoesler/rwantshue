NULL

is.hcl <- function(color_space) {
	return(is.list(color_space) && length(color_space) == 3
	&& all(sapply(color_space, function(pair) {is.numeric(pair) && length(pair) == 2}))
	&& color_space[[1]][1] < color_space[[1]][2] && color_space[[1]][1] >= 0 && color_space[[1]][2] <= 360
	&& color_space[[2]][1] < color_space[[2]][2] && color_space[[2]][1] >= 0 && color_space[[2]][2] <= 100
	&& color_space[[3]][1] < color_space[[3]][2] && color_space[[3]][1] >= 0 && color_space[[3]][2] <= 100)
}

#' A list of color space presets as defined in \url{http://tools.medialab.sciences-po.fr/iwanthue/js/presets.js}.
#' 
#' @export
hcl_presets = list(
	full = list(c(0,360), c(0,100), c(0,100)),
	default = list(c(0,360), c(30, 80), c(35, 80)),
	colorblind_friendly = list(c(0,360), c(40, 70), c(15, 85)),
	fancy_light = list(c(0,360), c(15, 40), c(70,100)),
	fancy_dark = list(c(0,360), c(8, 40), c(7, 40)),
	shades = list(c(0,240), c(0, 15), c(0,100)),
	tarnish = list(c(0,360), c(0, 15), c(30, 70)),
	pastel = list(c(0,360), c(0, 30), c(70,100)),
	pimp = list(c(0,360), c(30, 100), c(25, 70)),
	intense = list(c(0,360), c(20, 100), c(15, 80)),
	fluo = list(c(0,300), c(35, 100), c(75,100)),
	red_roses = list(c(20, 330), c(10, 100), c(35,100)),
	ochre_sand = list(c(20, 60), c(20, 50), c(35,100)),
	yellow_lime = list(c(60, 90), c(10, 100), c(35,100)),
	green_mint = list(c(90, 150), c(10, 100), c(35,100)),
	ice_cube = list(c(150, 200), c(0,100), c(35,100)),
	blue_ocean = list(c(220, 260), c(8, 80), c(0, 50)),
	indigo_night = list(c(260, 290), c(40, 100), c(35,100)),
	purple_wine = list(c(290, 330), c(0,100), c(0, 40))
)