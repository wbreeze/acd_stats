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
})
