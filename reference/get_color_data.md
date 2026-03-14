# Get Color Database

Returns the complete color database as a data frame containing all
32,000+ color names and their corresponding hexadecimal codes.

## Usage

``` r
get_color_data()
```

## Value

A data frame with the following columns:

- name:

  Character vector of color names (lowercase)

- hex:

  Character vector of hexadecimal color codes (uppercase, format:
  \#RRGGBB)

- lab_l, lab_a, lab_b:

  (Optional) LAB color space coordinates, added when the `farver`
  package is available

The data frame contains over 32,000 rows representing all available
colors, including both R's 657 built-in colors and the extended
color-names database.

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
#>                          name     hex    lab_l     lab_a     lab_b
#> 1                     100 mph #C93F38 47.31632 54.067012  35.32651
#> 2          18th century green #A59344 61.03262 -3.367873  43.49787
#> 3              1975 earth red #7B463B 35.80671 21.453625  16.44115
#> 4          1989 miami hotline #DD3366 50.33896 66.911465  12.43714
#> 5 20000 leagues under the sea #191970 15.85760 31.715801 -49.57238
#> 6           21st century blue #7FB9DD 72.51353 -9.503429 -23.94186

# See dimensions
dim(colors_df)
#> [1] 32498     5

# Find all colors containing "blue"
blue_colors <- colors_df[grepl("blue", colors_df$name), ]
head(blue_colors)
#>                       name     hex     lab_l      lab_a      lab_b
#> 6        21st century blue #7FB9DD 72.513535 -9.5034285 -23.941860
#> 16           99 years blue #000099 16.984608 54.0842393 -73.660652
#> 30             a-list blue #A9BFC5 75.901293 -6.2249830  -5.547463
#> 70 abyssal anchorfish blue #1B2632 14.676396 -0.9371172  -9.359426
#> 71            abyssal blue #00035B  7.408709 35.2808794 -49.730755
#> 80           academic blue #2C3E56 25.720365  0.2542979 -16.667031

# Get a random sample of colors
set.seed(123)
sample_colors <- colors_df[sample(nrow(colors_df), 10), ]
sample_colors
#>                   name     hex    lab_l     lab_a      lab_b
#> 18847     mountain fog #F4DBC7 88.93261  5.496830  12.981662
#> 18895    mouse catcher #9E928F 61.49035  3.900251   3.191081
#> 26803 snow white blush #F8AFA9 78.16035 25.912121  13.784678
#> 25102            samba #AA262B 38.03819 52.655923  30.789569
#> 28867  tarnished brass #7F6C24 46.13054 -1.040181  41.341231
#> 2986       bloody mary #BA0105 38.68238 63.133555  51.082415
#> 1842        bali batik #6F5937 39.24273  4.198661  23.018862
#> 25718   sekichiku pink #E5ABBE 75.76382 24.063856  -1.354879
#> 3371       blue yonder #5A77A8 49.72978  3.172326 -29.439636
#> 29925   tuileries tint #B89CBC 67.72385 16.091490 -12.653178
```
