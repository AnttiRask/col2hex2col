# CRAN Submission Script for col2hex2col
# Run this script to submit your package to CRAN

cat("===== col2hex2col CRAN Submission =====\n\n")

# Step 1: Final check
cat("Step 1: Running final CRAN checks...\n")
check_results <- devtools::check(cran = TRUE, manual = FALSE)

if (length(check_results$errors) > 0) {
  stop("❌ Package has ERRORS. Fix them before submitting.")
}

if (length(check_results$warnings) > 0) {
  stop("❌ Package has WARNINGS. Fix them before submitting.")
}

cat("✅ Package passes all checks!\n\n")

# Step 2: Build package
cat("Step 2: Building package...\n")
pkg_file <- devtools::build()
cat("✅ Package built:", pkg_file, "\n\n")

# Step 3: Review submission details
cat("Step 3: Review submission details:\n")
cat("  Package: col2hex2col\n")
cat("  Version: 0.1.2\n")
cat("  Maintainer: Antti Rask <anttilennartrask@gmail.com>\n")
cat("  Built file:", pkg_file, "\n\n")

# Step 4: Submit
cat("Step 4: Submit to CRAN\n")
cat("\nReady to submit to CRAN?\n")
cat("This will upload your package to CRAN's submission system.\n")
cat("You will receive a confirmation email that you MUST click within 24 hours.\n\n")

response <- readline(prompt = "Type 'YES' to submit, or anything else to cancel: ")

if (toupper(response) == "YES") {
  cat("\n📤 Submitting to CRAN...\n")
  devtools::submit_cran(pkg = pkg_file)
  cat("\n✅ Submission complete!\n")
  cat("\n📧 Check your email (anttilennartrask@gmail.com) for confirmation link.\n")
  cat("⏰ You MUST click the confirmation link within 24 hours.\n")
  cat("\n🎉 Good luck! CRAN typically responds within 2-10 days.\n")
} else {
  cat("\n❌ Submission cancelled.\n")
  cat("\nTo submit manually:\n")
  cat("1. Go to: https://cran.r-project.org/submit.html\n")
  cat("2. Upload:", pkg_file, "\n")
  cat("3. Include cran-comments.md content in the comments box\n")
}
