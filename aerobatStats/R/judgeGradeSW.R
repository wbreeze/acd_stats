# Shapiro-Wilk probability of fit of collection of judge grades to normal
# Return a list with the following:
#   p.value: Shapiro-Wilk p-value against normal derived from unclustered data
#   valid: whether the test was valid, true or false
#   reason: message if not valid, else "Okay"
# We mark the test invalid if the shapiro.test function produces a warning
# Do not confuse valid with significant. The p-value determines significance.
#   Of course, not valid means you can't reject, and that the p-value
#   is meaningless
jgd.shapiro <- function(gradeCounts) {
  rv <- list(valid=T, reason="Okay", p.value=NA)
  set_invalid_warn <- function(w) {
    rv$valid <<- F
    rv$reason <<- w$message
    invokeRestart("muffleWarning")
  }
  set_invalid_error <- function(e) {
    rv$valid <<- F
    rv$reason <<- e$message
  }
  grades <- jgd.distributeGrades(gradeCounts)
  rv$p.value <- withCallingHandlers(
    tryCatch(shapiro.test(grades)$p.value,
      error=set_invalid_error),
    warning = set_invalid_warn
  )
  rv
}
