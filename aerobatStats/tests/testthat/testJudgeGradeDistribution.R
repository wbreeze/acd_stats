context("Judge grade distribution")

describe("Process flight program", {
  setupJudgeGradeDistribution <- function() {
    fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
    return(JudgeGradeDistribution(fp$gradesByJudge()))
  }

  test_that("creates class from grades by judge", {
    jgd <- setupJudgeGradeDistribution()
    expect_false(is.null(jgd))
    expect_s3_class(jgd, "JudgeGradeDistribution")
  })

  test_that("subsets rows for one figure", {
    jgd <- setupJudgeGradeDistribution()
    f1s <- jgd$figureGrades(1)
    expect_false(is.null(f1s))
    expect_length(f1s$PN, 2)
    expect_equal(unique(f1s$FN), 1)
  })
})
