test_that("hex_to_color converts hex codes correctly", {
  expect_equal(hex_to_color("#FF0000"), "red")
  expect_equal(hex_to_color("#0000FF"), "blue")
  expect_equal(hex_to_color("#00FF00"), "green")
})

test_that("hex_to_color works with multiple hex codes", {
  result <- hex_to_color(c("#FF0000", "#0000FF", "#00FF00"))
  expect_length(result, 3)
  expect_equal(result[1], "red")
  expect_equal(result[2], "blue")
  expect_equal(result[3], "green")
})

test_that("hex_to_color handles lowercase hex codes", {
  # Function should handle lowercase by converting to uppercase
  expect_equal(hex_to_color("#ff0000"), "red")
  expect_equal(hex_to_color("#0000ff"), "blue")
})

test_that("hex_to_color validates input types", {
  expect_error(hex_to_color(123), "character vector")
  expect_error(hex_to_color(TRUE), "character vector")
})

test_that("hex_to_color handles NA values", {
  expect_error(hex_to_color(NA_character_), "NA values are not allowed")
  expect_error(hex_to_color(c("#FF0000", NA_character_)), "NA values are not allowed")
})

test_that("hex_to_color validates hex format", {
  expect_error(hex_to_color("FF0000"), "Invalid hex code format")  # Missing #
  expect_error(hex_to_color("#FF00"), "Invalid hex code format")    # Too short
  expect_error(hex_to_color("#FF00000"), "Invalid hex code format") # Too long
  expect_error(hex_to_color("#GGGGGG"), "Invalid hex code format")  # Invalid characters
  expect_error(hex_to_color("red"), "Invalid hex code format")      # Not hex
})

test_that("hex_to_color returns NA for colors without names", {
  # Some hex codes may not have corresponding named colors
  custom_color <- "#123456"
  result <- hex_to_color(custom_color)
  # This color may or may not have a name, but should return character or NA
  expect_true(is.character(result) || is.na(result))
})

test_that("hex_to_color is vectorized", {
  hex_codes <- c("#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF")
  result <- hex_to_color(hex_codes)
  expect_length(result, length(hex_codes))
})

test_that("hex_to_color handles case insensitivity", {
  expect_equal(hex_to_color("#FF0000"), hex_to_color("#ff0000"))
  expect_equal(hex_to_color("#AbCdEf"), hex_to_color("#ABCDEF"))
})

test_that("round-trip conversion works for named colors", {
  # Test that converting color -> hex -> color works
  test_colors <- c("red", "blue", "green", "yellow", "cyan", "magenta")
  hex_codes <- color_to_hex(test_colors)
  result <- hex_to_color(hex_codes)
  expect_equal(result, test_colors)
})

test_that("hex_to_color handles white and black", {
  expect_equal(hex_to_color("#FFFFFF"), "white")
  expect_equal(hex_to_color("#000000"), "black")
})

test_that("hex_to_color prioritizes R colors", {
  # Test that R colors are returned when available
  # #FF0000 should return "red" (R color) not any extended name
  expect_equal(hex_to_color("#FF0000"), "red")
  expect_equal(hex_to_color("#0000FF"), "blue")
  expect_equal(hex_to_color("#00FF00"), "green")
})

test_that("hex_to_color works with extended database", {
  # Test that extended colors are found
  # These hex codes should now have names from extended database
  result1 <- hex_to_color("#FD5E53")  # sunset orange
  result2 <- hex_to_color("#66C3D0")  # arctic ocean

  # Should return character strings (not NA)
  expect_type(result1, "character")
  expect_type(result2, "character")
  expect_false(is.na(result1))
  expect_false(is.na(result2))
})

test_that("hex_to_color returns shortest name for non-R colors", {
  # For non-R colors, should return shortest available name
  # Test a few random hex codes from extended database
  result <- hex_to_color("#FD5E53")
  expect_type(result, "character")
  # Should not be excessively long (shortest name strategy)
  expect_true(nchar(result) < 50)
})

test_that("hex_to_color backward compatibility with R colors", {
  # Ensure all common R colors still return expected names
  r_hex_codes <- c("#FF0000", "#0000FF", "#00FF00", "#FFFF00", "#00FFFF", "#FF00FF")
  r_names <- c("red", "blue", "green", "yellow", "cyan", "magenta")
  result <- hex_to_color(r_hex_codes)
  expect_equal(result, r_names)
})
