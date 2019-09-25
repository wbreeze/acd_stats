require('prechi')

# Chi-square probability of fit of collection of judge grades to normal
# Return a list with the following:
#   pu: ChiSq p-value against normal derived from unclustered data
#   pc: ChiSq p-value against normal derived from clustered data
#   df: Degrees of freedom
#   target_mean: mean of count data
#   target_variance: variance of count data
#   solution_mean: mean of clustered count data
#   solution_variance: variance of clustered count data
#   valid: whether the test was valid, true or false
#   reason: message if not valid, else "Okay"
# The test is not valid if the grade clustering produces fewer than six
#   intervals, or if there are fewer than six different grades given
#   to begin with. A judge who limits themselves to grades from
#   7.0 to 8.0, or to 6.0, 7.5, and 9.0 defeats this test.
# We also mark the test invalid if the chisq.test function produces a warning
# Do not confuse valid with significant. The p-values determine significance.
#   Of course, not valid means you can't reject, and that the p-values
#   are meaningless
jgd.chiSqP <- function(gradeCounts) {
  rv <- list(valid=T, reason="Okay", df=NA, pu=NA, pc=NA,
    target_mean=NA, target_variance=NA,
    solution_mean=NA, solution_variance=NA)
  set_invalid_warn <- function(w) {
    rv$valid <<- F
    rv$reason <<- w$message
    invokeRestart("muffleWarning")
  }
  set_invalid_error <- function(e) {
    rv$valid <<- F
    rv$reason <<- e$message
  }
  clust <- tryCatch(
      prechi.cluster_neighbors(gradeCounts$range, gradeCounts$counts,
        minimum_count = 6, timeout = 5, minimum_partition_count = 6),
      error=set_invalid_error, warning = set_invalid_error)
  if (rv$valid) {
    rv$df <- clust$count - 3
    rv$target_mean <- clust$target_mean
    rv$target_variance <- clust$target_variance
    rv$solution_mean <- clust$solution_mean
    rv$solution_variance <- clust$solution_variance
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
