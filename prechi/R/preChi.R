# Join neighboring clusters with fewer than minimim_count grades
# grades: vector of numeric grade values, increasing
# counts: vector of integer counts
# minimum_count: integer minimum size of a cluster, defaults to five
# timout:  a timeout in seconds. Sending zero will result in a
#   one hour timeout. The algorithm returns the current result at the
#   timeout, or the first result found after the timeout.
prechi.cluster_neighbors <- function(grades, counts,
  minimum_count = 5, timeout = 0, minimum_partition_count = 3)
{
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
    warning("Prechi: Unequal length arrays, only first ", part_ct,
      " elements used")
    g <- g[0:part_ct]
    c <- c[0:part_ct]
  }
  maxt <- as.integer(timeout)
  min_parts <- max(as.integer(3), as.integer(minimum_partition_count))

  if (part_ct < min_parts) {
    stop("Prechi: fewer than ", min_parts, " parts provided")
  }
  clustered <- .Call(pre_chi_cluster_neighbors, g, c, n, maxt, min_parts)
  if (clustered$count < min_parts) {
    stop("Prechi: there is no solution with ", min_parts, " or more parts")
  }
  clustered
}
