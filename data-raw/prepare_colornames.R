# Data preparation script for col2hex2col package
# This script combines R's built-in colors with the extended color-names database
# from https://github.com/meodai/color-names (MIT license)

library(grDevices)

# Read the extended color names database
colornames_extended <- read.csv("data-raw/colornames.csv", stringsAsFactors = FALSE)

# Standardize extended colors:
# - Lowercase names
# - Uppercase hex codes
# - Trim whitespace
colornames_extended$name <- tolower(trimws(colornames_extended$name))
colornames_extended$hex <- toupper(trimws(colornames_extended$hex))

# Get R's built-in colors
r_colors <- colors()
r_hex <- toupper(rgb(t(col2rgb(r_colors)), maxColorValue = 255))
colornames_r <- data.frame(
  name = tolower(r_colors),
  hex = r_hex,
  source = "r",
  stringsAsFactors = FALSE
)

# Add source column to extended
colornames_extended$source <- "extended"

# Combine both datasets
colornames_all <- rbind(colornames_r, colornames_extended)

# Build name-to-hex lookup (all names should map uniquely to hex)
# If duplicate names exist, prefer R colors
colornames_name_to_hex <- colornames_all[!duplicated(colornames_all$name), ]
# Convert to named vector for fast lookup
colornames_name_to_hex_vector <- setNames(
  colornames_name_to_hex$hex,
  colornames_name_to_hex$name
)

# Build hex-to-name lookup (multiple names may map to same hex)
# Strategy: Prefer R colors first, then use shortest name from extended
colornames_hex_to_name <- split(colornames_all, colornames_all$hex)
colornames_hex_to_name_vector <- sapply(colornames_hex_to_name, function(group) {
  # Prioritize R colors
  r_names <- group$name[group$source == "r"]
  if (length(r_names) > 0) {
    # If multiple R names exist for same hex (rare), use first
    return(r_names[1])
  }
  # Otherwise, use shortest name from extended database
  extended_names <- group$name[group$source == "extended"]
  if (length(extended_names) > 0) {
    shortest_idx <- which.min(nchar(extended_names))
    return(extended_names[shortest_idx])
  }
  # Fallback (should never happen)
  return(group$name[1])
})

# Save as internal package data (not exported to users)
usethis::use_data(
  colornames_name_to_hex_vector,
  colornames_hex_to_name_vector,
  internal = TRUE,
  overwrite = TRUE
)

# Print summary statistics
cat("Data preparation complete!\n")
cat("Total unique color names:", length(colornames_name_to_hex_vector), "\n")
cat("Total unique hex codes:", length(colornames_hex_to_name_vector), "\n")
cat("R colors:", sum(colornames_all$source == "r"), "\n")
cat("Extended colors:", sum(colornames_all$source == "extended"), "\n")
