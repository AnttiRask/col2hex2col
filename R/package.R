#' @details
#' The col2hex2col package provides two main functions for bidirectional conversion
#' between R color names and hexadecimal color codes:
#'
#' \itemize{
#'   \item \code{\link{color_to_hex}}: Converts R color names to hex codes
#'   \item \code{\link{hex_to_color}}: Converts hex codes to R color names
#' }
#'
#' Both functions are fully vectorized, include comprehensive input validation,
#' and work with R's 657 built-in color names from \code{\link[grDevices]{colors}}.
#'
#' The package uses only base R and the grDevices package, ensuring minimal
#' dependencies and fast performance.
#'
#' @section Author:
#' Antti Rask
#'
#' @section See Also:
#' Useful links:
#' \itemize{
#'   \item \url{https://github.com/AnttiRask/col2hex2col}
#'   \item Report bugs at \url{https://github.com/AnttiRask/col2hex2col/issues}
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom grDevices col2rgb
#' @importFrom grDevices colors
#' @importFrom grDevices rgb
## usethis namespace: end
NULL
