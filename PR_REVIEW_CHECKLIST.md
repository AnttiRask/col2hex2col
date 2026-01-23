# PR Review Checklist for @iamYannC

Thank you for your contributions to col2hex2col! Below is a checklist of items to address before the PRs can be merged.

---

## PR #3: HSL Conversion (branch: `hsl`)

**Status: ⚠️ Needs Minor Fixes**

### Required Changes
- [ ] Fix division-by-zero handling in `hsl_conversion.R:89-91`
  - Guard against `delta == 0` before division, not after
- [ ] Add tests for vector inputs (`hex_to_hsl(c("#FF0000", "#00FF00"))`)
- [ ] Add tests for achromatic colors (`#FFFFFF`, `#000000`, `#808080`)
- [ ] Add tests for edge values (h=360, s=0, l=0, l=1)
- [ ] Add tests for 8-digit hex with alpha channel
- [ ] Run `devtools::document()` to update NAMESPACE

### Optional Improvements
- [ ] Support vector recycling in `hsl_to_hex()`
- [ ] Document validation behavior (reject vs clamp)

---

## PR #4: OKLAB Conversion (branch: `oklab`)

**Status: ⚠️ Needs Tests**

### Required Changes
- [ ] Add tests for vector inputs (`hex_to_oklab(c("#FF0000", "#00FF00"))`)
- [ ] Add tests for achromatic colors (verify floating point behavior)
- [ ] Add tests for out-of-gamut values
- [ ] Add tests for 8-digit hex with alpha channel
- [ ] Run `devtools::document()` to update NAMESPACE

### Optional Improvements
- [ ] Document floating point noise on achromatic colors
- [ ] Add guidance on OKLAB vs OKLCH usage

---

## PR #2: OKLCH Conversion (branch: `oklch`)

**Status: ⚠️ Needs Tests + Fix**

### Required Changes
- [ ] Fix vector recycling or document limitation
  - Currently: `oklch_to_hex(0.7, 0.15, c(0, 90, 180, 270))` errors
- [ ] Add tests for vector inputs
- [ ] Add tests for achromatic colors
- [ ] Add tests for hue wrapping (h > 360, negative h)
- [ ] Add tests for 8-digit hex with alpha channel
- [ ] Run `devtools::document()` to update NAMESPACE

### Optional Improvements
- [ ] Set hue to 0 when chroma < threshold (for achromatic colors)
- [ ] Ensure consistency with OKLAB PR structure

---

## PR #5: Nearest Color Fallback (branch: `color-name-fallback`)

**Status: ❌ Not Ready - Multiple TODOs**

### Required Changes (Critical)
- [ ] Add `farver` to DESCRIPTION under `Suggests:`
- [ ] Pre-compute LAB values in color table (performance fix)
- [ ] Check for exact match before computing distances (white/gray100 issue)
- [ ] Add formal testthat tests
- [ ] Add roxygen documentation (@param, @return, @export, @examples)
- [ ] Remove informal comments ("i mean, ill leave it...")

### Required Changes (Before Merge)
- [ ] Complete or remove TODO list from file header
- [ ] Decide on integration strategy with `hex_to_color()`

### Optional Improvements
- [ ] Support alternative distance metrics (ΔE2000)
- [ ] Option to limit to R color names only

---

## PR #6: README Updates (branch: `readme`)

**Status: ⚠️ Needs Rebase**

### Required Changes
- [ ] **Rebase on current main branch** (critical - restores CRAN instructions)
- [ ] Fix roundtrip example output: `"black" "white"` → `"white" "black"`
- [ ] Add space before MDN links (lines 88, 98)
- [ ] Capitalize "basically" (line 98)

### Optional Improvements
- [ ] Remove emojis for terminal compatibility
- [ ] Soften marketing language ("rising star" → "increasingly popular")

---

## Cross-PR Consistency Items

### Standardize Across All Color Space PRs
- [ ] Consistent validation strategy (reject vs clamp out-of-range values)
- [ ] Consistent return type documentation (named vector vs data frame)
- [ ] Consistent vector recycling behavior
- [ ] Similar test coverage depth

### Documentation
- [ ] All exported functions have complete roxygen docs
- [ ] All PRs run `devtools::document()` before final commit

---

## Merge Order Recommendation

1. **PR #3 (HSL)** - Most complete, fewest issues
2. **PR #4 (OKLAB)** - Foundation for OKLCH
3. **PR #2 (OKLCH)** - Depends on OKLAB concepts
4. **PR #6 (README)** - After color spaces merged, rebase on main
5. **PR #5 (Fallback)** - Mark as draft until TODOs complete

---

## Questions for Contributor

1. Should out-of-range values be rejected with an error or clamped silently?
2. Should vector recycling be supported in `*_to_hex()` functions?
3. For PR #5: Is this ready for review or should it be marked as draft?
4. For achromatic colors in OKLCH: Should hue be set to 0 or left as computed?

---

*Generated from code review on 2026-01-24*
