# col2hex2col: Convert Between Color Names and Hex Codes

Provides simple functions to convert between color names and hexadecimal
color codes using an extensive database of over 32,000 colors. Includes
all 657 R built-in colors plus the comprehensive color-names database.
The package supports bidirectional conversion with backward
compatibility, prioritizing R colors when available.

## Details

The col2hex2col package provides functions for working with color names
and hexadecimal color codes:

**Core Conversion Functions:**

- [`color_to_hex`](https://anttirask.github.io/col2hex2col/reference/color_to_hex.md):
  Converts color names to hex codes

- [`hex_to_color`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md):
  Converts hex codes to color names

**Data and Visualization Functions:**

- [`get_color_data`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md):
  Export the complete color database as a data frame

- [`create_color_table`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md):
  Create visual color swatch tables (requires gt package)

Both functions are fully vectorized and include comprehensive input
validation. The package now supports an extensive database of over
32,000 color names:

- 657 R built-in colors from
  [`colors`](https://rdrr.io/r/grDevices/colors.html)

- 31,852+ colors from the color-names database
  (<https://github.com/meodai/color-names>)

**Key Features:**

- Case-insensitive color name matching

- Backward compatible with R's color system (R colors prioritized)

- Fast lookup using pre-built internal databases

- Minimal dependencies (only grDevices)

- Comprehensive test coverage

The extended database is stored internally as `R/sysdata.rda` and is
automatically loaded when the package is attached. Users can seamlessly
work with both R colors and the extended color palette.

## See also

Useful links:

- <https://github.com/AnttiRask/col2hex2col>

- Report bugs at <https://github.com/AnttiRask/col2hex2col/issues>

## Author

**Maintainer**: Antti Rask <anttilennartrask@gmail.com>
