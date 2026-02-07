# Convert Color Names to Hex Codes

Converts color names to their hexadecimal color code representations.
This function accepts color names from an extensive database of over
32,000 color names, including all 657 built-in R colors from
[`colors`](https://rdrr.io/r/grDevices/colors.html) plus the
comprehensive color-names database from
<https://github.com/meodai/color-names>.

## Usage

``` r
color_to_hex(color)
```

## Arguments

- color:

  A character vector of color names (e.g., "red", "blue", "sunset
  orange"). Color names are case-insensitive and whitespace is trimmed.
  Spaces within color names are preserved (e.g., "sky blue" is different
  from "skyblue").

## Value

A character vector of hexadecimal color codes in the format "#RRGGBB",
where each pair of characters represents the red, green, and blue
components in hexadecimal notation (00-FF). The returned vector has the
same length as the input.

## Details

The function performs input validation and will raise an error if:

- The input is not a character vector

- Any NA values are present

- Any invalid color names are provided

This function is vectorized and efficiently handles both single colors
and vectors of multiple colors. The extended database includes over
32,000 unique color names from various sources, making it suitable for a
wide range of color specification needs.

Color name matching is case-insensitive: "Red", "red", and "RED" all
match the same color.

## See also

[`hex_to_color`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)
for the reverse conversion,
[`colors`](https://rdrr.io/r/grDevices/colors.html) for R's built-in
color names

## Examples

``` r
# Convert a single color
color_to_hex("red")
#> [1] "#FF0000"

# Convert multiple colors
color_to_hex(c("red", "blue", "green"))
#> [1] "#FF0000" "#0000FF" "#00FF00"

# Works with all R color names
color_to_hex(c("skyblue", "coral", "chartreuse"))
#> [1] "#87CEEB" "#FF7F50" "#7FFF00"

# Also works with extended color names
color_to_hex(c("sunset orange", "arctic ocean", "forest green"))
#> [1] "#FD5E53" "#66C3D0" "#154406"

# Case insensitive
color_to_hex(c("Red", "BLUE", "Green"))
#> [1] "#FF0000" "#0000FF" "#00FF00"

# Use in a data visualization context
colors <- c("steelblue", "firebrick", "forestgreen")
hex_codes <- color_to_hex(colors)
# hex_codes can now be used with plotting functions
```
