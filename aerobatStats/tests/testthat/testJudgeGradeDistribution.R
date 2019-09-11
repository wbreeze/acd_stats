context("Judge grade distribution")

describe("Process flight program", {
  setupJudgeGradeDistribution <- function() {
    return(JudgeGradeDistribution(grades_IAC_flight_10780))
  }

  test_that("creates class from grades by judge", {
    jgd <- setupJudgeGradeDistribution()
    expect_false(is.null(jgd))
    expect_s3_class(jgd, "JudgeGradeDistribution")
  })

  test_that("changes zero-ish values and averages to NA", {
    jgd <- JudgeGradeDistribution(grades_IAC_flight_10780)
    expect_gt(nrow(subset(jgd$fp, is.na(jgd$fp))), 0)
    expect_equal(nrow(subset(jgd$fp, jgd$fp == 0)), 0)
    expect_equal(nrow(subset(jgd$fp, jgd$fp == -30)), 0)
    expect_equal(nrow(subset(jgd$fp, jgd$fp == -10)), 0)
  })

  test_that("leaves zero-ish values and averages when zeroNA false", {
    jgd <- JudgeGradeDistribution(grades_IAC_flight_10780, zeroNA=FALSE)
    expect_equal(nrow(subset(jgd$fp, is.na(jgd$fp))), 0)
    expect_gt(nrow(subset(jgd$fp, jgd$fp == 0)), 0)
    expect_gt(nrow(subset(jgd$fp, jgd$fp == -30)), 0)
    expect_gt(nrow(subset(jgd$fp, jgd$fp == -10)), 0)
  })

  test_that("counts zero frequency within the range", {
    jgd <- setupJudgeGradeDistribution()
    grades <- c(55, 60, 60, rep(70,4), NA, rep(75,6), 80, 80, 85)
    t <- jgd$gradeCounts(grades)
    expect_equal(t$range, seq(55,85,5))
    expect_equal(t$counts, c(1, 2, 0, 4, 6, 2, 1))
  })

  test_that("subsets rows for one figure", {
    jgd <- setupJudgeGradeDistribution()
    f1s <- jgd$figureGrades(1)
    expect_false(is.null(f1s))
    expect_length(f1s$PN, 10)
    expect_equal(unique(f1s$FN), 1)
  })

  test_that("returns not valid when only three grade values", {
    jgd <- setupJudgeGradeDistribution()
    grades <- rep(c(55, 65, 80), 5)
    csr <- jgd$chiSqP(grades)
    expect_false(csr$valid)
  })

  test_that("returns not valid when prechi.cluster fails", {
    jgd <- setupJudgeGradeDistribution()
    grades <- rep(c(55, 65, 80, 85), 3)
    csr <- jgd$chiSqP(grades)
    expect_false(csr$valid)
  })

  test_that("provides chi-square fit to normal failure", {
    jgd <- setupJudgeGradeDistribution()
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(20, 18, 12, 8, 5, 8, 12, 18, 20))
    csr <- jgd$chiSqP(grades)
    expect_true(csr$valid)
    expect_lt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal success", {
    jgd <- setupJudgeGradeDistribution()
    gvs <- seq(55, 95, 5)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6))
    csr <- jgd$chiSqP(grades)
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })

  test_that("provides chi-square fit to normal with presence of NA", {
    jgd <- setupJudgeGradeDistribution()
    gvs <- c(seq(55, 95, 5), NA)
    grades <- rep(gvs, c(6, 8, 12, 18, 20, 18, 12, 8, 6, 12))
    csr <- jgd$chiSqP(grades)
    expect_true(csr$valid)
    expect_gt(csr$pu, 0.05)
  })
})
