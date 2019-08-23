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
  part_ct <- min(gl, cl)
  if (gl != cl) {
    warning("Prechi: Unequal length arrays, only first ", l, " elements used")
    g <- g[0:part_ct]
    c <- c[0:part_ct]
  }

  if (part_ct < 3) {
    stop("Prechi: fewer than three parts provided")
  }
  clustered <- .Call(pre_chi_cluster_neighbors, g, c, n)
  if (clustered$count < 3) {
    stop("Prechi: there is no solution with three or more parts")
  }
  clustered
}
