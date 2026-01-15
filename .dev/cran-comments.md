## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release (first submission to CRAN).

## Resubmission

This is a resubmission. In the previous versions I have addressed the following:

* Fixed the LICENSE file format to use the template format (YEAR/COPYRIGHT HOLDER) instead of the full license text, which resolved the "License stub is invalid DCF" NOTE.

* Replaced \dontrun{} with conditional examples using requireNamespace("gt", quietly = TRUE) in the create_color_table() documentation, as requested by the CRAN team. The examples now run when gt is available but don't fail when it's not installed.

## Test environments

* local Linux Mint 22.2, R 4.5.2
* GitHub Actions (ubuntu-latest): devel, release, oldrel-1
* GitHub Actions (windows-latest): release
* GitHub Actions (macos-latest): release

All tests pass on all platforms.

## Reverse dependencies

There are currently no reverse dependencies for this package.
