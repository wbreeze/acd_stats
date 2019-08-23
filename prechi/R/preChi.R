# Join neighboring clusters with fewer than minimim_count grades
# grades: vector of numeric grade values, increasing
# counts: vector of integer counts
# minimum_count: integer minimum size of a cluster, defaults to five
prechi.cluster_neighbors <- function(grades, counts, minimum_count = 5) {
  n <- as.integer(minimum_count)
  ln <- length(n)
  if (1 < ln) {
    warning("Prechi: ", ln,
      " elements given for minimum count, using the first")
    n <- n[1]
  }
  n_min <- as.integer(2)
  if (n < n_min) {
    warning("Prechi: minimum count of ", n, " increased to ", n_min)
    n <- n_min
  }
  g <- as.numeric(grades)
  c <- as.integer(counts)
  gl <- length(g)
  cl <- length(c)
  if (gl != cl) {
    l <- min(gl, cl)
    warning("Prechi: Unequal length arrays, only first ", l, " elements used")
    g <- g[0:l]
    c <- c[0:l]
  }

  .Call(pre_chi_cluster_neighbors, g, c, n)
}
