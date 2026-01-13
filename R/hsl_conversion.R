# Convert color inputs to HSL
# Uses the existing color name database (base R + extended) via color_to_hex()

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
  red_is_max <- maxc == r
  green_is_max <- maxc == g
  blue_is_max <- maxc == b

  hue_base[red_is_max] <- ((g[red_is_max] - b[red_is_max]) / delta[red_is_max]) %% 6
  hue_base[green_is_max] <- ((b[green_is_max] - r[green_is_max]) / delta[green_is_max]) + 2
  hue_base[blue_is_max] <- ((r[blue_is_max] - g[blue_is_max]) / delta[blue_is_max]) + 4

  h <- (hue_base * 60) %% 360
  h[delta == 0] <- 0

  data.frame(
    h = h,
    s = s,
    l = l,
    alpha = alpha,
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

color_to_hsl <- function(color) {
  if (!is.character(color)) {
    stop("Input must be a character vector of color names")
  }

  hex_codes <- color_to_hex(color)
  hex_to_hsl(hex_codes)
}
