context("Judge grade counts")

describe("Determine grade counts", {
  test_that("counts zero frequency within the range", {
    grades <- c(55, 60, 60, rep(70,4), rep(75,6), 80, 80, 85)
    t <- jgd.gradeCounts(grades)
    expect_equal(t$range, seq(55,85,5))
    expect_equal(t$counts, c(1, 2, 0, 4, 6, 2, 1))
  })

  test_that("ignores NA grades", {
    grades <- c(55, NA, 60, 60, NA, rep(70,4), NA, rep(75,6), 80, 80, NA, 85)
    t <- jgd.gradeCounts(grades)
    expect_equal(t$range, seq(55,85,5))
    expect_equal(t$counts, c(1, 2, 0, 4, 6, 2, 1))
    expect_equal(length(t$grades), 16)
  })

  test_that("ignores zeroish grades", {
    grades <- c(55, 0, 60, 60, -10, rep(70,4), -20, rep(75,6), 80, 80, -30, 85)
    t <- jgd.gradeCounts(grades)
    expect_equal(t$range, seq(55,85,5))
    expect_equal(t$counts, c(1, 2, 0, 4, 6, 2, 1))
    expect_equal(length(t$grades), 16)
  })
})
