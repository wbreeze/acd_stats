context("Judge grade distribution")

describe("Process flight program", {
  processFlight10780 <- function() {
    id <- '10780'
    class <- 'Power'
    category <- 'Intermediate'
    format <- 'Known'
    year <- 2018
    f <- jgd.processFlight(id, class, category, format, year,
      GradesByJudge(grades_IAC_flight_10780))
  }

  it("produces data frame with expected columns", {
    f <- processFlight10780()
    expect_equal(class(f), "data.frame")
    expect_equal(names(f), c("flight", "class", "category", "format",
      "year", "judge", "pilot.ct", "figure.ct", "group.type",
      "k.mean", "grade.ct",
      "grades.mean", "grades.sd", "cluster.mean", "cluster.sd",
      "chiSq.df", "chiSq.t.p", "chiSq.d.p", "chiSq.valid", "valid.reason",
      "sw.p.value", "lf.p.value", "ad.p.value", "cvm.p.value",
      "da.skew", "da.z", "da.p.value", "da.alt"
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
