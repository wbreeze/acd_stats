context("Judge grades distributed")

describe("Distribute grades", {
  test_that("all grades", {
    grades <- c(55, NA, 60, 60, NA, rep(70,4), NA, rep(75,6), 80, 80, NA, 85)
    t <- jgd.gradeCounts(grades)
    g <- jgd.distributeGrades(t)
    expect_equal(length(g), length(t$grades))
  })

  test_that("all grades unique", {
    counts <- c(15, 30, 50, 55, 80, 70, 12, 14, 11, 17)
    grades <- rep(seq(55,100,5), times=counts)
    t <- jgd.gradeCounts(grades)
    expect_equal(counts, t$counts)
    g <- jgd.distributeGrades(t)
    expect_equal(length(unique(g)), length(t$grades))
  })

  test_that("all grades within range", {
    gv <- 55
    count <- 40
    grades <- rep(gv, times=count)
    t <- jgd.gradeCounts(grades)
    expect_equal(c(count), t$counts)
    g <- jgd.distributeGrades(t)
    expect(all(gv-5 < g & g < gv+5), "grades not +-5")
  })

  test_that("mean and std_dev approximate", {
    counts <- c(5, 7, 11, 7, 5, 7, 11, 11, 7, 7)
    grades <- rep(seq(55,100,5), times=counts)
    t <- jgd.gradeCounts(grades)
    g <- jgd.distributeGrades(t)
    expect_lt(abs(mean(g) - mean(grades)), 0.1)
    expect_lt(abs(sd(g) - sd(grades)), 0.1)
  })
})
