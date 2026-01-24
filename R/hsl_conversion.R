#' Convert Hex Codes to HSL
#'
#' Converts hexadecimal color codes to HSL (Hue, Saturation, Lightness) values.
#' The output includes an alpha column derived from 8-digit hex codes when present.
#'
#' @param hex A character vector of hexadecimal color codes in the format "#RRGGBB"
#'   or "#RRGGBBAA" (e.g., "#FF0000", "#0000FF", "#FF0000CC"). The hash symbol (#)
#'   is required, and the hex code is case-insensitive. If an 8-digit code is provided,
#'   the alpha channel is parsed into the returned result.
#'
#' @return If a single value is supplied, a named numeric vector with elements
#'   \code{c(h, s, l, alpha)}. For multiple values, a data frame with columns
#'   \code{h}, \code{s}, \code{l}, and \code{alpha}.
#'
#' @details
#' The function performs input validation and will raise an error if:
#' \itemize{
#'   \item The input is not a character vector
#'   \item Any NA values are present
#'   \item Any hex codes are not in the correct "#RRGGBB" or "#RRGGBBAA" format
#' }
#'
#' Hue is set to 0 for achromatic colors (where saturation is 0). This function is
#' vectorized and returns either a named numeric vector (single input) or a data
#' frame (multiple inputs) with matching length. Output values are rounded to 4
#' decimal places; when saturation rounds to 0, hue is set to 0.
#'
#' @references
#' \url{https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/hsl}
#'
#' @seealso
#' \code{\link{color_to_hsl}} for converting color names,
#' \code{\link{hsl_to_hex}} for the reverse conversion,
#' \code{\link{color_to_hex}} for color name lookup
#'
#' @export
#' @examples
#' # Convert a single hex code
#' hex_to_hsl("#FF0000")
#'
#' # Convert multiple hex codes
#' hex_to_hsl(c("#FF0000", "#00FF00", "#0000FF"))
#'
#' # Works with 8-digit hex codes (alpha channel parsed)
#' hex_to_hsl("#FF000080")
hex_to_hsl <- function(hex) {
  if (!is.character(hex)) {
    stop("Input must be a character vector of hex codes")
  }

  if (any(is.na(hex))) {
    stop("NA values are not allowed in hex codes")
  }

  hex_pattern <- "^#[0-9A-Fa-f]{6}([0-9A-Fa-f]{2})?$"
  if (!all(grepl(hex_pattern, hex))) {
    invalid <- hex[!grepl(hex_pattern, hex)]
    stop(
      "Invalid hex code format. Expected format: #RRGGBB or #RRGGBBAA. Invalid values: ",
      paste(invalid, collapse = ", ")
    )
  }

  hex_std <- toupper(hex)
  alpha <- rep(1, length(hex_std))

  is8 <- nchar(hex_std) == 9
  if (any(is8)) {
    alpha[is8] <- strtoi(substr(hex_std[is8], 8, 9), 16L) / 255
    hex_std[is8] <- substr(hex_std[is8], 1, 7)
  }

  r <- strtoi(substr(hex_std, 2, 3), 16L) / 255
  g <- strtoi(substr(hex_std, 4, 5), 16L) / 255
  b <- strtoi(substr(hex_std, 6, 7), 16L) / 255

  maxc <- pmax(r, g, b)
  minc <- pmin(r, g, b)
  delta <- maxc - minc

  l <- (maxc + minc) / 2

  s <- ifelse(delta == 0, 0, delta / (1 - abs(2 * l - 1)))

  hue_base <- numeric(length(hex_std))
  chromatic <- delta != 0
  red_is_max <- (maxc == r) & chromatic
  green_is_max <- (maxc == g) & chromatic
  blue_is_max <- (maxc == b) & chromatic

  hue_base[red_is_max] <- ((g[red_is_max] - b[red_is_max]) / delta[red_is_max]) %% 6
  hue_base[green_is_max] <- ((b[green_is_max] - r[green_is_max]) / delta[green_is_max]) + 2
  hue_base[blue_is_max] <- ((r[blue_is_max] - g[blue_is_max]) / delta[blue_is_max]) + 4

  h <- (hue_base * 60) %% 360
  h[!chromatic] <- 0

  h_out <- round(h, 4)
  s_out <- round(s, 4)
  l_out <- round(l, 4)
  alpha_out <- round(alpha, 4)
  h_out[s_out == 0] <- 0

  if (length(hex_std) == 1) {
    c(h = h_out, s = s_out, l = l_out, alpha = alpha_out)
  } else {
    data.frame(
      h = h_out,
      s = s_out,
      l = l_out,
      alpha = alpha_out,
      stringsAsFactors = FALSE,
      row.names = NULL
    )
  }
}

#' Convert Color Names to HSL
#'
#' Converts color names to HSL (Hue, Saturation, Lightness) values using the
#' internal color database of base R and extended color names.
#'
#' @param color A character vector of color names (e.g., "red", "sky blue", "forest green").
#'   Color names are case-insensitive and whitespace is trimmed.
#'
#' @return If a single value is supplied, a named numeric vector with elements
#'   \code{c(h, s, l, alpha)}. For multiple values, a data frame with columns
#'   \code{h}, \code{s}, \code{l}, and \code{alpha}.
#'
#' @details
#' The function performs input validation and will raise an error if:
#' \itemize{
#'   \item The input is not a character vector
#'   \item Any NA values are present
#'   \item Any invalid color names are provided
#' }
#'
#' This function is vectorized and uses \code{\link{color_to_hex}} followed by
#' \code{\link{hex_to_hsl}} for conversion.
#'
#' @seealso
#' \code{\link{hex_to_hsl}} for converting hex codes,
#' \code{\link{hsl_to_color}} for the reverse conversion,
#' \code{\link{color_to_hex}} for color name lookup
#'
#' @export
#' @examples
#' # Convert a single color name
#' color_to_hsl("red")
#'
#' # Convert multiple color names
#' color_to_hsl(c("red", "blue", "green"))
#'
#' # Works with extended color names
#' color_to_hsl(c("sunset orange", "arctic ocean"))
color_to_hsl <- function(color) {
  if (!is.character(color)) {
    stop("Input must be a character vector of color names")
  }

  hex_codes <- color_to_hex(color)
  hex_to_hsl(hex_codes)
}
