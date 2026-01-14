test_that("oklab_to_hex converts red correctly", {
  hex <- col2hex2col:::oklab_to_hex(0.6279554, 0.2248631, 0.1258463)
  expect_equal(hex, "#FF0000")
})

test_that("oklab_to_color converts red correctly", {
  color <- col2hex2col:::oklab_to_color(0.6279554, 0.2248631, 0.1258463)
  expect_equal(color, "red")
})
