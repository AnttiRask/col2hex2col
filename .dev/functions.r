library(tidyverse)

# Color to hex
color_to_hex <- function(.color) {
  col2rgb(.color) %>%
    as_tibble(rownames = "channel") %>%
    pivot_longer(cols = -channel, values_to = "value") %>%
    pivot_wider(names_from = channel, values_from = value) %>%
    mutate(
      color = .color,
      hex = pmap_chr(
        list(red, green, blue),
        ~ rgb(..., maxColorValue = 255)
      )
    ) %>%
    pull(hex)
}

color_to_hex("red")

# Hex to color
hex_to_color <- function(.hex) {
  color_hex_map <- tibble(
    color = colors(),
    hex = rgb(t(col2rgb(colors())) / 255)
  ) %>%
    distinct(hex, .keep_all = TRUE)

  tibble(hex = .hex) %>%
    left_join(color_hex_map, by = "hex") %>%
    pull(color)
}

hex_to_color("#FF0000")
