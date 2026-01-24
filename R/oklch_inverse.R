#' Convert OKLCH to Hex Codes
#'
#' Converts OKLCH values (l, c, h) to hexadecimal color codes. An optional alpha
#' channel can be supplied to generate 8-digit hex codes.
#'
#' @param l A numeric vector of OKLCH lightness values.
#' @param c A numeric vector of OKLCH chroma values.
#' @param h A numeric vector of hue values in degrees. Values are normalized to
#'   the range 0-360.
#' @param alpha A numeric vector of alpha values in the range 0-1. If provided and
#'   not equal to 1, the alpha channel is appended to the hex output as "#RRGGBBAA".
#'
#' @return A character vector of hexadecimal color codes in the format "#RRGGBB"
#'   or "#RRGGBBAA" when alpha is not 1. The returned vector has the same length
#'   as the input.
#'
#' @details
#' The function performs input validation and will raise an error if:
#' \itemize{
#'   \item Any input is not numeric
#'   \item Any NA values are present
#'   \item Input lengths are incompatible
#' }
#'
#' Inputs are recycled following base R rules (length-1 values are expanded and
#' shorter vectors are recycled); a warning is issued when lengths are not
#' multiples of each other. Computed RGB values are clipped to the 0-1 range
#' before converting to hex, which maps out-of-gamut values to the nearest sRGB
#' boundary.
#'
#' @references
#' \url{https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/oklch}
#'
#' @seealso
#' \code{\link{oklch_to_color}} for converting to color names,
#' \code{\link{hex_to_oklch}} for the reverse conversion
#'
#' @export
#' @examples
#' # Convert OKLCH values for red
#' oklch_to_hex(0.6279554, 0.2576833, 29.2338812)
#'
#' # Convert multiple OKLCH values
#' oklch_to_hex(c(0.62, 0.5), c(0.2, 0.1), c(30, 120))
oklch_to_hex <- function(l, c = NULL, h = NULL, alpha = 1) {
  # Allow passing a data frame, matrix, list, or named vector from hex_to_oklch/color_to_oklch
  if (is.null(c) && is.null(h)) {
    if (is.data.frame(l) || is.matrix(l)) {
      alpha <- if ("alpha" %in% colnames(l)) l[, "alpha"] else alpha
      h <- l[, "h"]
      c <- l[, "c"]
      l <- l[, "l"]
    } else if (is.list(l) && !is.null(l$l) && !is.null(l$c) && !is.null(l$h)) {
      alpha <- if (!is.null(l$alpha)) l$alpha else alpha
      h <- l$h
      c <- l$c
      l <- l$l
    } else if (is.numeric(l) && !is.null(names(l)) &&
               all(c("l", "c", "h") %in% names(l))) {
      alpha <- if ("alpha" %in% names(l)) l[["alpha"]] else alpha
      h <- l[["h"]]
      c <- l[["c"]]
      l <- l[["l"]]
    }
  }

  if (!is.numeric(l) || !is.numeric(c) || !is.numeric(h)) {
    stop("Inputs l, c, and h must be numeric")
  }
  if (!is.numeric(alpha)) {
    stop("Alpha must be numeric")
  }

  lengths <- c(length(l), length(c), length(h), length(alpha))
  if (any(lengths == 0)) {
    return(character(0))
  }

  n <- max(lengths)
  if (any(lengths > 0 & (n %% lengths) != 0)) {
    warning("Input lengths are not multiples of each other and will be recycled.", call. = FALSE)
  }

  l_vals <- rep_len(as.numeric(l), n)
  c_vals <- rep_len(as.numeric(c), n)
  h_vals <- rep_len(as.numeric(h), n)
  alpha_vals <- rep_len(as.numeric(alpha), n)

  if (any(is.na(l_vals) | is.na(c_vals) | is.na(h_vals) | is.na(alpha_vals))) {
    stop("Inputs cannot contain NA")
  }

  h_rad <- (h_vals %% 360) * pi / 180
  a_vals <- c_vals * cos(h_rad)
  b_vals <- c_vals * sin(h_rad)

  l_ <- (l_vals + 0.3963377774 * a_vals + 0.2158037573 * b_vals) ^ 3
  m_ <- (l_vals - 0.1055613458 * a_vals - 0.0638541728 * b_vals) ^ 3
  s_ <- (l_vals - 0.0894841775 * a_vals - 1.2914855480 * b_vals) ^ 3

  r_lin <- 4.0767416621 * l_ - 3.3077115913 * m_ + 0.2309699292 * s_
  g_lin <- -1.2684380046 * l_ + 2.6097574011 * m_ - 0.3413193965 * s_
  b_lin <- -0.0041960863 * l_ - 0.7034186147 * m_ + 1.7076147010 * s_

  clamp01 <- function(x) pmin(pmax(x, 0), 1)
  r_lin <- clamp01(r_lin)
  g_lin <- clamp01(g_lin)
  b_lin <- clamp01(b_lin)

  to_srgb <- function(x) ifelse(x <= 0.0031308, 12.92 * x, 1.055 * (x ^ (1 / 2.4)) - 0.055)
  r <- to_srgb(r_lin)
  g <- to_srgb(g_lin)
  b <- to_srgb(b_lin)

  channel_hex <- function(x) sprintf("%02X", round(clamp01(x) * 255))
  rgb_hex <- paste0("#", channel_hex(r), channel_hex(g), channel_hex(b))

  alpha_hex <- channel_hex(clamp01(alpha_vals))
  use_alpha <- alpha_vals != 1
  rgb_hex[use_alpha] <- paste0(rgb_hex[use_alpha], alpha_hex[use_alpha])

  rgb_hex
}

