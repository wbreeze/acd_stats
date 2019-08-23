library(prechi)
context("Cluster grades for Chi Squared")

test_that("computes clusters", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  clustered <- prechi.cluster_neighbors(grades, counts)
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("too few grades", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: Unequal length arrays")
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("too few counts", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: Unequal length arrays")
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("grades and counts the same", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  clustered <- prechi.cluster_neighbors(grades, grades)
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("minimum too low", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts, 1),
    "Prechi: minimum count of 1 increased")
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("more than one minimum", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  minimum_count <- c(5, 0, 0)
  expect_warning(
    clustered <- prechi.cluster_neighbors(grades, counts, minimum_count),
    "Prechi: 3 elements given for minimum count")
  str(clustered)
  expect_false(is.null(clustered))
})

test_that("too few parts", {
  grades <- c()
  counts <- c()
  clustered <- prechi.cluster_neighbors(grades, grades)
  str(clustered)
  expect_false(is.null(clustered))
})
