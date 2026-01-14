# Convert HSL to hex and color names

hsl_to_hex <- function(h, s, l, alpha = 1) {
  if (!is.numeric(h) || !is.numeric(s) || !is.numeric(l)) {
    stop("Inputs h, s, and l must be numeric")
  }
  if (!is.numeric(alpha)) {
    stop("Alpha must be numeric")
  }

  n <- length(h)
  if (!(length(s) == n && length(l) == n && (length(alpha) == 1 || length(alpha) == n))) {
    stop("h, s, l, and alpha must have compatible lengths")
  }

  h_vals <- as.numeric(h) %% 360
  s_vals <- as.numeric(s)
  l_vals <- as.numeric(l)
  alpha_vals <- if (length(alpha) == 1) rep(alpha, n) else as.numeric(alpha)

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

hsl_to_color <- function(h, s, l, alpha = 1) {
  hex_codes <- hsl_to_hex(h, s, l, alpha)
  hex_to_color(hex_codes)
}
