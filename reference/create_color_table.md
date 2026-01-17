# Create Color Swatch Table

Creates a visual table displaying color names, hex codes, and color
swatches. Requires the `gt` package to be installed.

## Usage

``` r
create_color_table(df)
```

## Arguments

- df:

  A data frame with at minimum a column named `hex` containing
  hexadecimal color codes. Optionally can include a `name` column for
  color names. If `name` is not present, only hex codes and swatches
  will be displayed.

## Value

A `gt` table object displaying the colors with visual swatches. The
table will have columns for color names (if provided), hex codes, and a
color swatch column where each cell is filled with the corresponding
color.

## Details

This function creates an enhanced table using the `gt` package. The
table includes:

- Color names (if the `name` column exists in the input)

- Hexadecimal color codes

- Visual color swatches (cells filled with the actual colors)

The `gt` package must be installed to use this function. If it's not
installed, the function will provide instructions on how to install it.

You can pass the output of
[`get_color_data`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
directly to this function, or create a custom data frame with your own
color selection.

## See also

[`get_color_data`](https://anttirask.github.io/col2hex2col/reference/get_color_data.md)
for obtaining the complete color database,
[`color_to_hex`](https://anttirask.github.io/col2hex2col/reference/color_to_hex.md)
for converting color names to hex codes

## Examples

``` r
# Create a table with a few colors
colors_df <- data.frame(
  name = c("red", "blue", "forestgreen"),
  hex = c("#FF0000", "#0000FF", "#228B22")
)

# Only run if gt is available
if (requireNamespace("gt", quietly = TRUE)) {
  create_color_table(colors_df)

  # Use with get_color_data() - show first 10 colors
  all_colors <- get_color_data()
  create_color_table(head(all_colors, 10))

  # Create a table with only specific colors
  blue_colors <- all_colors[grepl("blue", all_colors$name), ]
  create_color_table(head(blue_colors, 20))

  # Minimal example with just hex codes
  hex_only <- data.frame(hex = c("#FF0000", "#00FF00", "#0000FF"))
  create_color_table(hex_only)
}


  

Hex Code
```

Swatch

\#FF0000

\#00FF00

\#0000FF
