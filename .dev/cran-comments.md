## R CMD check results

0 errors | 0 warnings | 0 notes

## Update from 0.3.1 to 0.5.1

This is an update to an existing CRAN package. Changes since the last CRAN release (0.3.1):

### Version 0.4.0
* Added nearest color fallback functionality to `hex_to_color()` - when no exact match exists, the function now returns the closest named color using LAB color distance (requires optional `farver` package)
* Added `fallback_nearest_color` and `fallback_distance` parameters to `hex_to_color()`
* Added Yann Cohen as contributor for the fallback functionality

### Version 0.5.0
* Enhanced `create_color_table()` to display LAB columns with cleaner labels (Lab L, Lab a, Lab b)
* Enhanced `create_color_table()` to automatically label the first column as "Color Name"
* Fixed `hex_to_color()` examples to use hex codes without exact matches
* Fixed `get_color_data()` row numbering after alphabetical sorting
* Updated documentation examples

### Version 0.5.1
* Updated README examples to show LAB columns in `get_color_data()` output
* Added documentation note about LAB columns requiring the `farver` package
* Updated contributor information in pkgdown configuration

## Test environments

* local Linux Mint 22.2, R 4.5.2
* GitHub Actions (ubuntu-latest): devel, release, oldrel-1
* GitHub Actions (windows-latest): release
* GitHub Actions (macos-latest): release

All tests pass on all platforms.

## Reverse dependencies

There are currently no reverse dependencies for this package.
