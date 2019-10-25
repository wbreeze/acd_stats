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
  clust_fn <- sed.catchToList(prechi.cluster_neighbors, "PreChi")
  clust <- clust_fn(gradeCounts$range, gradeCounts$counts,
    minimum_count = 6, timeout = 5, minimum_partition_count = 6)
  rv <- list(
    valid=FALSE,
    reason=clust$errors,
    df=NA,
    target_mean=NA,
    target_variance=NA,
    solution_mean=NA,
    solution_variance=NA,
    pu=NA,
    pc=NA)
  if (clust$success) {
    cres <- clust$data
    rv$df <- cres$count - 3
    rv$target_mean <- cres$target_mean
    rv$target_variance <- cres$target_variance
    rv$solution_mean <- cres$solution_mean
    rv$solution_variance <- cres$solution_variance
    dist <- diff(pnorm(cres$boundaries, cres$target_mean,
      sqrt(cres$target_variance)))
    pu_fit_fn <- sed.catchToList(chisq.test, "ChiSq TgtDistParms")
    pu_fit <- pu_fit_fn(cres$counts, p=dist)
    if (pu_fit$success) {
      rv$pu <- pu_fit$data$p.value
    }
    dist <- diff(pnorm(cres$boundaries, cres$solution_mean,
      sqrt(cres$solution_variance)))
    pc_fit_fn <- sed.catchToList(chisq.test, "ChiSq ClustDistParms")
    pc_fit <- pc_fit_fn(cres$counts, p=dist)
    if (pc_fit$success) {
      rv$pc <- pc_fit$data$p.value
    }
    rv$valid <- pu_fit$success && pc_fit$success
    if(!rv$valid) {
      rv$reason <- c(pu_fit$errors, pc_fit$errors)
    }
  }
  rv
}
