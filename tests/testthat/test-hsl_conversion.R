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
