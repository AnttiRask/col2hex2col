# col2hex2col <img src="hex-col2hex2col.png" align="right" height="139" alt="col2hex2col logo" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/AnttiRask/col2hex2col/workflows/R-CMD-check/badge.svg)](https://github.com/AnttiRask/col2hex2col/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/col2hex2col)](https://CRAN.R-project.org/package=col2hex2col)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

## Overview

**col2hex2col** provides fast and simple functions to convert between R color names and hexadecimal color codes. The name is a playful reference to "2 Fast 2 Furious" - because color conversion should be both fun and fast!

## Installation

You can install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("AnttiRask/col2hex2col")
```

Once published to CRAN, you'll be able to install with:

```r
install.packages("col2hex2col")
```

## Usage

### Convert color names to hex codes

```r
library(col2hex2col)

# Single color
color_to_hex("red")
#> [1] "#FF0000"

# Multiple colors
color_to_hex(c("red", "blue", "green"))
#> [1] "#FF0000" "#0000FF" "#00FF00"

# Works with all 657 R color names
color_to_hex(c("skyblue", "coral", "chartreuse"))
#> [1] "#87CEEB" "#FF7F50" "#7FFF00"
```

### Convert hex codes to color names

```r
# Single hex code
hex_to_color("#FF0000")
#> [1] "red"

# Multiple hex codes
hex_to_color(c("#FF0000", "#0000FF", "#00FF00"))
#> [1] "red"   "blue"  "green"

# Case insensitive
hex_to_color("#ff0000")
#> [1] "red"
```

### Round-trip conversion

```r
# Color -> Hex -> Color
colors <- c("red", "blue", "green")
hex_codes <- color_to_hex(colors)
hex_to_color(hex_codes)
#> [1] "red"   "blue"  "green"
```

## Features

- **Fast**: Uses base R functions with minimal dependencies
- **Simple**: Just two functions to remember
- **Vectorized**: Works with single values or vectors
- **Validated**: Comprehensive input validation and error messages
- **Tested**: Extensive test coverage with testthat

## Why col2hex2col?

- **No tidyverse dependency**: Unlike some alternatives, this package uses only base R and grDevices
- **Optimized performance**: Efficient algorithms for fast conversion
- **CRAN-ready**: Follows all CRAN policies and best practices
- **Well-documented**: Complete function documentation and examples

## Comparison with alternatives

The original implementation used tidyverse functions (tibble, pivot_longer, pivot_wider, pmap_chr), which added unnecessary dependencies. **col2hex2col** achieves the same functionality using only base R, making it:

- Lighter (fewer dependencies)
- Faster (optimized base R functions)
- More maintainable (simpler code)

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## License

MIT © Antti Rask
