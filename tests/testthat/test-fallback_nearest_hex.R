test_that("hex_to_color falls back to nearest when no exact match", {
  skip_if_not_installed("farver")

  table_hex <- get_color_data()$hex
  candidate <- "#123456"
  if (candidate %in% table_hex) {
    pool <- sprintf("#%06X", sample.int(16^6, 10) - 1)
    candidate <- setdiff(pool, table_hex)[1]
  }

  expect_warning({
    res <- hex_to_color(candidate, fallback_nearest_color = TRUE)
    expect_type(res, "character")
    expect_false(is.na(res))
    expect_length(res, 1)
  }, "falling back")
})
