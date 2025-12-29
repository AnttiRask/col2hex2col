test_that("color_to_hex converts single color names correctly", {
  expect_equal(color_to_hex("red"), "#FF0000")
  expect_equal(color_to_hex("blue"), "#0000FF")
  expect_equal(color_to_hex("green"), "#00FF00")
  expect_equal(color_to_hex("white"), "#FFFFFF")
  expect_equal(color_to_hex("black"), "#000000")
})

test_that("color_to_hex works with multiple colors", {
  result <- color_to_hex(c("red", "blue", "green"))
  expect_length(result, 3)
  expect_equal(result, c("#FF0000", "#0000FF", "#00FF00"))
})

test_that("color_to_hex handles different color name formats", {
  # R accepts various color names
  expect_type(color_to_hex("cyan"), "character")
  expect_type(color_to_hex("magenta"), "character")
  expect_type(color_to_hex("yellow"), "character")
})

test_that("color_to_hex validates input types", {
  expect_error(color_to_hex(123), "character vector")
  expect_error(color_to_hex(TRUE), "character vector")
  expect_error(color_to_hex(list("red")), "character vector")
})

test_that("color_to_hex handles NA values", {
  expect_error(color_to_hex(NA_character_), "NA values are not allowed")
  expect_error(color_to_hex(c("red", NA_character_, "blue")), "NA values are not allowed")
})

test_that("color_to_hex handles invalid color names", {
  expect_error(color_to_hex("notacolor"), "Invalid color name")
  expect_error(color_to_hex(c("red", "invalidcolor")), "Invalid color name")
})

test_that("color_to_hex output format is correct", {
  result <- color_to_hex("red")
  expect_match(result, "^#[0-9A-F]{6}$")
})

test_that("color_to_hex is vectorized", {
  colors <- c("red", "green", "blue", "yellow", "cyan", "magenta")
  result <- color_to_hex(colors)
  expect_length(result, length(colors))
  expect_true(all(grepl("^#[0-9A-F]{6}$", result)))
})

test_that("color_to_hex handles all base R colors", {
  # Test a sample of R's built-in colors
  sample_colors <- c("aliceblue", "antiquewhite", "aquamarine", "azure", "beige")
  result <- color_to_hex(sample_colors)
  expect_length(result, length(sample_colors))
  expect_true(all(grepl("^#[0-9A-F]{6}$", result)))
})
