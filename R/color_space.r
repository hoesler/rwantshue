NULL

is.valid_color_space <- function(color_space) {
	return(is.list(color_space) && length(color_space) == 3
	&& all(sapply(color_space, function(pair) {is.numeric(pair) && length(pair) == 2})))
}

#' A list of color space presets as defined in \url{http://tools.medialab.sciences-po.fr/iwanthue/js/presets.js}.
#' 
#' @export
hcl_presets = list(
	full = list(H = c(0, 360), C = c(0, 100), L = c(0, 100)),
	fancy_light = list(H = c(0, 360), C = c(13.333, 40), L = c(66.6, 120))
	# fancy_light = list(H = c(0, 360), C = c(0.4, 1.2), L = c(1, 1.5)),
	# fancy_dark = list(H = c(0, 360), C = c(0.2, 1.2), L = c(0.1, 0.6)),
	# shades = list(H = c(0, 240), C = c(0, 0.4), L = c(0, 1.5)),
	# tarnish = list(H = c(0, 360), C = c(0, 0.4), L = c(0.4, 1.1)),
	# pastel = list(H = c(0, 360), C = c(0, 0.9), L = c(1, 1.5)),
	# pimp = list(H = c(0, 360), C = c(0.9, 3), L = c(0.4, 1)),
	# intense = list(H = c(0, 360), C = c(0.6, 3), L = c(0.2, 1.1)),
	# fluo = list(H = c(0, 300), C = c(1, 3), L = c(1.1, 1.5)),
	# red_roses = list(H = c(20, 330), C = c(0.3, 3), L = c(0.5, 1.5)),
	# ochre_sand = list(H = c(20, 60), C = c(0.3, 1.6), L = c(0.5, 1.5)),
	# yellow_lime = list(H = c(60, 90), C = c(0.3, 3), L = c(0.5, 1.5)),
	# green_mint = list(H = c(90, 150), C = c(0.3, 3), L = c(0.5, 1.5)),
	# ice_cube = list(H = c(150, 200), C = c(0, 3), L = c(0.5, 1.5)),
	# blue_ocean = list(H = c(220, 260), C = c(0.2, 2.5), L = c(0, 0.8)),
	# indigo_night = list(H = c(260, 290), C = c(1.2, 3), L = c(0.5, 1.5)),
	# purple_white = list(H = c(290, 330), C = c(0, 3), L = c(0, 0.6))
)