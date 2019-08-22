library(prechi)
context("Cluster grades for Chi Squared")

test_that("computes clusters", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  grade_counts <- list(grades, counts)
  prechi <- PreChi(grade_counts)
  clustered <- prechi$cluster_neighbors()
  expect_false(is.null(clustered))
  str(clustered)
})
