# Detailed Technical Issues in PRs

This document provides in-depth analysis of specific issues found during
code review.

------------------------------------------------------------------------

## Issue 1: Division by Zero in HSL Hue Calculation

**Location:** `R/hsl_conversion.R:89-94` (PR \#3)

**The Problem:**

``` r
hue_base[red_is_max] <- ((g[red_is_max] - b[red_is_max]) / delta[red_is_max]) %% 6
hue_base[green_is_max] <- ((b[green_is_max] - r[green_is_max]) / delta[green_is_max]) + 2
hue_base[blue_is_max] <- ((r[blue_is_max] - g[blue_is_max]) / delta[blue_is_max]) + 4

h <- (hue_base * 60) %% 360
h[delta == 0] <- 0  # Override AFTER division
```

For achromatic colors (white, black, grays), `delta = maxc - minc = 0`.
The division by `delta` creates `Inf` or `NaN` values, which are then
overwritten at line 94. While the final result is correct, this is
inefficient and could cause issues if R’s behavior changes.

**Recommended Fix:**

``` r
# Option 1: Guard before division
hue_base <- numeric(length(hex_std))
chromatic <- delta != 0

if (any(chromatic)) {
  hue_base[chromatic & red_is_max] <- ((g - b) / delta)[chromatic & red_is_max] %% 6
  # ... etc
}

# Option 2: Use ifelse
hue_base[red_is_max] <- ifelse(delta[red_is_max] == 0, 0,
                                ((g[red_is_max] - b[red_is_max]) / delta[red_is_max]) %% 6)
```

**Impact:** Low (final result is correct), but indicates code quality
issue.

------------------------------------------------------------------------

## Issue 2: Vector Recycling Not Supported

**Location:** All `*_to_hex()` functions in PRs \#2, \#3, \#4

**The Problem:**

``` r
# R users expect this to work:
hsl_to_hex(0, 1, c(0.25, 0.5, 0.75))  # 3 lightness values, single h and s
# Error: h, s, l, and alpha must have compatible lengths
```

Standard R convention is to recycle shorter vectors to match the
longest:

``` r
# Base R example:
paste0(c("a", "b", "c"), 1)  # Works: "a1" "b1" "c1"
```

**Current Validation (hsl_inverse.R:72-74):**

``` r
n <- length(h)
if (!(length(s) == n && length(l) == n && (length(alpha) == 1 || length(alpha) == n))) {
  stop("h, s, l, and alpha must have compatible lengths")
}
```

**Recommended Fix:**

``` r
n <- max(length(h), length(s), length(l))
h_vals <- rep_len(as.numeric(h), n)
s_vals <- rep_len(as.numeric(s), n)
l_vals <- rep_len(as.numeric(l), n)
alpha_vals <- rep_len(as.numeric(alpha), n)
```

**Impact:** Medium - affects usability but doesn’t cause incorrect
results.

------------------------------------------------------------------------

## Issue 3: Performance Issue in Fallback Function

**Location:** `R/fallback_nearest_hex.R:35-39` (PR \#5)

**The Problem:**

``` r
# Called EVERY time the function runs:
hex_lab <- farver::decode_colour(hex, to = "lab")           # O(m) - input
ref_lab <- farver::decode_colour(color_table$hex, to = "lab")  # O(32,462) - ALL colors!
```

For 32,462 colors converted on every call, this is extremely
inefficient.

**Benchmark:**

``` r
# Current: ~1.77ms per lookup (mostly spent converting reference colors)
# With pre-computed LAB: ~0.01ms per lookup (estimate)
```

**Recommended Fix:**

1.  Pre-compute LAB values when building the color table:

``` r
# In data-raw/prepare_color_data.R or similar:
color_data$lab_l <- farver::decode_colour(color_data$hex, to = "lab")[, 1]
color_data$lab_a <- farver::decode_colour(color_data$hex, to = "lab")[, 2]
color_data$lab_b <- farver::decode_colour(color_data$hex, to = "lab")[, 3]
```

2.  Or compute once and cache:

``` r
.lab_cache <- new.env(parent = emptyenv())

get_ref_lab <- function(color_table) {
  cache_key <- digest::digest(color_table$hex)
  if (!exists(cache_key, .lab_cache)) {
    .lab_cache[[cache_key]] <- farver::decode_colour(color_table$hex, to = "lab")
  }
  .lab_cache[[cache_key]]
}
```

**Impact:** High - 100x+ performance improvement possible.

------------------------------------------------------------------------

## Issue 4: White/Gray100 Discrepancy in Fallback

**Location:** `R/fallback_nearest_hex.R` (PR \#5)

**The Problem:**

``` r
hex_to_color("#FFFFFF")        # Returns "white" (exact match)
fallback_nearest_hex("#FFFFFF") # Returns "gray100" (nearest by LAB distance)
```

In LAB space, “gray100” (#FFFFFF) and “white” (#FFFFFF) should be
identical, but due to how the color database is structured, they may
have slightly different entries or the search finds “gray100” first.

**Root Cause:** The function doesn’t check for exact matches before
computing distances. If the hex code exists in the database, we should
return that name directly.

**Recommended Fix:**

``` r
fallback_nearest_hex <- function(hex, color_table = get_color_data()) {
  # ... validation ...

  # Check exact matches first
  hex_upper <- toupper(hex)
  exact_matches <- match(hex_upper, toupper(color_table$hex))

  result <- character(length(hex))
  has_exact <- !is.na(exact_matches)
  result[has_exact] <- color_table$name[exact_matches[has_exact]]

  # Only compute LAB distances for non-exact matches
  if (any(!has_exact)) {
    # ... existing LAB distance code for !has_exact indices ...
  }

  result
}
```

**Impact:** Medium - causes confusing results for users.

------------------------------------------------------------------------

## Issue 5: Floating Point Noise on Achromatic Colors

**Location:** All OKLAB/OKLCH functions (PRs \#2, \#4)

**The Problem:**

``` r
hex_to_oklab("#FFFFFF")
#         L            a            b     alpha
# 1.0000000 8.095286e-11 3.727391e-08 1.0000000

hex_to_oklch("#FFFFFF")
#          l           c          h     alpha
#  1.0000000 3.727400e-08 89.8755600 1.0000000
```

For white (and all grays), `a` and `b` should be exactly 0, and OKLCH
chroma should be 0. The tiny values (10^-8 to 10^-11) are floating point
noise from the matrix transformations.

**Why This Happens:** The transformation matrices have many decimal
places:

``` r
m2 <- matrix(c(
  0.2104542553, 0.7936177850, -0.0040720468,
  # ...
))
```

When multiplied, tiny rounding errors accumulate.

**Recommended Fix (Optional):**

``` r
# Round very small values to zero
threshold <- 1e-10
a[abs(a) < threshold] <- 0
b[abs(b) < threshold] <- 0
```

Or document the behavior:

``` r
#' @details
#' Note: Due to floating point precision, achromatic colors (white, black, grays)
#' may return very small non-zero values for a and b components (typically < 1e-8).
#' These are effectively zero for all practical purposes.
```

**Impact:** Low - cosmetic issue, doesn’t affect functionality.

------------------------------------------------------------------------

## Issue 6: OKLCH Hue for Achromatic Colors

**Location:** `R/oklch_conversion.R:112` (PR \#2)

**The Problem:**

``` r
h <- (atan2(b_vals, a) * 180 / pi) %% 360
```

For achromatic colors where `a ≈ 0` and `b ≈ 0`, `atan2(0, 0)` returns
0, but floating point noise means we get `atan2(3.7e-8, 8.1e-11)` which
gives `h ≈ 89.88°`.

This is mathematically valid (when chroma is 0, hue is undefined), but
confusing for users.

**Recommended Fix:**

``` r
c_val <- sqrt(a^2 + b_vals^2)
h <- (atan2(b_vals, a) * 180 / pi) %% 360
h[c_val < 1e-10] <- 0  # Undefined hue → set to 0
```

**Impact:** Low - cosmetic, but improves user experience.

------------------------------------------------------------------------

## Issue 7: README Conflicts with Main Branch

**Location:** `README.md` (PR \#6)

**The Problem:** PR \#6 was based on pre-CRAN code and makes these
conflicting changes:

| Change          | PR \#6                    | Current Main           |
|-----------------|---------------------------|------------------------|
| CRAN install    | Removed                   | Present                |
| Downloads badge | Removed                   | Present                |
| Logo path       | `img/hex-col2hex2col.png` | `man/figures/logo.png` |

**Recommended Fix:**

``` bash
git checkout readme
git fetch origin
git rebase origin/main
# Resolve conflicts, keeping main branch's CRAN changes
git push --force-with-lease
```

**Impact:** High - will cause merge conflicts and lose CRAN
documentation.

------------------------------------------------------------------------

## Issue 8: Informal Comments in Production Code

**Location:** `R/fallback_nearest_hex.R:25` (PR \#5)

**The Problem:**

``` r
# i mean, ill leave it. but this is kinda verbose...
if (!is.data.frame(color_table) || !all(c("name", "hex") %in% names(color_table))) {
```

This comment indicates uncertainty about code quality and is not
appropriate for production.

**Recommended Fix:** Either remove the comment or refactor the
validation:

``` r
# Validate color_table structure
stopifnot(
  is.data.frame(color_table),
  c("name", "hex") %in% names(color_table)
)
```

**Impact:** Low - code quality/professionalism issue.

------------------------------------------------------------------------

## Summary: Priority Matrix

| Issue                         | Severity | Effort | Priority |
|-------------------------------|----------|--------|----------|
| \#3 Performance (fallback)    | High     | Medium | **P1**   |
| \#7 README conflicts          | High     | Low    | **P1**   |
| \#4 White/gray100 discrepancy | Medium   | Low    | **P2**   |
| \#2 Vector recycling          | Medium   | Medium | **P2**   |
| \#1 Division by zero          | Low      | Low    | **P3**   |
| \#5 Floating point noise      | Low      | Low    | **P3**   |
| \#6 OKLCH achromatic hue      | Low      | Low    | **P3**   |
| \#8 Informal comments         | Low      | Low    | **P3**   |

------------------------------------------------------------------------

*Generated from code review on 2026-01-24*
