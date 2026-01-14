# Convert color inputs to OKLab
# Uses the existing color name database (base R + extended) via color_to_hex()

hex_to_oklab <- function(hex) {
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

  to_linear <- function(x) ifelse(x <= 0.04045, x / 12.92, ((x + 0.055) / 1.055) ^ 2.4)
  r_lin <- to_linear(r)
  g_lin <- to_linear(g)
  b_lin <- to_linear(b)

  rgb_lin <- rbind(r_lin, g_lin, b_lin)

  m1 <- matrix(
    c(
      0.4122214708, 0.5363325363, 0.0514459929,
      0.2119034982, 0.6806995451, 0.1073969566,
      0.0883024619, 0.2817188376, 0.6299787005
    ),
    nrow = 3,
    byrow = TRUE
  )

  m2 <- matrix(
    c(
      0.2104542553, 0.7936177850, -0.0040720468,
      1.9779984951, -2.4285922050, 0.4505937099,
      0.0259040371, 0.7827717662, -0.8086757660
    ),
    nrow = 3,
    byrow = TRUE
  )

  lms <- m1 %*% rgb_lin
  lms_cbrt <- lms ^ (1 / 3)
  lab <- m2 %*% lms_cbrt

  data.frame(
    L = lab[1, ],
    a = lab[2, ],
    b = lab[3, ],
    alpha = alpha,
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

color_to_oklab <- function(color) {
  if (!is.character(color)) {
    stop("Input must be a character vector of color names")
  }

  hex_codes <- color_to_hex(color)
  hex_to_oklab(hex_codes)
}
