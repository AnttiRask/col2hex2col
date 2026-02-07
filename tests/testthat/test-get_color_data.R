test_that("get_color_data returns a data frame", {
  result <- get_color_data()
  expect_s3_class(result, "data.frame")
})

test_that("get_color_data has correct columns", {
  result <- get_color_data()
  expect_true(all(c("name", "hex") %in% names(result)))
  if (requireNamespace("farver", quietly = TRUE)) {
    expect_true(all(c("lab_l", "lab_a", "lab_b") %in% names(result)))
  }
  expect_type(result$name, "character")
  expect_type(result$hex, "character")
})

test_that("get_color_data contains expected number of colors", {
  result <- get_color_data()
  # Database grows over time; should always have at least 32,000 colors
  expect_gte(nrow(result), 32000)
})

test_that("get_color_data colors are formatted correctly", {
  result <- get_color_data()

  # All names should be lowercase
  expect_true(all(result$name == tolower(result$name)))

  # All hex codes should be uppercase and in correct format
  expect_true(all(grepl("^#[0-9A-F]{6}$", result$hex)))
})

test_that("get_color_data is sorted by name", {
  result <- get_color_data()
  expect_equal(result$name, sort(result$name))
})

test_that("get_color_data contains R colors", {
  result <- get_color_data()

  # Check some known R colors are present
  expect_true("red" %in% result$name)
  expect_true("blue" %in% result$name)
  expect_true("forestgreen" %in% result$name)
})

test_that("get_color_data contains extended colors", {
  result <- get_color_data()

  # Check some extended colors are present
  expect_true("sunset orange" %in% result$name)
  expect_true("arctic ocean" %in% result$name)
})

test_that("get_color_data has unique color names", {
  result <- get_color_data()
  expect_equal(nrow(result), length(unique(result$name)))
})

test_that("get_color_data matches color_to_hex output", {
  result <- get_color_data()

  # Sample some colors and verify they match color_to_hex
  sample_colors <- c("red", "blue", "forestgreen", "sunset orange")
  sample_data <- result[result$name %in% sample_colors, ]

  for (i in seq_len(nrow(sample_data))) {
    expect_equal(
      sample_data$hex[i],
      color_to_hex(sample_data$name[i])
    )
  }
})
