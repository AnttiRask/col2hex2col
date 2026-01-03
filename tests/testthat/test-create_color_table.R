test_that("create_color_table requires gt package", {
  # Only test error message when gt is NOT installed
  skip_if(requireNamespace("gt", quietly = TRUE), "gt is installed")

  df <- data.frame(hex = "#FF0000")
  expect_error(
    create_color_table(df),
    "Package 'gt' is required"
  )
})

test_that("create_color_table gives helpful error when gt missing", {
  # Only test error message when gt is NOT installed
  skip_if(requireNamespace("gt", quietly = TRUE), "gt is installed")

  df <- data.frame(hex = "#FF0000")
  expect_error(
    create_color_table(df),
    "install.packages"
  )
})

test_that("create_color_table validates input is data frame", {
  skip_if_not_installed("gt")

  expect_error(
    create_color_table("not a data frame"),
    "Input must be a data frame"
  )

  expect_error(
    create_color_table(c("#FF0000", "#0000FF")),
    "Input must be a data frame"
  )
})

test_that("create_color_table requires hex column", {
  skip_if_not_installed("gt")

  df_no_hex <- data.frame(name = "red", color = "#FF0000")
  expect_error(
    create_color_table(df_no_hex),
    "Data frame must contain a 'hex' column"
  )
})

test_that("create_color_table works with minimal input", {
  skip_if_not_installed("gt")

  df <- data.frame(hex = c("#FF0000", "#0000FF"))
  result <- create_color_table(df)

  expect_s3_class(result, "gt_tbl")
})

test_that("create_color_table works with name column", {
  skip_if_not_installed("gt")

  df <- data.frame(
    name = c("red", "blue"),
    hex = c("#FF0000", "#0000FF")
  )
  result <- create_color_table(df)

  expect_s3_class(result, "gt_tbl")
})

test_that("create_color_table works with get_color_data output", {
  skip_if_not_installed("gt")

  colors_df <- get_color_data()
  sample_df <- head(colors_df, 5)

  result <- create_color_table(sample_df)
  expect_s3_class(result, "gt_tbl")
})

test_that("create_color_table handles various hex formats", {
  skip_if_not_installed("gt")

  df <- data.frame(
    hex = c("#FF0000", "#00FF00", "#0000FF", "#FFFFFF", "#000000")
  )
  result <- create_color_table(df)

  expect_s3_class(result, "gt_tbl")
})
