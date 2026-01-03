# Color Database Maintenance

This directory contains the scripts and data for maintaining the extended color database.

## Files

- `colornames.csv`: The color-names database (downloaded from https://unpkg.com/color-name-list/dist/colornames.csv)
- `prepare_colornames.R`: Script to build the internal package data from the CSV

## Updating the Color Database

### Manual Update

Run this when you want to update to the latest color-names database:

```r
# 1. Download latest colors
download.file(
  "https://unpkg.com/color-name-list/dist/colornames.csv",
  "data-raw/colornames.csv"
)

# 2. Rebuild the internal data
source("data-raw/prepare_colornames.R")

# 3. Test the package
devtools::test()
devtools::check()

# 4. If all tests pass, commit the changes
# git add data-raw/colornames.csv R/sysdata.rda
# git commit -m "Update color database to latest version"
```

### Automated Updates

The package includes a GitHub Actions workflow (`.github/workflows/update-colors.yaml`) that:
- Runs monthly (1st of each month)
- Checks if the color-names database has been updated
- Creates a PR if new colors are available
- Can be manually triggered from the Actions tab

## Database Information

**Source**: [color-names](https://github.com/meodai/color-names) by meodai
**License**: MIT
**Current size**: 31,852 colors (as of v0.2.0)
**Update frequency**: The upstream database is updated occasionally when new colors are added

## Version History

- **v0.2.0** (2025-01-04): Initial extended database with 31,852 colors
