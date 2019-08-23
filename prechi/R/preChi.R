# Expects a list containing grade values and counts
# grades: vector of integer grade values, increasing
# counts: vector of integer counts
prechi.cluster_neighbors <- function(grades, counts, minimum_count = 5) {
  min_ct <- min(as.integer(0), as.integer(minimum_count))
  g <- as.numeric(grades)
  c <- as.integer(counts)
  gl <- length(g)
  cl <- length(c)
  if (gl != cl) {
    l <- min(gl, cl)
    warning("Unequal length arrays, only first ", l, " elements used")
    g <- g[0:l]
    c <- g[0:l]
  }

  .Call(pre_chi_cluster_neighbors, g, c, min_ct)
}
