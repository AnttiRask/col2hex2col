test_that("hex_to_oklab returns expected values for red", {
  result <- col2hex2col:::hex_to_oklab("#FF0000")

  expect_named(result, c("L", "a", "b", "alpha"))
  expect_equal(unname(result["L"]), 0.628)
  expect_equal(unname(result["a"]), 0.2249)
  expect_equal(unname(result["b"]), 0.1258)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("color_to_oklab returns expected values for red", {
  result <- col2hex2col:::color_to_oklab("red")

  expect_named(result, c("L", "a", "b", "alpha"))
  expect_equal(unname(result["L"]), 0.628)
  expect_equal(unname(result["a"]), 0.2249)
  expect_equal(unname(result["b"]), 0.1258)
  expect_equal(unname(result["alpha"]), 1)
})

test_that("oklab round-trips through hex and color names", {
  result <- color_to_hex("red3") |> col2hex2col:::hex_to_oklab() |> col2hex2col:::oklab_to_color()
  expect_equal(result, "red3")
})

test_that("hex_to_oklab handles vector inputs", {
  result <- col2hex2col:::hex_to_oklab(c("#FF0000", "#00FF00", "#0000FF"))
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(colnames(result), c("L", "a", "b", "alpha"))
})

test_that("hex_to_oklab handles achromatic colors", {
  white <- col2hex2col:::hex_to_oklab("#FFFFFF")
  black <- col2hex2col:::hex_to_oklab("#000000")
  gray <- col2hex2col:::hex_to_oklab("#808080")

  expect_equal(unname(white["a"]), 0)
  expect_equal(unname(white["b"]), 0)
  expect_equal(unname(black["a"]), 0)
  expect_equal(unname(black["b"]), 0)
  expect_equal(unname(gray["a"]), 0)
  expect_equal(unname(gray["b"]), 0)
})

test_that("hex_to_oklab parses alpha from 8-digit hex", {
  result <- col2hex2col:::hex_to_oklab("#FF000080")
  expect_equal(unname(result["alpha"]), 0.502)
})