#' Convert OKLCH to Color Names
#'
#' Converts OKLCH values to color names using the internal color database. The
#' conversion first maps OKLCH to hex codes and then uses \code{\link{hex_to_color}}
#' for name lookup.
#'
#' @param l A numeric vector of OKLCH lightness values.
#' @param c A numeric vector of OKLCH chroma values.
#' @param h A numeric vector of hue values in degrees. Values are normalized to
#'   the range 0-360.
#' @param alpha A numeric vector of alpha values in the range 0-1. Alpha is used
#'   only for hex generation and is ignored for name lookup.
#'
#' @return A character vector of color names in lowercase. If a color does not
#'   have a corresponding named entry, \code{NA} is returned for that element.
#'
#' @details
#' This function is vectorized and relies on \code{\link{oklch_to_hex}} followed by
#' \code{\link{hex_to_color}}. The same validation rules as \code{\link{oklch_to_hex}}
#' apply.
#'
#' @seealso
#' \code{\link{oklch_to_hex}} for hex output,
#' \code{\link{color_to_oklch}} for the reverse conversion,
#' \code{\link{hex_to_color}} for name lookup
#'
#' @export
#' @examples
#' # Convert OKLCH values for red to a color name
#' oklch_to_color(0.6279554, 0.2576833, 29.2338812)
oklch_to_color <- function(l, c = NULL, h = NULL, alpha = 1, ...) {
  # Allow passing a data frame, matrix, list, or named vector
  if (is.null(c) && is.null(h)) {
    if (is.data.frame(l) || is.matrix(l)) {
      alpha <- if ("alpha" %in% colnames(l)) l[, "alpha"] else alpha
      h <- l[, "h"]
      c <- l[, "c"]
      l <- l[, "l"]
    } else if (is.list(l) && !is.null(l$l) && !is.null(l$c) && !is.null(l$h)) {
      alpha <- if (!is.null(l$alpha)) l$alpha else alpha
      h <- l$h
      c <- l$c
      l <- l$l
    } else if (is.numeric(l) && !is.null(names(l)) &&
               all(c("l", "c", "h") %in% names(l))) {
      alpha <- if ("alpha" %in% names(l)) l[["alpha"]] else alpha
      h <- l[["h"]]
      c <- l[["c"]]
      l <- l[["l"]]
    }
  }

  hex_codes <- oklch_to_hex(l, c, h, alpha)
  hex_to_color(hex_codes, ...)
}
