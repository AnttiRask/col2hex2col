#' Create Color Swatch Table
#'
#' Creates a visual table displaying color names, hex codes, and color swatches.
#' Requires the \code{gt} package to be installed.
#'
#' @param df A data frame with at minimum a column named \code{hex} containing
#'   hexadecimal color codes. Any additional columns will be included in the
#'   table. The first column (if not \code{hex}) will be automatically labeled
#'   as "Color Name" in the output table, regardless of its original name.
#'
#' @return A \code{gt} table object displaying the colors with visual swatches.
#'   The table will have columns for color names (if provided), hex codes, and
#'   a color swatch column where each cell is filled with the corresponding color.
#'
#' @details
#' This function creates an enhanced table using the \code{gt} package. The table
#' includes:
#' \itemize{
#'   \item Color names (if the \code{name} column exists in the input)
#'   \item Hexadecimal color codes
#'   \item Visual color swatches (cells filled with the actual colors)
#' }
#'
#' The \code{gt} package must be installed to use this function. If it's not
#' installed, the function will provide instructions on how to install it.
#'
#' You can pass the output of \code{\link{get_color_data}} directly to this
#' function, or create a custom data frame with your own color selection.
#'
#' @seealso
#' \code{\link{get_color_data}} for obtaining the complete color database,
#' \code{\link{color_to_hex}} for converting color names to hex codes
#'
#' @export
#' @examples
#' # Create a table with a few colors
#' colors_df <- data.frame(
#'   name = c("red", "blue", "forestgreen"),
#'   hex = c("#FF0000", "#0000FF", "#228B22")
#' )
#'
#' # Only run if gt is available
#' if (requireNamespace("gt", quietly = TRUE)) {
#'   create_color_table(colors_df)
#'
#'   # Use with get_color_data() - show first 10 colors
#'   all_colors <- get_color_data()
#'   create_color_table(head(all_colors, 10))
#'
#'   # Create a table with only specific colors
#'   blue_colors <- all_colors[grepl("blue", all_colors$name), ]
#'   create_color_table(head(blue_colors, 20))
#'
#'   # Minimal example with just hex codes
#'   hex_only <- data.frame(hex = c("#FF0000", "#00FF00", "#0000FF"))
#'   create_color_table(hex_only)
#' }
create_color_table <- function(df) {
  # Avoid R CMD check NOTE about undefined global variable
  swatch <- NULL

  # Check if gt is installed
  if (!requireNamespace("gt", quietly = TRUE)) {
    stop(
      "Package 'gt' is required for create_color_table() but is not installed.\n",
      "Install it with: install.packages(\"gt\")",
      call. = FALSE
    )
  }

  # Input validation
  if (!is.data.frame(df)) {
    stop("Input must be a data frame", call. = FALSE)
  }

  if (!"hex" %in% names(df)) {
    stop("Data frame must contain a 'hex' column", call. = FALSE)
  }

  # Create swatch column
  df$swatch <- df$hex

  # Build gt table
  tbl <- gt::gt(df)

  # Build column labels dynamically
  col_labels <- list(hex = "Hex Code", swatch = "Swatch")

  # Add LAB column labels if present
  if ("lab_l" %in% names(df)) col_labels$lab_l <- "Lab L"
  if ("lab_a" %in% names(df)) col_labels$lab_a <- "Lab a"
  if ("lab_b" %in% names(df)) col_labels$lab_b <- "Lab b"

  # Auto-rename first column to "Color Name" if it's not hex or a LAB column
  first_col <- names(df)[1]
  lab_cols <- c("lab_l", "lab_a", "lab_b")
  if (first_col != "hex" && !first_col %in% lab_cols) {
    col_labels[[first_col]] <- "Color Name"
  }

  # Apply column labels
  tbl <- do.call(gt::cols_label, c(list(tbl), col_labels))

  # Apply color to swatch column
  tbl <- gt::data_color(
    tbl,
    columns = swatch,
    apply_to = "fill",
    fn = identity
  )

  # Make swatch column text invisible (just show the color)
  tbl <- gt::text_transform(
    tbl,
    locations = gt::cells_body(columns = swatch),
    fn = function(x) rep("", length(x))
  )

  tbl
}
