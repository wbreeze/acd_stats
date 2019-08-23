library(prechi)
context("Cluster grades for Chi Squared")

test_that("computes clusters", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  clustered <- prechi.cluster_neighbors(grades, counts)
  expect_false(is.null(clustered))
  expect_type(clustered, "list")
  expect_named(clustered, c("count", "boundaries", "counts",
    "target_mean", "target_variance", "solution_mean", "solution_variance"))
  expect_length(clustered$count, 1)
  expect_equal(4, clustered$count)
  expect_length(clustered$counts, 4)
  expect_equal(c(7, 8, 12, 14), clustered$counts)
  expect_length(clustered$boundaries, 5)
  expect_equal(-Inf, clustered$boundaries[1])
  expect_gt(clustered$boundaries[2], 65)
  expect_lt(clustered$boundaries[2], 70)
  expect_gt(clustered$boundaries[3], 70)
  expect_lt(clustered$boundaries[3], 75)
  expect_gt(clustered$boundaries[4], 75)
  expect_lt(clustered$boundaries[4], 80)
  expect_equal(Inf, clustered$boundaries[5])
})

test_that("computes parameters for normal distribution", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10)
  clustered <- prechi.cluster_neighbors(grades, counts)
  expect_false(is.null(clustered))
  expect_equal(7284, round(clustered$target_mean * 100))
  expect_equal(4262, round(clustered$target_variance * 100))
  expect_equal(7243, round(clustered$solution_mean * 100))
  expect_equal(4814, round(clustered$solution_variance * 100))
})

test_that("too few grades", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: Unequal length arrays")
})

test_that("too few counts", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: Unequal length arrays")
  expect_false(is.null(clustered))
})

test_that("grades and counts the same", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  clustered <- prechi.cluster_neighbors(grades, grades)
  expect_false(is.null(clustered))
  expect_equal(grades, clustered$counts)
})

test_that("minimum too low", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 2,  0,  5,  8, 12, 10)
  expect_warning(clustered <- prechi.cluster_neighbors(grades, counts, 1),
    "Prechi: minimum count of 1 increased")
  expect_false(is.null(clustered))
})

test_that("more than one minimum", {
  grades <- c(55, 60, 65, 70, 75, 80, 85)
  counts <- c( 2,  0,  5,  8, 12, 10,  4)
  minimum_count <- c(5, 0, 0)
  expect_warning(
    clustered <- prechi.cluster_neighbors(grades, counts, minimum_count),
    "Prechi: 3 elements given for minimum count")
  expect_false(is.null(clustered))
})

test_that("no solution", {
  grades <- c(55, 60, 65, 70, 75, 80)
  counts <- c( 5,  1,  1,  1,  1,  5)
  minimum_count <- c(5)
  expect_error(
    clustered <- prechi.cluster_neighbors(grades, counts, minimum_count),
    "Prechi: there is no solution with three or more parts")
})

test_that("too few parts", {
  grades <- c(55, 60)
  counts <- c( 7,  5)
  expect_error(
    clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: fewer than three parts provided")
})

test_that("zero parts", {
  grades <- c()
  counts <- c()
  expect_error(
    clustered <- prechi.cluster_neighbors(grades, counts),
    "Prechi: fewer than three parts provided")
})
