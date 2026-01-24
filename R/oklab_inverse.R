#' Convert OKLab to Hex Codes
#'
#' Converts OKLab values (L, a, b) to hexadecimal color codes. An optional alpha
#' channel can be supplied to generate 8-digit hex codes.
#'
#' @param L A numeric vector of OKLab lightness values.
#' @param a A numeric vector of OKLab a component values.
#' @param b A numeric vector of OKLab b component values.
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
#' \url{https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/oklab}
#'
#' @seealso
#' \code{\link{oklab_to_color}} for converting to color names,
#' \code{\link{hex_to_oklab}} for the reverse conversion
#'
#' @export
#' @examples
#' # Convert OKLab values for red
#' oklab_to_hex(0.6279554, 0.2248631, 0.1258463)
#'
#' # Convert multiple OKLab values
#' oklab_to_hex(c(0.62, 0.5), c(0.2, -0.1), c(0.12, 0.05))
oklab_to_hex <- function(L, a = NULL, b = NULL, alpha = 1) {
  # Allow passing a data frame, matrix, list, or named vector from hex_to_oklab/color_to_oklab
  if (is.null(a) && is.null(b)) {
    if (is.data.frame(L) || is.matrix(L)) {
      alpha <- if ("alpha" %in% colnames(L)) L[, "alpha"] else alpha
      b <- L[, "b"]
      a <- L[, "a"]
      L <- L[, "L"]
    } else if (is.list(L) && !is.null(L$L) && !is.null(L$a) && !is.null(L$b)) {
      alpha <- if (!is.null(L$alpha)) L$alpha else alpha
      b <- L$b
      a <- L$a
      L <- L$L
    } else if (is.numeric(L) && !is.null(names(L)) &&
               all(c("L", "a", "b") %in% names(L))) {
      alpha <- if ("alpha" %in% names(L)) L[["alpha"]] else alpha
      b <- L[["b"]]
      a <- L[["a"]]
      L <- L[["L"]]
    }
  }

  if (!is.numeric(L) || !is.numeric(a) || !is.numeric(b)) {
    stop("Inputs L, a, and b must be numeric")
  }
  if (!is.numeric(alpha)) {
    stop("Alpha must be numeric")
  }

  lengths <- c(length(L), length(a), length(b), length(alpha))
  if (any(lengths == 0)) {
    return(character(0))
  }

  n <- max(lengths)
  if (any(lengths > 0 & (n %% lengths) != 0)) {
    warning("Input lengths are not multiples of each other and will be recycled.", call. = FALSE)
  }

  L_vals <- rep_len(as.numeric(L), n)
  a_vals <- rep_len(as.numeric(a), n)
  b_vals <- rep_len(as.numeric(b), n)
  alpha_vals <- rep_len(as.numeric(alpha), n)

  if (any(is.na(L_vals) | is.na(a_vals) | is.na(b_vals) | is.na(alpha_vals))) {
    stop("Inputs cannot contain NA")
  }

  l_ <- (L_vals + 0.3963377774 * a_vals + 0.2158037573 * b_vals) ^ 3
  m_ <- (L_vals - 0.1055613458 * a_vals - 0.0638541728 * b_vals) ^ 3
  s_ <- (L_vals - 0.0894841775 * a_vals - 1.2914855480 * b_vals) ^ 3

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

#' Convert OKLab to Color Names
#'
#' Converts OKLab values to color names using the internal color database. The
#' conversion first maps OKLab to hex codes and then uses \code{\link{hex_to_color}}
#' for name lookup.
#'
#' @param L A numeric vector of OKLab lightness values.
#' @param a A numeric vector of OKLab a component values.
#' @param b A numeric vector of OKLab b component values.
#' @param alpha A numeric vector of alpha values in the range 0-1. Alpha is used
#'   only for hex generation and is ignored for name lookup.
#'
#' @return A character vector of color names in lowercase. If a color does not
#'   have a corresponding named entry, \code{NA} is returned for that element.
#'
#' @details
#' This function is vectorized and relies on \code{\link{oklab_to_hex}} followed by
#' \code{\link{hex_to_color}}. The same validation rules as \code{\link{oklab_to_hex}}
#' apply.
#'
#' @seealso
#' \code{\link{oklab_to_hex}} for hex output,
#' \code{\link{color_to_oklab}} for the reverse conversion,
#' \code{\link{hex_to_color}} for name lookup
#'
#' @export
#' @examples
#' # Convert OKLab values for red to a color name
#' oklab_to_color(0.6279554, 0.2248631, 0.1258463)
oklab_to_color <- function(L, a = NULL, b = NULL, alpha = 1, ...) {
  # Allow passing a data frame, matrix, list, or named vector
  if (is.null(a) && is.null(b)) {
    if (is.data.frame(L) || is.matrix(L)) {
      alpha <- if ("alpha" %in% colnames(L)) L[, "alpha"] else alpha
      b <- L[, "b"]
      a <- L[, "a"]
      L <- L[, "L"]
    } else if (is.list(L) && !is.null(L$L) && !is.null(L$a) && !is.null(L$b)) {
      alpha <- if (!is.null(L$alpha)) L$alpha else alpha
      b <- L$b
      a <- L$a
      L <- L$L
    } else if (is.numeric(L) && !is.null(names(L)) &&
               all(c("L", "a", "b") %in% names(L))) {
      alpha <- if ("alpha" %in% names(L)) L[["alpha"]] else alpha
      b <- L[["b"]]
      a <- L[["a"]]
      L <- L[["L"]]
    }
  }

  hex_codes <- oklab_to_hex(L, a, b, alpha)
  hex_to_color(hex_codes, ...)
}
