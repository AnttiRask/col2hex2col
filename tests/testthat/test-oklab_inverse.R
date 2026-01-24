test_that("oklab_to_hex converts red correctly", {
  hex <- col2hex2col:::oklab_to_hex(0.6279554, 0.2248631, 0.1258463)
  expect_equal(hex, "#FF0000")
})

test_that("oklab_to_color converts red correctly", {
  color <- col2hex2col:::oklab_to_color(0.6279554, 0.2248631, 0.1258463)
  expect_equal(color, "red")
})

test_that("oklab_to_hex supports vector recycling", {
  hex <- col2hex2col:::oklab_to_hex(0.7, 0.15, c(0, 0.1, 0.2))
  expect_length(hex, 3)
})

test_that("oklab_to_hex supports alpha output", {
  hex <- col2hex2col:::oklab_to_hex(0.6279554, 0.2248631, 0.1258463, 0.5)
  expect_equal(hex, "#FF000080")
})

test_that("oklab_to_hex clamps out-of-gamut values", {
  hex <- col2hex2col:::oklab_to_hex(1.5, 2, -2)
  expect_match(hex, "^#[0-9A-F]{6}$")
})

test_that("oklab round-trip accuracy for common colors", {
  hexes <- c("#FF0000", "#00FF00", "#0000FF")
  round_trip <- col2hex2col:::hex_to_oklab(hexes) |> col2hex2col:::oklab_to_hex()
  expect_equal(round_trip, hexes)
})
