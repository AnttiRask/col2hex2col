# Get Color Database

Returns the complete color database as a data frame containing all
32,000+ color names and their corresponding hexadecimal codes.

## Usage

``` r
get_color_data()
```

## Value

A data frame with two columns:

- name:

  Character vector of color names (lowercase)

- hex:

  Character vector of hexadecimal color codes (uppercase, format:
  \#RRGGBB)

The data frame contains 32,462 rows representing all available colors,
including both R's 657 built-in colors and the extended color-names
database.

## Details

The returned data frame is sorted alphabetically by color name. Each
color name maps to exactly one hex code, though multiple color names may
share the same hex code.

This function is useful for:

- Exploring available color names

- Creating custom color palettes

- Searching for colors by name pattern

- Analyzing color distributions

- Building color visualization tools

## See also

[`color_to_hex`](https://anttirask.github.io/col2hex2col/reference/color_to_hex.md)
for converting specific color names to hex codes,
[`hex_to_color`](https://anttirask.github.io/col2hex2col/reference/hex_to_color.md)
for the reverse conversion,
[`create_color_table`](https://anttirask.github.io/col2hex2col/reference/create_color_table.md)
for creating visual color tables

## Examples

``` r
# Get the complete color database
colors_df <- get_color_data()
head(colors_df)
#>                            name     hex
#> 658                     100 mph #C93F38
#> 659          18th century green #A59344
#> 660              1975 earth red #7B463B
#> 661          1989 miami hotline #DD3366
#> 662 20000 leagues under the sea #191970
#> 663           21st century blue #7FB9DD

# See dimensions
dim(colors_df)
#> [1] 32462     2

# Find all colors containing "blue"
blue_colors <- colors_df[grepl("blue", colors_df$name), ]
head(blue_colors)
#>                        name     hex
#> 663       21st century blue #7FB9DD
#> 673           99 years blue #000099
#> 687             a-list blue #A9BFC5
#> 728 abyssal anchorfish blue #1B2632
#> 729            abyssal blue #00035B
#> 738           academic blue #2C3E56

# Get a random sample of colors
set.seed(123)
sample_colors <- colors_df[sample(nrow(colors_df), 10), ]
sample_colors
#>                    name     hex
#> 19035    mountain olive #908456
#> 19083         mr. krabs #D04127
#> 26864     snug as a bug #BEA998
#> 25198         sand dune #E3D2C0
#> 28911       taupe brown #483C30
#> 3626  bloody periphylla #AA1144
#> 2489          bali deep #8A8E93
#> 25805    sensual climax #DA3287
#> 4010        blue zephyr #5B6676
#> 29966       turkish sea #194F90
```
