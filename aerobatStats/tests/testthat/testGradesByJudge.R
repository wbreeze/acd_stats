context("Grades by judge")

describe("grade data", {
  setupGradesByJudge <- function() {
    return(GradesByJudge(grades_IAC_flight_10780))
  }

  it("Reads a grade", {
    gbj <- setupGradesByJudge()
    grade <- gbj$getGrade(gbj, 'X2414', 1033, 9)
    expect_equal(grade, 65)
  })

  it("Writes a grade", {
    gbj <- setupGradesByJudge()
    judge <- "X49"
    pilot <- 46
    figure <- 1
    grade <- 0
    gbj <- gbj$setGrade(gbj, judge, pilot, figure, grade)
    expect_equal(gbj$getGrade(gbj, judge, pilot, figure), grade)
  })

  it("returns the number of pilots", {
    gbj <- setupGradesByJudge()
    expect_equal(gbj$pilotCount(gbj), 10)
  })

  it("returns the list of judges", {
    gbj <- setupGradesByJudge()
    expect_equal(gbj$judgeList(gbj), c('X3045', 'X49', 'X2414', 'X1041', 'X36'))
  })

  it("returns the correct figure groupings", {
    gbj <- setupGradesByJudge()
    groups <- gbj$groups(gbj)
    figures <- lapply(groups, function(group) {
      sort(unique(gbj$grades$FN[group]))
    })
    expect_equal(figures, list(c(1,3),c(6,9),c(7,8),c(2,11),c(4,5,10)))
    sizes <- lapply(groups, function(group) { length(group) })
    expect_equal(sizes, list(20, 20, 20, 20, 30))
  })

  it("returns one figure group when length less than chunk size", {
    gbj <- setupGradesByJudge()
    groups <- gbj$groups(gbj, length(gbj$grades$K) + 1)
    expect_equal(length(groups), 1)
    expect_equal(length(groups[[1]]), length(gbj$grades$K))
  })
})
