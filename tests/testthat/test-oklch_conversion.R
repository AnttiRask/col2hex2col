test_that("hex_to_oklch returns expected values for red", {
  result <- col2hex2col:::hex_to_oklch("#FF0000")

  expect_named(result, c("l", "c", "h", "alpha"))
  expect_equal(unname(result["l"]), 0.628)
  expect_equal(unname(result["c"]), 0.2577)
  expect_equal(unname(result["h"]), 29.2339)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("color_to_oklch returns expected values for red", {
  result <- col2hex2col:::color_to_oklch("red")

  expect_named(result, c("l", "c", "h", "alpha"))
  expect_equal(unname(result["l"]), 0.628)
  expect_equal(unname(result["c"]), 0.2577)
  expect_equal(unname(result["h"]), 29.2339)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("oklch round-trips through hex and color names", {
  result <- color_to_hex("lightblue") |> col2hex2col:::hex_to_oklch() |> col2hex2col:::oklch_to_color()
  expect_equal(result, "lightblue")
})

test_that("hex_to_oklch handles vector inputs", {
  result <- col2hex2col:::hex_to_oklch(c("#FF0000", "#00FF00", "#0000FF"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(colnames(result), c("l", "c", "h", "alpha"))
})

test_that("hex_to_oklch sets hue to 0 for achromatic colors", {
  white <- col2hex2col:::hex_to_oklch("#FFFFFF")
  black <- col2hex2col:::hex_to_oklch("#000000")
  expect_equal(unname(white["c"]), 0)
  expect_equal(unname(white["h"]), 0)
  expect_equal(unname(black["c"]), 0)
  expect_equal(unname(black["h"]), 0)
})

test_that("hex_to_oklch parses alpha from 8-digit hex", {
  result <- col2hex2col:::hex_to_oklch("#FF000080")
  expect_equal(unname(result["alpha"]), 0.502)
})
