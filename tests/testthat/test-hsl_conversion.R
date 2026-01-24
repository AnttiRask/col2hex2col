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
