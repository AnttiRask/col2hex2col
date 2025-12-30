#' Convert Color Names to Hex Codes
#'
#' Converts R color names to their hexadecimal color code representations.
#' This function accepts any valid R color name from the 657 built-in colors
#' available in \code{\link[grDevices]{colors}}.
#'
#' @param color A character vector of R color names (e.g., "red", "blue", "skyblue").
#'   Color names are case-sensitive and must match exactly as returned by
#'   \code{\link[grDevices]{colors}}.
#'
#' @return A character vector of hexadecimal color codes in the format "#RRGGBB",
#'   where each pair of characters represents the red, green, and blue components
#'   in hexadecimal notation (00-FF). The returned vector has the same length as
#'   the input.
#'
#' @details
#' The function performs input validation and will raise an error if:
#' \itemize{
#'   \item The input is not a character vector
#'   \item Any NA values are present
#'   \item Any invalid color names are provided
#' }
#'
#' This function is vectorized and efficiently handles both single colors and
#' vectors of multiple colors.
#'
#' @seealso
#' \code{\link{hex_to_color}} for the reverse conversion,
#' \code{\link[grDevices]{colors}} for available color names,
#' \code{\link[grDevices]{col2rgb}} for the underlying conversion function
#'
#' @export
#' @examples
#' # Convert a single color
#' color_to_hex("red")
#'
#' # Convert multiple colors
#' color_to_hex(c("red", "blue", "green"))
#'
#' # Works with all R color names
#' color_to_hex(c("skyblue", "coral", "chartreuse"))
#'
#' # Use in a data visualization context
#' colors <- c("steelblue", "firebrick", "forestgreen")
#' hex_codes <- color_to_hex(colors)
#' # hex_codes can now be used with plotting functions
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
#' Converts hexadecimal color codes to their corresponding R color names.
#' This function searches through R's built-in color names to find exact matches
#' for the provided hex codes.
#'
#' @param hex A character vector of hexadecimal color codes in the format "#RRGGBB"
#'   (e.g., "#FF0000", "#0000FF"). The hash symbol (#) is required, and the hex
#'   code is case-insensitive. Each component (RR, GG, BB) must be a two-digit
#'   hexadecimal value (00-FF).
#'
#' @return A character vector of R color names. If a hex code does not have a
#'   corresponding named color in R's color palette, \code{NA} is returned for
#'   that element. The returned vector has the same length as the input.
#'
#' @details
#' The function performs input validation and will raise an error if:
#' \itemize{
#'   \item The input is not a character vector
#'   \item Any NA values are present
#'   \item Any hex codes are not in the correct "#RRGGBB" format
#' }
#'
#' This function is case-insensitive for the hex values (e.g., "#FF0000" and
#' "#ff0000" are treated identically). When multiple color names map to the same
#' hex code, the first color name in R's \code{\link[grDevices]{colors}} list is
#' returned.
#'
#' Note that not all possible hex codes have corresponding named colors in R.
#' R provides 657 unique color names, but many hex codes will not have exact matches.
#'
#' @seealso
#' \code{\link{color_to_hex}} for the reverse conversion,
#' \code{\link[grDevices]{colors}} for available color names,
#' \code{\link[grDevices]{rgb}} for creating hex codes from RGB values
#'
#' @export
#' @examples
#' # Convert a single hex code
#' hex_to_color("#FF0000")
#'
#' # Convert multiple hex codes
#' hex_to_color(c("#FF0000", "#0000FF", "#00FF00"))
#'
#' # Case insensitive
#' hex_to_color("#ff0000")  # Same as "#FF0000"
#'
#' # Returns NA for colors without named equivalents
#' hex_to_color("#123456")
#'
#' # Round-trip conversion
#' original <- c("red", "blue", "green")
#' hex_codes <- color_to_hex(original)
#' hex_to_color(hex_codes)  # Returns original color names
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
