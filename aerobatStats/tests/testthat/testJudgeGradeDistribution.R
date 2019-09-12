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
})
