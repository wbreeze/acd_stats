# Expects a list containing grade values and counts
# grades: vector of integer grade values, increasing
# counts: vector of integer counts
PreChi <- function(grades_counts, minimum_count = 5) {
  prechi <- list()
  prechi$grades_counts <- grades_counts
  prechi$minimum_count <- minimum_count
  class(prechi) <- "PreChi"

  prechi$cluster_neighbors <- function() {
    str(prechi$grades_counts)
    .Call("pre_chi_cluster_neighbors", prechi$grades_counts$grades,
      prechi$grades_counts$counts, prechi$minimum_count)
  }

  return(prechi)
}
