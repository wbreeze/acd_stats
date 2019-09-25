context("Judge grade distribution")

describe("Process flight program", {
  processFlight10780 <- function() {
    id <- '10780'
    class <- 'Power'
    category <- 'Intermediate'
    format <- 'Known'
    f <- jgd.processFlight(id, class, category, format,
      GradesByJudge(grades_IAC_flight_10780))
  }

  it("produces data frame with expected columns", {
    f <- processFlight10780()
    expect_equal(class(f), "data.frame")
    expect_equal(names(f), c("flight", "class", "category", "format",
      "judge", "figure.ct", "k.mean", "grade.ct",
      "d.mean", "d.sd", "t.mean", "t.sd",
      "chiSq.df", "chiSq.d.p", "chiSq.t.p", "chiSq.valid", "valid.reason"
    ))
  })

  it("produces correct flight id, class, category, and format content", {
    f <- processFlight10780()
    expect_equal(levels(f$flight), c('10780'))
    expect_equal(levels(f$class), c('Power'))
    expect_equal(levels(f$category), c('Intermediate'))
    expect_equal(levels(f$format), c('Known'))
  })

  it("produces records for each judge", {
    f <- processFlight10780()
    gbj <- GradesByJudge(grades_IAC_flight_10780)
    expect_equal(sort(levels(f$judge)), sort(gbj$judgeList(gbj)))
  })
})
