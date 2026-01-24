test_that("hex_to_hsl returns expected values for red", {
  result <- col2hex2col:::hex_to_hsl("#FF0000")

  expect_named(result, c("h", "s", "l", "alpha"))
  expect_equal(unname(result["h"]), 0)
  expect_equal(unname(result["s"]), 1)
  expect_equal(unname(result["l"]), 0.5)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("color_to_hsl returns expected values for red", {
  result <- col2hex2col:::color_to_hsl("red")

  expect_named(result, c("h", "s", "l", "alpha"))
  expect_equal(unname(result["h"]), 0)
  expect_equal(unname(result["s"]), 1)
  expect_equal(unname(result["l"]), 0.5)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("hsl round-trips through hex and color names", {
  # use a non-basic color from the table
  result <- color_to_hex("lightblue") |> col2hex2col:::hex_to_hsl() |> col2hex2col:::hsl_to_color()
  expect_equal(result, "lightblue")
})

test_that("hex_to_hsl handles vector inputs", {
  result <- col2hex2col:::hex_to_hsl(c("#FF0000", "#00FF00", "#0000FF"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(colnames(result), c("h", "s", "l", "alpha"))
})

test_that("hex_to_hsl handles achromatic colors", {
  white <- col2hex2col:::hex_to_hsl("#FFFFFF")
  black <- col2hex2col:::hex_to_hsl("#000000")
  gray <- col2hex2col:::hex_to_hsl("#808080")

  expect_equal(unname(white["s"]), 0)
  expect_equal(unname(white["h"]), 0)
  expect_equal(unname(black["s"]), 0)
  expect_equal(unname(black["h"]), 0)
  expect_equal(unname(gray["s"]), 0)
  expect_equal(unname(gray["h"]), 0)
})

test_that("hex_to_hsl parses alpha from 8-digit hex", {
  result <- col2hex2col:::hex_to_hsl("#FF000080")
  expect_equal(unname(result["alpha"]), 0.502)
})
