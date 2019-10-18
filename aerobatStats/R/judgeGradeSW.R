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
  grades <- jgd.distributeGrades(gradeCounts)
  #qqnorm(grades); qqline(grades)
  sw <- sed.catchToList(shapiro.test, "Shapiro test")
  sw(grades)
}
