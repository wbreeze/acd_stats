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

  test_that("subsets rows for one figure", {
    jgd <- setupJudgeGradeDistribution()
    f1s <- jgd$figureGrades(1)
    expect_false(is.null(f1s))
    expect_length(f1s$PN, 10)
    expect_equal(unique(f1s$FN), 1)
  })

  test_that("provides normal distribution for set of grades", {
    jgd <- setupJudgeGradeDistribution()
    grades <- jgd$figureGrades(2)$X49
    expect_equal(min(grades), 75)
    expect_equal(max(grades), 90)
    dist <- jgd$normal_distribution(grades)
    expect_equal(round(dist * 100), c(36, 35, 22, 7))
  })

  test_that("provides normal distribution with presence of NA", {
    jgd <- setupJudgeGradeDistribution()
    grades <- jgd$fp$X49
    nd <- round(jgd$normal_distribution(grades) * 1000)
    expect_equal(nd, c(3, 18, 71, 177, 270, 253, 145, 64))
  })

  test_that("normal distribution probabilities sum to one", {
    jgd <- setupJudgeGradeDistribution()
    grades <- jgd$fp$X49
    nd <- jgd$normal_distribution(grades)
    expect_equal(sum(nd), 1.0)
  })

  test_that("provides chi-square fit to normal", {
    jgd <- setupJudgeGradeDistribution()
    grades <- jgd$figureGrades(2)$X49
    expect_equal(round(jgd$chiSqP(grades) * 1000), 725)
  })

  test_that("provides chi-square fit to normal with presence of NA", {
    jgd <- setupJudgeGradeDistribution()
    grades <- jgd$fp$X49
    pValue <- round(jgd$chiSqP(grades) * 1000)
    expect_equal(pValue, 413)
  })

  test_that("counts zero frequency within the range", {
    jgd <- setupJudgeGradeDistribution()
    grades <- c(55, 60, 60, rep(70,4), NA, rep(75,6), 80, 80, 85)
    t <- jgd$distribution(grades)
    expect_equal(t$range, seq(55,85,5))
    expect_equal(t$counts, c(1, 2, 0, 4, 6, 2, 1))
  })
})
