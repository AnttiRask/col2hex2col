test_that("hex_to_oklab returns expected values for red", {
  result <- col2hex2col:::hex_to_oklab("#FF0000")

  expect_named(result, c("L", "a", "b", "alpha"))
  expect_equal(unname(result["L"]), 0.6279554, tolerance = 1e-6)
  expect_equal(unname(result["a"]), 0.2248631, tolerance = 1e-6)
  expect_equal(unname(result["b"]), 0.1258463, tolerance = 1e-6)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("color_to_oklab returns expected values for red", {
  result <- col2hex2col:::color_to_oklab("red")

  expect_named(result, c("L", "a", "b", "alpha"))
  expect_equal(unname(result["L"]), 0.6279554, tolerance = 1e-6)
  expect_equal(unname(result["a"]), 0.2248631, tolerance = 1e-6)
  expect_equal(unname(result["b"]), 0.1258463, tolerance = 1e-6)
  expect_equal(unname(result["alpha"]), 1)
})
