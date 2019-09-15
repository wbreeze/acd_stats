context("Judge grade ChiSq test")

describe("ChiSq test on grade distribution", {
  test_that("returns not valid when only four grade values", {
    grades <- rep(c(55, 65, 80, 85), 5)
    csr <- jgd.chiSqP(jgd.gradeCounts(grades))
    expect_false(csr$valid)
  })

  test_that("returns not valid when prechi.cluster fails", {
    grades <- rep(c(55, 65, 80, 85, 90), 3)
    csr <- jgd.chiSqP(jgd.gradeCounts(grades))
    expect_false(csr$valid)
  })

  test_that("provides chi-square fit to normal failure", {
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(20, 18, 12, 8, 5, 8, 12, 18, 20))
    csr <- jgd.chiSqP(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_lt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal success", {
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6))
    csr <- jgd.chiSqP(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal with presence of NA", {
    gvs <- c(seq(55, 95, 5), NA)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6, 12))
    csr <- jgd.chiSqP(jgd.gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })
})
