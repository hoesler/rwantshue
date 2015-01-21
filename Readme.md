# rwantshue

> Generate an [i want hue](http://tools.medialab.sciences-po.fr/iwanthue/) color palette.

## Install
Use [devtools](https://github.com/hadley/devtools) to install:

```
devtools::install_github("hoesler/rwantshue")
```

## Usage
```
generator <- iwanthue()
palette <- generator$generate(n = 8, force_mode = FALSE, quality = 50)
```