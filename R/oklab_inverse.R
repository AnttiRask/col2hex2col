# Convert OKLab to hex and color names

oklab_to_hex <- function(L, a, b, alpha = 1) {
  if (!is.numeric(L) || !is.numeric(a) || !is.numeric(b)) {
    stop("Inputs L, a, and b must be numeric")
  }
  if (!is.numeric(alpha)) {
    stop("Alpha must be numeric")
  }

  n <- length(L)
  if (!(length(a) == n && length(b) == n && (length(alpha) == 1 || length(alpha) == n))) {
    stop("L, a, b, and alpha must have compatible lengths")
  }

  L_vals <- as.numeric(L)
  a_vals <- as.numeric(a)
  b_vals <- as.numeric(b)
  alpha_vals <- if (length(alpha) == 1) rep(alpha, n) else as.numeric(alpha)

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

oklab_to_color <- function(L, a, b, alpha = 1) {
  hex_codes <- oklab_to_hex(L, a, b, alpha)
  hex_to_color(hex_codes)
}
