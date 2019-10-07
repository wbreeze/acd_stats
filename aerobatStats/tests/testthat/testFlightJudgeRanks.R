context("Flight judge ranks")

test_that("computes raw score from each judge", {
  fp <- CDBFlightProgram(IAC_flight_9014)
  fjr <- FlightJudgeRanks(fp)
  expect_false(is.null(fjr))
  expect_false(is.null(fjr$rawScoresByJudge()))
})
