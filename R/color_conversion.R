#' Convert Color Names to Hex Codes
#'
#' @param color A character vector of color names (e.g., "red", "blue")
#' @return A character vector of hex color codes
#' @export
#' @examples
#' color_to_hex("red")
#' color_to_hex(c("red", "blue", "green"))
color_to_hex <- function(color) {
  # Input validation
  if (!is.character(color)) {
    stop("Input must be a character vector of color names")
  }

  if (any(is.na(color))) {
    stop("NA values are not allowed in color names")
  }

  # Convert to hex using base R for better performance
  # col2rgb returns a matrix, rgb converts back to hex
  rgb_matrix <- tryCatch(
    col2rgb(color),
    error = function(e) {
      stop("Invalid color name(s) provided: ", e$message)
    }
  )

  # Convert RGB matrix to hex codes
  rgb(t(rgb_matrix), maxColorValue = 255)
}


#' Convert Hex Codes to Color Names
#'
#' @param hex A character vector of hex color codes (e.g., "#FF0000")
#' @return A character vector of color names (NA if no exact match found)
#' @export
#' @examples
#' hex_to_color("#FF0000")
#' hex_to_color(c("#FF0000", "#0000FF"))
hex_to_color <- function(hex) {
  # Input validation
  if (!is.character(hex)) {
    stop("Input must be a character vector of hex codes")
  }

  if (any(is.na(hex))) {
    stop("NA values are not allowed in hex codes")
  }

  # Validate hex format
  hex_pattern <- "^#[0-9A-Fa-f]{6}$"
  if (!all(grepl(hex_pattern, hex))) {
    invalid <- hex[!grepl(hex_pattern, hex)]
    stop("Invalid hex code format. Expected format: #RRGGBB. Invalid values: ",
         paste(invalid, collapse = ", "))
  }

  # Create lookup table once (cached for performance)
  # This is more efficient than creating it each time
  color_hex_map <- .get_color_hex_map()

  # Match hex codes to color names
  matched_colors <- color_hex_map$color[match(toupper(hex), color_hex_map$hex)]

  matched_colors
}


#' Get Color to Hex Lookup Table
#'
#' Internal function to create and cache the color-to-hex mapping
#' @return A data frame with color names and their hex codes
#' @keywords internal
.get_color_hex_map <- function() {
  all_colors <- grDevices::colors()
  hex_codes <- grDevices::rgb(t(grDevices::col2rgb(all_colors)) / 255)

  # Create data frame and remove duplicates (keep first occurrence)
  df <- data.frame(
    color = all_colors,
    hex = toupper(hex_codes),
    stringsAsFactors = FALSE
  )

  # Remove duplicate hex codes, keeping first color name
  df[!duplicated(df$hex), ]
}
