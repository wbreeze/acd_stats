context("Judge grade Shapiro-Wilk test")

describe("Shapiro Wilk test on grade distribution", {
  test_that("provides shapiro fit to normal failure", {
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(20, 18, 12, 8, 5, 8, 12, 18, 20))
    csr <- jgd.shapiro(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_lt(csr$p.value, 0.05)
  })

  test_that("provides shapiro fit to normal success", {
    gvs <- seq(55, 95, 5)
    counts <- c(1, 1, 2, 3, 7, 9, 7, 3, 1)
    grades <- rep(gvs, counts)
    csr <- jgd.shapiro(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$p.value, 0.05)
  })

  test_that("provides shapiro fit to normal with presence of NA", {
    gvs <- c(seq(55, 95, 5), NA)
    counts <- c(1, 1, 2, 3, 7, 9, 7, 3, 2, 1)
    grades <- rep(gvs, counts)
    csr <- jgd.shapiro(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$p.value, 0.05)
  })
})
