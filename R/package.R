#' @details
#' The col2hex2col package provides functions for working with color names and
#' hexadecimal color codes:
#'
#' **Core Conversion Functions:**
#' \itemize{
#'   \item \code{\link{color_to_hex}}: Converts color names to hex codes
#'   \item \code{\link{hex_to_color}}: Converts hex codes to color names
#' }
#'
#' **Data and Visualization Functions:**
#' \itemize{
#'   \item \code{\link{get_color_data}}: Export the complete color database as a data frame
#'   \item \code{\link{create_color_table}}: Create visual color swatch tables (requires gt package)
#' }
#'
#' Both functions are fully vectorized and include comprehensive input validation.
#' The package now supports an extensive database of over 32,000 color names:
#'
#' \itemize{
#'   \item 657 R built-in colors from \code{\link[grDevices]{colors}}
#'   \item 31,852+ colors from the color-names database (\url{https://github.com/meodai/color-names})
#' }
#'
#' **Key Features:**
#' \itemize{
#'   \item Case-insensitive color name matching
#'   \item Backward compatible with R's color system (R colors prioritized)
#'   \item Fast lookup using pre-built internal databases
#'   \item Minimal dependencies (only grDevices)
#'   \item Comprehensive test coverage
#' }
#'
#' The extended database is stored internally as \code{R/sysdata.rda} and is
#' automatically loaded when the package is attached. Users can seamlessly work
#' with both R colors and the extended color palette.
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
