#' Convert HSL to Hex Codes
#'
#' Converts HSL (Hue, Saturation, Lightness) values to hexadecimal color codes.
#' An optional alpha channel can be supplied to generate 8-digit hex codes.
#'
#' @param h A numeric vector of hue values in degrees. Values are normalized to
#'   the range 0-360.
#' @param s A numeric vector of saturation values in the range 0-1.
#' @param l A numeric vector of lightness values in the range 0-1.
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
#'   \item Saturation, lightness, or alpha are outside the range 0-1
#'   \item Input lengths are incompatible
#' }
#'
#' This function is vectorized and recycles inputs following base R rules
#' (length-1 values are expanded and shorter vectors are recycled); a warning is
#' issued when lengths are not multiples of each other. Computed RGB values are
#' clamped to the 0-1 range before converting to hex codes.
#'
#' @references
#' \url{https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Values/color_value/hsl}
#'
#' @seealso
#' \code{\link{hsl_to_color}} for converting to color names,
#' \code{\link{hex_to_hsl}} for the reverse conversion
#'
#' @export
#' @examples
#' # Convert HSL values for red
#' hsl_to_hex(0, 1, 0.5)
#'
#' # Convert multiple HSL values
#' hsl_to_hex(c(0, 120, 240), c(1, 1, 1), c(0.5, 0.5, 0.5))
hsl_to_hex <- function(h, s = NULL, l = NULL, alpha = 1) {
  # Allow passing a data frame, matrix, list, or named vector from hex_to_hsl/color_to_hsl
  if (is.null(s) && is.null(l)) {
    if (is.data.frame(h) || is.matrix(h)) {
      alpha <- if ("alpha" %in% colnames(h)) h[, "alpha"] else alpha
      l <- h[, "l"]
      s <- h[, "s"]
      h <- h[, "h"]
    } else if (is.list(h) && !is.null(h$h) && !is.null(h$s) && !is.null(h$l)) {
      alpha <- if (!is.null(h$alpha)) h$alpha else alpha
      l <- h$l
      s <- h$s
      h <- h$h
    } else if (is.numeric(h) && !is.null(names(h)) &&
               all(c("h", "s", "l") %in% names(h))) {
      alpha <- if ("alpha" %in% names(h)) h[["alpha"]] else alpha
      l <- h[["l"]]
      s <- h[["s"]]
      h <- h[["h"]]
    }
  }

  if (!is.numeric(h) || !is.numeric(s) || !is.numeric(l)) {
    stop("Inputs h, s, and l must be numeric")
  }
  if (!is.numeric(alpha)) {
    stop("Alpha must be numeric")
  }

  lengths <- c(length(h), length(s), length(l), length(alpha))
  if (any(lengths == 0)) {
    return(character(0))
  }

  n <- max(lengths)
  if (any(lengths > 0 & (n %% lengths) != 0)) {
    warning("Input lengths are not multiples of each other and will be recycled.", call. = FALSE)
  }

  h_vals <- rep_len(as.numeric(h), n) %% 360
  s_vals <- rep_len(as.numeric(s), n)
  l_vals <- rep_len(as.numeric(l), n)
  alpha_vals <- rep_len(as.numeric(alpha), n)

  if (any(is.na(h_vals) | is.na(s_vals) | is.na(l_vals) | is.na(alpha_vals))) {
    stop("Inputs cannot contain NA")
  }

  if (any(s_vals < 0 | s_vals > 1) || any(l_vals < 0 | l_vals > 1) || any(alpha_vals < 0 | alpha_vals > 1)) {
    stop("s, l, and alpha must be between 0 and 1")
  }

  c_val <- (1 - abs(2 * l_vals - 1)) * s_vals
  h_sector <- h_vals / 60
  x_val <- c_val * (1 - abs((h_sector %% 2) - 1))

  r1 <- g1 <- b1 <- numeric(n)

  region <- floor(h_sector) %% 6

  r1[region == 0] <- c_val[region == 0]; g1[region == 0] <- x_val[region == 0]; b1[region == 0] <- 0
  r1[region == 1] <- x_val[region == 1]; g1[region == 1] <- c_val[region == 1]; b1[region == 1] <- 0
  r1[region == 2] <- 0; g1[region == 2] <- c_val[region == 2]; b1[region == 2] <- x_val[region == 2]
  r1[region == 3] <- 0; g1[region == 3] <- x_val[region == 3]; b1[region == 3] <- c_val[region == 3]
  r1[region == 4] <- x_val[region == 4]; g1[region == 4] <- 0; b1[region == 4] <- c_val[region == 4]
  r1[region == 5] <- c_val[region == 5]; g1[region == 5] <- 0; b1[region == 5] <- x_val[region == 5]

  m <- l_vals - c_val / 2
  r <- r1 + m
  g <- g1 + m
  b <- b1 + m

  clamp01 <- function(x) pmin(pmax(x, 0), 1)

  channel_hex <- function(x) sprintf("%02X", round(clamp01(x) * 255))
  rgb_hex <- paste0("#", channel_hex(r), channel_hex(g), channel_hex(b))

  alpha_hex <- channel_hex(clamp01(alpha_vals))
  use_alpha <- alpha_vals != 1
  rgb_hex[use_alpha] <- paste0(rgb_hex[use_alpha], alpha_hex[use_alpha])

  rgb_hex
}

