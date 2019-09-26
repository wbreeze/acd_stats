# Use a random normal distribution to make the grades have unique values
# The standard deviation used for the normal distribution is 1/sqrt(12n)
#   where n is the number of occurrences of a given grade
# counts: may be obtained from the grades by jgd.gradeCounts
#   Its value is list(range=r, counts=ct, grades=g)
# Returns a list of grades, all unique
jgd.distributeGrades <- function(counts) {
  c(map2(counts$range, counts$counts, jgd.distributeVCt), recursive=TRUE)
}

jgd.distributeVCt <- function(value, count) {
  if (0 < count) {
    values <- rep(value, count)
    sigma <- sqrt(5 / (count * 12))
    values + rnorm(count, 0, sigma)
  } else c()
}
