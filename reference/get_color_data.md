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
#> [1] 32491     5

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
#>                       name     hex    lab_l      lab_a       lab_b
#> 18847        mountain haze #6C6E7E 46.77205  2.7544761  -9.0851710
#> 18895             moussaka #6D2A13 26.60659 28.4318941  29.0706789
#> 26803             snowbank #E8E9E9 92.27247 -0.3276542  -0.1136430
#> 25102       samovar silver #B8BEBE 76.51803 -2.0688197  -0.7204286
#> 28867              tarsier #825E61 43.67579 15.1653023   4.0932861
#> 2986  bloodthirsty vampire #9B0503 32.00202 54.5542983  44.6157270
#> 1842        bales of brown #CF994B 66.94463 12.1018690  47.9548849
#> 25718         self powered #8C7591 52.22250 14.2645424 -11.8382688
#> 3371        blue wing teal #2E4556 28.13737 -3.7256212 -12.9321952
#> 29925          tulip white #F1E5D1 91.38968  0.8005547  11.2141099
```