#' Convert HSL to Color Names
#'
#' Converts HSL (Hue, Saturation, Lightness) values to color names using the
#' internal color database. The conversion first maps HSL to hex codes and then
#' uses \code{\link{hex_to_color}} for name lookup.
#'
#' @param h A numeric vector of hue values in degrees. Values are normalized to
#'   the range 0-360.
#' @param s A numeric vector of saturation values in the range 0-1.
#' @param l A numeric vector of lightness values in the range 0-1.
#' @param alpha A numeric vector of alpha values in the range 0-1. Alpha is used
#'   only for hex generation and is ignored for name lookup.
#'
#' @return A character vector of color names in lowercase. If a color does not
#'   have a corresponding named entry, \code{NA} is returned for that element.
#'
#' @details
#' This function is vectorized and relies on \code{\link{hsl_to_hex}} followed by
#' \code{\link{hex_to_color}}. The same validation rules as \code{\link{hsl_to_hex}}
#' apply.
#'
#' @seealso
#' \code{\link{hsl_to_hex}} for hex output,
#' \code{\link{color_to_hsl}} for the reverse conversion,
#' \code{\link{hex_to_color}} for name lookup
#'
#' @export
#' @examples
#' # Convert HSL values for red to a color name
#' hsl_to_color(0, 1, 0.5)
hsl_to_color <- function(h, s = NULL, l = NULL, alpha = 1, ...) {
  # Allow passing a data frame, matrix, list, or named vector
  if (is.null(s) && is.null(l)) {
    if (is.data.frame(h) || is.matrix(h)) {
      alpha <- if ("alpha" %in% colnames(h)) h[, "alpha"] else alpha
      l <- h[, "l"]
      s <- h[, "s"]
      h <- h[, "h"]
    } else if (is.list(h) && !is.null(h$h) && !is.null(h$s) && !is.null(h$l)) {
      alpha <- if (!is.null(h$alpha)) h$alpha else alpha
      l <- h$l
      s <- h$s
      h <- h$h
    } else if (is.numeric(h) && !is.null(names(h)) &&
               all(c("h", "s", "l") %in% names(h))) {
      alpha <- if ("alpha" %in% names(h)) h[["alpha"]] else alpha
      l <- h[["l"]]
      s <- h[["s"]]
      h <- h[["h"]]
    }
  }

  hex_codes <- hsl_to_hex(h, s, l, alpha)
  hex_to_color(hex_codes, ...)
}
