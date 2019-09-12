require('prechi')

# Chi-square probability of fit of collection of judge grades to normal
# Return a list with the following:
#   pu: ChiSq p-value against normal derived from unclustered data
#   pc: ChiSq p-value against normal derived from clustered data
#   df: Degrees of freedom
#   valid: whether the test was valid, true or false
# The test is not valid if the grade clustering produces fewer than four
#   intervals, or if there are fewer than four different grades given
#   to begin with. A judge who limits themselves to grades from
#   7.0 to 8.0, or to 6.0, 7.5, and 9.0 defeats this test.
# We also mark the test invalid if the chisq.test function produces a warning
# Do not confuse valid with significant. The p-values determine significance.
#   Of course, not valid means you can't reject, and that the p-values
#   are meaningless
jgd.chiSqP <- function(gradeCounts) {
  rv <- list(valid=T, df=NaN, pu=NaN, pc=NaN)
  set_invalid_warn <- function(w) {
    rv$valid <<- F
    invokeRestart("muffleWarning")
  }
  set_invalid_error <- function(w) {
    rv$valid <<- F
  }
  clust <- tryCatch(prechi.cluster_neighbors(gradeCounts$range, gradeCounts$counts),
      error=set_invalid_error, warning = set_invalid_error)
  if (rv$valid) {
    rv$df <- clust$count - 3
    dist <- diff(pnorm(clust$boundaries, clust$target_mean,
      sqrt(clust$target_variance)))
    rv$pu <- withCallingHandlers(
      tryCatch(chisq.test(clust$counts, p=dist)$p.value,
        error=set_invalid_error),
      warning = set_invalid_warn
    )
    dist <- diff(pnorm(clust$boundaries, clust$solution_mean,
      sqrt(clust$solution_variance)))
    rv$pc <- withCallingHandlers(
      tryCatch(chisq.test(clust$counts, p=dist)$p.value,
        error=set_invalid_error),
      warning = set_invalid_warn
    )
  }
  rv
}