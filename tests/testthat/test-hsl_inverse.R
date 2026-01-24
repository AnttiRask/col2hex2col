test_that("hsl_to_hex converts red correctly", {
  hex <- col2hex2col:::hsl_to_hex(0, 1, 0.5)
  expect_equal(hex, "#FF0000")
})

test_that("hsl_to_color converts red correctly", {
  color <- col2hex2col:::hsl_to_color(0, 1, 0.5)
  expect_equal(color, "red")
})
