library(prechi)
context("Cluster grades for Chi Squared")

test_that("computes clusters", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  clustered <- prechi.cluster_neighbors(grades, counts)
  expect_false(is.null(clustered))
  str(clustered)
})

test_that("too few grades", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  clustered <- prechi.cluster_neighbors(grades, counts)
  expect_false(is.null(clustered))
  str(clustered)
})

test_that("too few counts", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10)
  clustered <- prechi.cluster_neighbors(grades, counts)
  expect_false(is.null(clustered))
  str(clustered)
})
