# col2hex2col 0.2.0

## Major Features

* **Extended Color Database**: Package now supports over 32,000 color names!
  - 657 R built-in colors (backward compatible)
  - 31,852 colors from the [color-names database](https://github.com/meodai/color-names) (MIT license)
  - Total: 32,462 unique color names, 32,161 unique hex codes

* **Enhanced color_to_hex()**: Now accepts color names from the extended database
  - Case-insensitive matching ("red", "Red", "RED" all work)
  - Whitespace trimming
  - Examples: "sunset orange", "arctic ocean", "forest green"

* **Enhanced hex_to_color()**: Intelligently selects color names with prioritization
  - R colors are always prioritized when available
  - For non-R colors, returns the shortest available name
  - Significantly increased hex code coverage (from ~650 to 32,161)

## Breaking Changes

* None - fully backward compatible with v0.1.x
* All existing code using R colors will work unchanged
* R colors are prioritized in all lookups

## Performance Improvements

* Replaced dynamic color lookup with pre-built internal databases
* Removed dependency on `grDevices` functions for lookups
* Fast constant-time lookup using named vectors stored in `R/sysdata.rda`

## Documentation

* Updated all function documentation to reflect extended database
* Added examples using extended color names
* Updated package description and README
* Enhanced package-level documentation with key features

## Testing

* Added 22 new tests for extended color functionality
* All 67 tests passing
* Tests cover backward compatibility, case insensitivity, and extended colors

## Internal Changes

* Added `data-raw/prepare_colornames.R` script for data preparation
* Internal data stored in `R/sysdata.rda` (~650KB)
* Removed `grDevices` from Imports (no longer needed)

# col2hex2col 0.1.2

## Bug Fixes

* Fixed duplicate "Author" and "See Also" sections in package documentation

# col2hex2col 0.1.1

## Documentation Improvements

* Enhanced function documentation with comprehensive details
* Added `@details` sections explaining input validation
* Expanded examples with real-world use cases
* Added cross-references with `@seealso` sections
* Improved package-level documentation
* All examples verified to run correctly

# col2hex2col 0.1.0

## Initial Release

* Added `color_to_hex()` function to convert R color names to hexadecimal codes
* Added `hex_to_color()` function to convert hexadecimal codes to R color names
* Comprehensive input validation for both functions
* Full test coverage with testthat
* Optimized performance using base R instead of tidyverse
* CRAN-ready package structure
