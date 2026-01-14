# Find the nearest named color for a given hex code using Lab distance

# If this function is accepted, the following should be implemnted:
  # {fraver} added as a suggestion namespace
  # color_table should be pre-computed with Lab values - and remove computation from inside the function
    # Optional: compute other metrices as well (checkout farver for more details, OKLab, ΔE2000..)
    # Optional: allow fallback to R-specific color names, rather than the full color table
  # Add optional argument to `hex_to_color`, either named or not (fallback/...). it will be passed to other color-spacing functions, such as hsl, oklab..
    


fallback_nearest_hex <- function(hex, color_table = get_color_data()) {
  if (!requireNamespace("farver", quietly = TRUE)) {
    stop(
      "Package 'farver' is required for fallback_nearest_hex(). ",
      "Install it with: install.packages('farver')",
      call. = FALSE
    )
  }

  if (!is.character(hex)) {
    stop("hex must be a character vector of hex codes")
  }

  # i mean, ill leave it. but this is kinda verbose...
  if (!is.data.frame(color_table) || !all(c("name", "hex") %in% names(color_table))) {
    stop("color_table must be a data frame with columns 'name' and 'hex'")
  }

  if (any(is.na(hex))) {
    stop("hex cannot contain NA values")
  }

  # Convert hex codes to Lab
  hex_lab <- farver::decode_colour(hex, to = "lab")

  # Convert reference colors to Lab 
      # TODO: // THIS SHOULD DEFINETLY BE PRE-COMPUTED in color_table
  ref_lab <- farver::decode_colour(color_table$hex, to = "lab")

  nearest <- vapply(
    seq_len(nrow(hex_lab)),
    function(i) {
      distances <- sqrt(
        (hex_lab[i, 1] - ref_lab[, 1])^2 +
          (hex_lab[i, 2] - ref_lab[, 2])^2 +
          (hex_lab[i, 3] - ref_lab[, 3])^2
      )
      color_table$name[which.min(distances)]
    },
    character(1)
  )

  unname(nearest)
}