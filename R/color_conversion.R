#' Convert Color Names to Hex Codes
#'
#' Converts color names to their hexadecimal color code representations.
#' This function accepts color names from an extensive database of over 32,000
#' color names, including all 657 built-in R colors from \code{\link[grDevices]{colors}}
#' plus the comprehensive color-names database from \url{https://github.com/meodai/color-names}.
#'
#' @param color A character vector of color names (e.g., "red", "blue", "sunset orange").
#'   Color names are case-insensitive and whitespace is trimmed. Spaces within color
#'   names are preserved (e.g., "sky blue" is different from "skyblue").
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
#' vectors of multiple colors. The extended database includes 32,462 unique
#' color names from various sources, making it suitable for a wide range of
#' color specification needs.
#'
#' Color name matching is case-insensitive: "Red", "red", and "RED" all match
#' the same color.
#'
#' @seealso
#' \code{\link{hex_to_color}} for the reverse conversion,
#' \code{\link[grDevices]{colors}} for R's built-in color names
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
#' # Also works with extended color names
#' color_to_hex(c("sunset orange", "arctic ocean", "forest green"))
#'
#' # Case insensitive
#' color_to_hex(c("Red", "BLUE", "Green"))
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

  # Standardize input: lowercase and trim
  color_standardized <- tolower(trimws(color))

  # Look up hex codes from internal database
  hex_codes <- colornames_name_to_hex_vector[color_standardized]

  # Check for invalid color names
  invalid <- is.na(hex_codes)
  if (any(invalid)) {
    invalid_names <- color[invalid]
    stop("Invalid color name(s) provided: ",
         paste(invalid_names, collapse = ", "))
  }

  # Return hex codes (already in uppercase from data preparation)
  unname(hex_codes)
}


#' Convert Hex Codes to Color Names
#'
#' Converts hexadecimal color codes to their corresponding color names.
#' This function searches through an extensive database of over 32,000 color names,
#' prioritizing R's built-in color names when available.
#'
#' @param hex A character vector of hexadecimal color codes in the format "#RRGGBB"
#'   (e.g., "#FF0000", "#0000FF"). The hash symbol (#) is required, and the hex
#'   code is case-insensitive. Each component (RR, GG, BB) must be a two-digit
#'   hexadecimal value (00-FF).
#'
#' @return A character vector of color names (in lowercase). If a hex code does not have a
#'   corresponding named color in the database, \code{NA} is returned for that element.
#'   The returned vector has the same length as the input.
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
#' "#ff0000" are treated identically).
#'
#' **Name Selection Strategy**: When multiple color names map to the same hex code:
#' \enumerate{
#'   \item R's built-in color names are prioritized (from \code{\link[grDevices]{colors}})
#'   \item If no R color exists, the shortest name from the extended database is returned
#' }
#'
#' This ensures backward compatibility with R's color system while providing coverage
#' for the 32,161 unique hex codes in the extended database.
#'
#' The extended database includes colors from \url{https://github.com/meodai/color-names},
#' significantly increasing the likelihood of finding a named match for any given hex code.
#'
#' @seealso
#' \code{\link{color_to_hex}} for the reverse conversion,
#' \code{\link[grDevices]{colors}} for R's built-in color names
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
#' # Works with extended color database
#' hex_to_color("#FF6347")  # Returns a descriptive color name
#'
#' # Returns NA for colors without named equivalents (rare)
#' hex_to_color("#ABCDEF")
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

  # Standardize hex codes to uppercase
  hex_standardized <- toupper(hex)

  # Look up color names from internal database
  # (Already prioritizes R colors over extended database)
  color_names <- colornames_hex_to_name_vector[hex_standardized]

  # Return color names (in lowercase, as stored in database)
  unname(color_names)
}
