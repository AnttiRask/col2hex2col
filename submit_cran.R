#!/usr/bin/env Rscript
# Simple CRAN Submission Script for col2hex2col

cat("\n===== col2hex2col CRAN Submission =====\n\n")

# Check if we're in the right directory
if (!file.exists("DESCRIPTION")) {
  stop("Please run this script from the package root directory")
}

# Final check
cat("Running final R CMD check...\n")
check_result <- rcmdcheck::rcmdcheck(args = c("--as-cran", "--no-manual"))

if (length(check_result$errors) > 0) {
  cat("\n❌ Errors found:\n")
  print(check_result$errors)
  stop("Fix errors before submitting to CRAN")
}

if (length(check_result$warnings) > 0) {
  cat("\n⚠️  Warnings found:\n")
  print(check_result$warnings)
  stop("Fix warnings before submitting to CRAN")
}

cat("\n✅ Package passes R CMD check!\n")
cat("   Errors:", length(check_result$errors), "\n")
cat("   Warnings:", length(check_result$warnings), "\n")
cat("   Notes:", length(check_result$notes), "\n\n")

# Show package info
desc <- read.dcf("DESCRIPTION")
pkg_name <- desc[1, "Package"]
pkg_version <- desc[1, "Version"]
maintainer_email <- sub(".*<(.*)>.*", "\\1", desc[1, "Authors@R"])

cat("Package Information:\n")
cat("  Name:", pkg_name, "\n")
cat("  Version:", pkg_version, "\n")
cat("  Maintainer: Check your email at", maintainer_email, "\n\n")

# Confirmation
cat("⚠️  IMPORTANT REMINDERS:\n")
cat("1. You will receive a confirmation email\n")
cat("2. You MUST click the link within 24 hours\n")
cat("3. CRAN typically responds in 2-10 days\n")
cat("4. First submissions get extra scrutiny\n\n")

cat("Ready to submit to CRAN? (yes/no): ")
answer <- tolower(trimws(readLines("stdin", n = 1)))

if (answer == "yes" || answer == "y") {
  cat("\n📤 Submitting to CRAN...\n\n")

  # Submit using rhub which handles the submission properly
  tryCatch({
    devtools::submit_cran()
    cat("\n✅ Submission successful!\n")
    cat("\n📧 CHECK YOUR EMAIL NOW!\n")
    cat("Look for an email from CRAN asking you to confirm.\n")
    cat("Click the confirmation link within 24 hours.\n\n")
  }, error = function(e) {
    cat("\n❌ Submission failed:", conditionMessage(e), "\n\n")
    cat("Manual submission instructions:\n")
    cat("1. Build the package: devtools::build()\n")
    cat("2. Go to: https://cran.r-project.org/submit.html\n")
    cat("3. Upload the .tar.gz file\n")
    cat("4. Paste the contents of cran-comments.md\n")
  })
} else {
  cat("\n❌ Submission cancelled.\n\n")
  cat("To submit manually:\n")
  cat("1. Go to: https://cran.r-project.org/submit.html\n")
  cat("2. Upload: ../col2hex2col_0.1.2.tar.gz\n")
  cat("3. Paste cran-comments.md content in the form\n")
}
