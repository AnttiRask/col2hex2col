# color data cache to avoid recomputation
.col2hex_cache_env <- new.env(parent = emptyenv())

#' Get Color Database
#' 
#' Returns the complete color database as a data frame containing all 32,000+
#' color names and their corresponding hexadecimal codes.
#'
#' @return A data frame with the following columns:
#' \describe{
#'   \item{name}{Character vector of color names (lowercase)}
#'   \item{hex}{Character vector of hexadecimal color codes (uppercase, format: #RRGGBB)}
#'   \item{lab_l, lab_a, lab_b}{(Optional) LAB color space coordinates, added when
#'     the \code{farver} package is available}
#' }
#'
#' The data frame contains over 32,000 rows representing all available colors,
#' including both R's 657 built-in colors and the extended color-names database.
#'
#' @details
#' The returned data frame is sorted alphabetically by color name. Each color
#' name maps to exactly one hex code, though multiple color names may share
#' the same hex code.
#'
#' This function is useful for:
#' \itemize{
#'   \item Exploring available color names
#'   \item Creating custom color palettes
#'   \item Searching for colors by name pattern
#'   \item Analyzing color distributions
#'   \item Building color visualization tools
#' }
#'
#' @seealso
#' \code{\link{color_to_hex}} for converting specific color names to hex codes,
#' \code{\link{hex_to_color}} for the reverse conversion,
#' \code{\link{create_color_table}} for creating visual color tables
#'
#' @export
#' @examples
#' # Get the complete color database
#' colors_df <- get_color_data()
#' head(colors_df)
#'
#' # See dimensions
#' dim(colors_df)
#'
#' # Find all colors containing "blue"
#' blue_colors <- colors_df[grepl("blue", colors_df$name), ]
#' head(blue_colors)
#'
#' # Get a random sample of colors
#' set.seed(123)
#' sample_colors <- colors_df[sample(nrow(colors_df), 10), ]
#' sample_colors
get_color_data <- function() {
  if (!is.null(.col2hex_cache_env$color_data_cache)) {
    return(.col2hex_cache_env$color_data_cache)
  }

  # Create data frame from internal lookup vector
  df <- data.frame(
    name = names(colornames_name_to_hex_vector),
    hex = unname(colornames_name_to_hex_vector),
    stringsAsFactors = FALSE,
    row.names = NULL
  )

  # Pre-compute Lab coordinates if farver is available
  if (requireNamespace("farver", quietly = TRUE)) {
    lab <- farver::decode_colour(df$hex, to = "lab")
    colnames(lab) <- c("lab_l", "lab_a", "lab_b")
    df <- cbind(df, lab)
  }

  # Sort by name for easier browsing
  df <- df[order(df$name), ]
  row.names(df) <- NULL
  .col2hex_cache_env$color_data_cache <- df
  .col2hex_cache_env$color_data_cache
}
