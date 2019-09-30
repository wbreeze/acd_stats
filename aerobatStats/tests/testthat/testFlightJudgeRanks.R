context("Flight judge ranks")

test_that("computes raw score from each judge", {
  fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
  fjr <- FlightJudgeRanks(fp)
  expect_false(is.null(fjr))
  expect_false(is.null(fjr$rawScoresByJudge()))
})
