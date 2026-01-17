# Convert Hex Codes to Color Names

Converts hexadecimal color codes to their corresponding color names.
This function searches through an extensive database of over 32,000
color names, prioritizing R's built-in color names when available.

## Usage

``` r
hex_to_color(hex)
```

## Arguments

- hex:

  A character vector of hexadecimal color codes in the format "#RRGGBB"
  or "#RRGGBBAA" (e.g., "#FF0000", "#0000FF", "#FF0000FF"). The hash
  symbol (#) is required, and the hex code is case-insensitive. Each
  component (RR, GG, BB) must be a two-digit hexadecimal value (00-FF).
  If an 8-digit code with alpha channel (AA) is provided, the alpha
  channel is ignored.

## Value

A character vector of color names (in lowercase). If a hex code does not
have a corresponding named color in the database, `NA` is returned for
that element. The returned vector has the same length as the input.

## Details

The function performs input validation and will raise an error if:

- The input is not a character vector

- Any NA values are present

- Any hex codes are not in the correct "#RRGGBB" or "#RRGGBBAA" format

This function is case-insensitive for the hex values (e.g., "#FF0000"
and "#ff0000" are treated identically). When 8-digit hex codes with
alpha channel are provided (e.g., "#FF0000FF"), the alpha channel is
automatically stripped and only the RGB portion is used for color name
lookup.

**Name Selection Strategy**: When multiple color names map to the same
hex code:

1.  R's built-in color names are prioritized (from
    [`colors`](https://rdrr.io/r/grDevices/colors.html))

2.  If no R color exists, the shortest name from the extended database
    is returned

This ensures backward compatibility with R's color system while
providing coverage for the 32,161 unique hex codes in the extended
database.

The extended database includes colors from
<https://github.com/meodai/color-names>, significantly increasing the
likelihood of finding a named match for any given hex code.

## See also

[`color_to_hex`](https://anttirask.github.io/col2hex2col/reference/color_to_hex.md)
for the reverse conversion,
[`colors`](https://rdrr.io/r/grDevices/colors.html) for R's built-in
color names

## Examples

``` r
# Convert a single hex code
hex_to_color("#FF0000")
#> [1] "red"

# Convert multiple hex codes
hex_to_color(c("#FF0000", "#0000FF", "#00FF00"))
#> [1] "red"   "blue"  "green"

# Works with 8-digit hex codes (alpha channel ignored)
hex_to_color(c("#FF0000FF", "#0000FFFF"))
#> [1] "red"  "blue"

# Case insensitive
hex_to_color("#ff0000")  # Same as "#FF0000"
#> [1] "red"

# Works with extended color database
hex_to_color("#FF6347")  # Returns a descriptive color name
#> [1] "tomato"

# Returns NA for colors without named equivalents (rare)
hex_to_color("#ABCDEF")
#> [1] "alphabet blue"

# Round-trip conversion
original <- c("red", "blue", "green")
hex_codes <- color_to_hex(original)
hex_to_color(hex_codes)  # Returns original color names
#> [1] "red"   "blue"  "green"
```
