# Count number of occurrences within the range of grade values
#   encompassed by the grades
# This is something like, table(), but includes zero counts and
#   also returns the range
# Returns a list with:
#   grades: non-NA, non-zero, positive grades,
#   range: all grade values in order, covering the range of grades
#   counts: number of occurrences of each grade value
jgd.gradeCounts <- function(grades) {
  g <- grades[0 < grades & !is.na(grades)]
  r <- seq(min(g), max(g), 5)
  fct <- function(X, g) {
    length(g[g==X])
  }
  ct <- sapply(r, fct, g)
  list(range=r, counts=ct, grades=g)
}
