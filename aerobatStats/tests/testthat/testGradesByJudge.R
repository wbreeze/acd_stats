library(aerobatStats)
context("Grades by judge")

describe("Read and write grades", {
  setupGradesByJudge <- function() {
    fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
    return(GradesByJudge(fp$gradesByJudge()))
  }

  it("Reads a grade", {
    gbj <- setupGradesByJudge()
    grade <- getGrade(gbj, 'X1695', 2915, 7)
    expect_equal(grade, 45)
  })

  it("Writes a grade", {
    gbj <- setupGradesByJudge()
    judge <- "X744"
    pilot <- 2915
    figure <- 4
    grade <- 0
    gbj <- setGrade(gbj, judge, pilot, figure, grade)
    expect_equal(getGrade(gbj, judge, pilot, figure), grade)
  })
})

describe("Zeros and averages", {
  setupZerosAndAverages <- function() {
    fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
    gbj <- GradesByJudge(fp$gradesByJudge())
    gbj <- setGrade(gbj, 'X1695', 2915, 2, -10)
    gbj <- setGrade(gbj, 'X744', 2915, 2, -20)
    gbj <- setGrade(gbj, 'X657', 2915, 2, -10)
    gbj <- setGrade(gbj, 'X1695', 2915, 3, -30)
    gbj <- setGrade(gbj, 'X744', 2915, 3, -30)
    gbj <- setGrade(gbj, 'X657', 2915, 3, 0)
    gbj <- setGrade(gbj, 'X1695', 2915, 4, -30)
    gbj <- setGrade(gbj, 'X744', 2915, 4, -30)
    gbj <- setGrade(gbj, 'X1695', 2915, 5, -30)
    gbj <- setGrade(gbj, 'X744', 2915, 5, -30)
    gbj <- setGrade(gbj, 'X657', 2915, 5, -30)
    gbj <- setGrade(gbj, 'X1695', 2915, 6, -30)
    gbj <- setGrade(gbj, 'X744', 2915, 6, -30)
    gbj <- setGrade(gbj, 'X657', 2915, 6, -10)
    gbj <- setGrade(gbj, 'X1695', 2915, 7, -30)
    gbj <- setGrade(gbj, 'X744', 2915, 7, -30)
    gbj <- setGrade(gbj, 'X657', 2915, 7, -20)
    gbj <- resolveZerosAndAverages(gbj)
    return(gbj)
  }

  it("properly resolves majority zeros", {
    gbj <- setupZerosAndAverages()
  })

  it("properly resolves minority zeros", {
  })

  it("properly resolves averages", {
  })
})

