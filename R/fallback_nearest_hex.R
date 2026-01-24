# Find the nearest named color for a given hex code using Lab distance

fallback_nearest_hex <- function(hex, color_table = get_color_data(), distance = c("lab")) {
  distance <- match.arg(distance)

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

  if (!is.data.frame(color_table) || !all(c("name", "hex") %in% names(color_table))) {
    stop("color_table must be a data frame with columns 'name' and 'hex'")
  }

  if (any(is.na(hex))) {
    stop("hex cannot contain NA values")
  }

  hex_std <- toupper(hex)
  hex_std <- ifelse(nchar(hex_std) == 9, substr(hex_std, 1, 7), hex_std)

  # Exact matches first (no warning, keeps fast path)
  exact_matches <- colornames_hex_to_name_vector[hex_std]
  needs_fallback <- is.na(exact_matches)
  if (!any(needs_fallback)) {
    return(unname(exact_matches))
  }

  # Ensure Lab columns are present and use them instead of recomputing
  if (!all(c("lab_l", "lab_a", "lab_b") %in% names(color_table))) {
    lab <- farver::decode_colour(color_table$hex, to = "lab")
    colnames(lab) <- c("lab_l", "lab_a", "lab_b")
    color_table <- cbind(color_table, lab)
  }

  ref_lab <- as.matrix(color_table[, c("lab_l", "lab_a", "lab_b")])
  hex_lab <- farver::decode_colour(hex_std[needs_fallback], to = distance)

  nearest <- vapply(
    seq_len(nrow(hex_lab)),
    function(i) {
      dl <- ref_lab[, 1] - hex_lab[i, 1]
      da <- ref_lab[, 2] - hex_lab[i, 2]
      db <- ref_lab[, 3] - hex_lab[i, 3]
      color_table$name[which.min(dl * dl + da * da + db * db)]
    },
    character(1)
  )

  exact_matches[needs_fallback] <- nearest
  unname(exact_matches)
}
