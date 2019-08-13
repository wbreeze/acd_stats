library(aerobatStats)
context("Grades by judge")

describe("Read and write grades", {
  setupGradesByJudge <- function() {
    return(GradesByJudge(grades_IAC_flight_10780))
  }

  it("Reads a grade", {
    gbj <- setupGradesByJudge()
    grade <- getGrade(gbj, 'X2414', 1033, 9)
    expect_equal(grade, 65)
  })

  it("Writes a grade", {
    gbj <- setupGradesByJudge()
    judge <- "X49"
    pilot <- 46
    figure <- 1
    grade <- 0
    gbj <- setGrade(gbj, judge, pilot, figure, grade)
    expect_equal(getGrade(gbj, judge, pilot, figure), grade)
  })
})

describe("Zeros and averages", {
  setupZerosAndAverages <- function() {
    gbj <- GradesByJudge(grades_IAC_flight_10780)
    gbj <- setGrade(gbj, 'X3045', 2448, 2, -10)
    gbj <- setGrade(gbj, 'X49', 2448, 2, -20)
    gbj <- setGrade(gbj, 'X2414', 2448, 2, -10)
    gbj <- setGrade(gbj, 'X3045', 2448, 3, -30)
    gbj <- setGrade(gbj, 'X49', 2448, 3, -30)
    gbj <- setGrade(gbj, 'X2414', 2448, 3, 0)
    gbj <- setGrade(gbj, 'X3045', 2448, 4, -30)
    gbj <- setGrade(gbj, 'X49', 2448, 4, -30)
    gbj <- setGrade(gbj, 'X3045', 2448, 5, -30)
    gbj <- setGrade(gbj, 'X49', 2448, 5, -30)
    gbj <- setGrade(gbj, 'X2414', 2448, 5, -30)
    gbj <- setGrade(gbj, 'X3045', 2448, 6, -30)
    gbj <- setGrade(gbj, 'X49', 2448, 6, -30)
    gbj <- setGrade(gbj, 'X2414', 2448, 6, -10)
    gbj <- setGrade(gbj, 'X3045', 2448, 7, -30)
    gbj <- setGrade(gbj, 'X49', 2448, 7, -30)
    gbj <- setGrade(gbj, 'X2414', 2448, 7, -20)
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

