# rwantshue
[![Build Status](https://travis-ci.org/hoesler/rwantshue.svg?branch=master)](https://travis-ci.org/hoesler/rwantshue)

> Generate an [i want hue](http://tools.medialab.sciences-po.fr/iwanthue/) color palette in R.

## Install
Use [devtools](https://github.com/hadley/devtools) to install:

```R
devtools::install_github("hoesler/rwantshue")
```

## Usage
```R
library('rwantshue')

# create a color scheme object
scheme <- iwanthue() # get the iwanthue singleton
scheme <- iwanthue(seed = 42, force_init = TRUE) # recreate with a seed

# generate a new color palette (vector of hex values) with presets...
scheme$hex(10)
scheme$hex(10, color_space = hcl_presets$fluo)

# ... or make custom adjustments:
color_space <- list(
	c(330, 360),	# hue range [0,360]
	c(0, 3),		# chroma range [0,3]
	c(0, 1.5))		# lightness range [0,1.5]
palette <- scheme$hex(
	n = 8,
	force_mode = FALSE,
	quality = 50,
	color_space = color_space)
	
# use it in a plot
plot(1:8, col = scheme$hex(8), pch = 16, cex = 10)

# You can also fetch a rgb matrix
scheme$rgb(8)
```
