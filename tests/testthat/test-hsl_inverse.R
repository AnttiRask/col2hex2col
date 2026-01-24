test_that("hsl_to_hex converts red correctly", {
  hex <- col2hex2col:::hsl_to_hex(0, 1, 0.5)
  expect_equal(hex, "#FF0000")
})

test_that("hsl_to_color converts red correctly", {
  color <- col2hex2col:::hsl_to_color(0, 1, 0.5)
  expect_equal(color, "red")
})

test_that("hsl_to_hex supports vector recycling", {
  hex <- col2hex2col:::hsl_to_hex(0, 1, c(0.25, 0.5))
  expect_length(hex, 2)
})

test_that("hsl_to_hex handles edge values", {
  expect_equal(col2hex2col:::hsl_to_hex(360, 1, 0.5), "#FF0000")
  expect_equal(col2hex2col:::hsl_to_hex(0, 0, 0), "#000000")
  expect_equal(col2hex2col:::hsl_to_hex(0, 0, 1), "#FFFFFF")
})

test_that("hsl_to_hex supports alpha output", {
  hex <- col2hex2col:::hsl_to_hex(0, 1, 0.5, 0.5)
  expect_equal(hex, "#FF000080")
})

test_that("hsl round-trip accuracy for common colors", {
  hexes <- c("#FF0000", "#00FF00", "#0000FF")
  round_trip <- col2hex2col:::hex_to_hsl(hexes) |> col2hex2col:::hsl_to_hex()
  expect_equal(round_trip, hexes)
})
