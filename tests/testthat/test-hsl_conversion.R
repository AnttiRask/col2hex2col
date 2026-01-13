test_that("hex_to_hsl returns expected values for red", {
  result <- col2hex2col:::hex_to_hsl("#FF0000")

  expect_equal(result$h, 0)
  expect_equal(result$s, 1)
  expect_equal(result$l, 0.5)
  expect_equal(result$alpha, 1)
})

test_that("color_to_hsl returns expected values for red", {
  result <- col2hex2col:::color_to_hsl("red")

  expect_equal(result$h, 0)
  expect_equal(result$s, 1)
  expect_equal(result$l, 0.5)
  expect_equal(result$alpha, 1)
})
