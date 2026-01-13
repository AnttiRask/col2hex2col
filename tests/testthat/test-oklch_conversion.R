test_that("hex_to_oklch returns expected values for red", {
  result <- col2hex2col:::hex_to_oklch("#FF0000")

  expect_equal(result$l, 0.6279554, tolerance = 1e-6)
  expect_equal(result$c, 0.2576833, tolerance = 1e-6)
  expect_equal(result$h, 29.2338812, tolerance = 1e-6)
  expect_equal(result$alpha, 1)
})

test_that("color_to_oklch returns expected values for red", {
  result <- col2hex2col:::color_to_oklch("red")

  expect_equal(result$l, 0.6279554, tolerance = 1e-6)
  expect_equal(result$c, 0.2576833, tolerance = 1e-6)
  expect_equal(result$h, 29.2338812, tolerance = 1e-6)
  expect_equal(result$alpha, 1)
})
