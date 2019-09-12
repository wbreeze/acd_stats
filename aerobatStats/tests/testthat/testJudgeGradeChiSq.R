context("Judge grade ChiSq test")

describe("ChiSq test on grade distribution", {
  setupJudgeGradeDistribution <- function() {
    return(JudgeGradeDistribution(grades_IAC_flight_10780))
  }

  test_that("returns not valid when only three grade values", {
    jgd <- setupJudgeGradeDistribution()
    jgcs <- JudgeGradeChiSq()
    grades <- rep(c(55, 65, 80), 5)
    csr <- jgcs$chiSqP(jgd$gradeCounts(grades))
    expect_false(csr$valid)
  })

  test_that("returns not valid when prechi.cluster fails", {
    jgd <- setupJudgeGradeDistribution()
    jgcs <- JudgeGradeChiSq()
    grades <- rep(c(55, 65, 80, 85), 3)
    csr <- jgcs$chiSqP(jgd$gradeCounts(grades))
    expect_false(csr$valid)
  })

  test_that("provides chi-square fit to normal failure", {
    jgd <- setupJudgeGradeDistribution()
    jgcs <- JudgeGradeChiSq()
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(20, 18, 12, 8, 5, 8, 12, 18, 20))
    csr <- jgcs$chiSqP(jgd$gradeCounts(grades))
    expect_true(csr$valid)
    expect_lt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal success", {
    jgd <- setupJudgeGradeDistribution()
    jgcs <- JudgeGradeChiSq()
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6))
    csr <- jgcs$chiSqP(jgd$gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal with presence of NA", {
    jgd <- setupJudgeGradeDistribution()
    jgcs <- JudgeGradeChiSq()
    gvs <- c(seq(55, 95, 5), NA)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6, 12))
    csr <- jgcs$chiSqP(jgd$gradeCounts(grades))
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })
})
