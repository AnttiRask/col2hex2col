# Changelog

## col2hex2col 0.5.2

### Bug Fixes

- Fixed color count test to use `>=` threshold instead of exact count,
  preventing test failures when the color database is updated
- Fixed test warning for 8-digit hex codes triggering fallback

### Data

- Updated color database with 29 new colors from the color-names
  repository

### Documentation

- Replaced hardcoded “32,462” color count with “32,000+” throughout docs
  and README
- Fixed update-colors GitHub Actions workflow (dependency installation,
  caching, permissions)

## col2hex2col 0.5.1

### Documentation

- Updated README examples to show LAB columns in
  [`get_color_data()`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
  output
- Added note about LAB columns requiring the `farver` package
- Updated contributor information in pkgdown configuration
- Cleaned up repository structure (moved dev files to `.dev/` folder)

## col2hex2col 0.5.0

### Enhancements

- **[`create_color_table()`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md)**:
  Enhanced column labeling
  - LAB columns now display as “Lab L”, “Lab a”, “Lab b” instead of raw
    column names
  - First column is automatically labeled “Color Name” regardless of
    input column name

### Bug Fixes

- Fixed
  [`hex_to_color()`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)
  examples to use hex codes without exact matches
- Fixed
  [`get_color_data()`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
  row numbering after alphabetical sorting

### Documentation

- Updated documentation examples with correct output

## col2hex2col 0.4.0

### New Features

- **[`hex_to_color()`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)**:
  Added nearest color fallback functionality
  - When no exact match exists, returns the closest named color using
    LAB color distance
  - Requires optional `farver` package for color distance calculations
  - New `fallback_nearest_color` parameter (default: `TRUE`) to
    enable/disable fallback
  - New `fallback_distance` parameter to get the LAB distance to the
    matched color

### Contributors

- Added Yann Cohen ([@iamYannC](https://github.com/iamYannC)) as
  contributor for the fallback functionality

## col2hex2col 0.3.1

CRAN release: 2026-01-21

### Enhancements

- **[`hex_to_color()`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)**:
  Now accepts 8-digit hex codes with alpha channel
  - Automatically strips alpha channel from \#RRGGBBAA format codes
  - Maintains backward compatibility with 6-digit \#RRGGBB format
  - Works seamlessly with paletteer and other packages that output
    colors with transparency

### Testing

- Added 7 new tests for 8-digit hex code support in
  [`hex_to_color()`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)
- All 111 tests passing

## col2hex2col 0.3.0

### New Features

- **[`get_color_data()`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)**:
  New function to export the complete color database as a data frame
  - Returns all 32,462 color names with their hex codes
  - Data frame format makes it easy to explore, filter, and analyze
    colors
  - Sorted alphabetically by color name
  - Perfect for creating custom color palettes or searching for specific
    colors
- **[`create_color_table()`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md)**:
  New function to create visual color swatch tables
  - Displays colors with names, hex codes, and visual color swatches
  - Uses the gt package for beautiful formatted tables
  - Works seamlessly with
    [`get_color_data()`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
    output
  - Optional dependency - only requires gt if you want to use this
    feature

### Dependencies

- Added `gt` to Suggests (optional dependency for
  [`create_color_table()`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md))
- Package maintains zero hard dependencies - pure base R for core
  functions

### Testing

- Added 18 new tests for
  [`get_color_data()`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
- Added 8 new tests for
  [`create_color_table()`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md)
  (with proper handling of optional gt dependency)
- All 104 tests passing

## col2hex2col 0.2.0

### Major Features

- **Extended Color Database**: Package now supports over 32,000 color
  names!
  - 657 R built-in colors (backward compatible)
  - 31,852 colors from the [color-names
    database](https://github.com/meodai/color-names) (MIT license)
  - Total: 32,462 unique color names, 32,161 unique hex codes
- **Enhanced color_to_hex()**: Now accepts color names from the extended
  database
  - Case-insensitive matching (“red”, “Red”, “RED” all work)
  - Whitespace trimming
  - Examples: “sunset orange”, “arctic ocean”, “forest green”
- **Enhanced hex_to_color()**: Intelligently selects color names with
  prioritization
  - R colors are always prioritized when available
  - For non-R colors, returns the shortest available name
  - Significantly increased hex code coverage (from ~650 to 32,161)

### Breaking Changes

- None - fully backward compatible with v0.1.x
- All existing code using R colors will work unchanged
- R colors are prioritized in all lookups

### Performance Improvements

- Replaced dynamic color lookup with pre-built internal databases
- Removed dependency on `grDevices` functions for lookups
- Fast constant-time lookup using named vectors stored in
  `R/sysdata.rda`

### Documentation

- Updated all function documentation to reflect extended database
- Added examples using extended color names
- Updated package description and README
- Enhanced package-level documentation with key features

### Testing

- Added 22 new tests for extended color functionality
- All 67 tests passing
- Tests cover backward compatibility, case insensitivity, and extended
  colors

### Internal Changes

- Added `data-raw/prepare_colornames.R` script for data preparation
- Internal data stored in `R/sysdata.rda` (~650KB)
- Removed `grDevices` from Imports (no longer needed)

## col2hex2col 0.1.2

### Bug Fixes

- Fixed duplicate “Author” and “See Also” sections in package
  documentation

## col2hex2col 0.1.1

### Documentation Improvements

- Enhanced function documentation with comprehensive details
- Added `@details` sections explaining input validation
- Expanded examples with real-world use cases
- Added cross-references with `@seealso` sections
- Improved package-level documentation
- All examples verified to run correctly

## col2hex2col 0.1.0

### Initial Release

- Added
  [`color_to_hex()`](https://anttirask.github.io/col2hex2col/reference/color_to_hex.md)
  function to convert R color names to hexadecimal codes
- Added
  [`hex_to_color()`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)
  function to convert hexadecimal codes to R color names
- Comprehensive input validation for both functions
- Full test coverage with testthat
- Optimized performance using base R instead of tidyverse
- CRAN-ready package structure
