test_that("oklch_to_hex converts red correctly", {
  hex <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, 29.2338812)
  expect_equal(hex, "#FF0000")
})

test_that("oklch_to_color converts red correctly", {
  color <- col2hex2col:::oklch_to_color(0.6279554, 0.2576833, 29.2338812)
  expect_equal(color, "red")
})
