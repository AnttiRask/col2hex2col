test_that("oklch_to_hex converts red correctly", {
  hex <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, 29.2338812)
  expect_equal(hex, "#FF0000")
})

test_that("oklch_to_color converts red correctly", {
  color <- col2hex2col:::oklch_to_color(0.6279554, 0.2576833, 29.2338812)
  expect_equal(color, "red")
})

test_that("oklch_to_hex supports vector recycling", {
  hex <- col2hex2col:::oklch_to_hex(0.7, 0.15, c(0, 90, 180, 270))
  expect_length(hex, 4)
})

test_that("oklch_to_hex wraps hue values", {
  hex1 <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, 29.2339)
  hex2 <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, 389.2339)
  hex3 <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, -330.7661)
  expect_equal(hex1, hex2)
  expect_equal(hex1, hex3)
})

test_that("oklch_to_hex supports alpha output", {
  hex <- col2hex2col:::oklch_to_hex(0.6279554, 0.2576833, 29.2339, 0.5)
  expect_equal(hex, "#FF000080")
})

test_that("oklch round-trip accuracy for common colors", {
  hexes <- c("#FF0000", "#00FF00", "#0000FF")
  round_trip <- col2hex2col:::hex_to_oklch(hexes) |> col2hex2col:::oklch_to_hex()
  expect_equal(round_trip, hexes)
})
