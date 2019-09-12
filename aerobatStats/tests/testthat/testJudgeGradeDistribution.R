context("Judge grade distribution")

describe("Process flight program", {
  it("Produces data frame with expected columns", {
    id <- '10780'
    class <- 'Power'
    category <- 'Intermediate'
    format <- 'Known'
    f <- jgd.processFlight(id, class, category, format, grades_IAC_flight_10780)
    expect_equal(class(f), "data.frame")
    expect_equal(names(f), c("flight", "class", "category", "format",
      "judge", "figure.ct", "k.mean", "grade.ct",
      "d.mean", "d.sd", "t.mean", "t.sd",
      "chiSq.d.p", "chiSq.d.valid", "chiSq.t.p", "chiSq.t.valid"
    ))
  })
})
