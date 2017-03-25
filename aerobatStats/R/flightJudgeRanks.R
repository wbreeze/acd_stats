library(aerobatDB)

FlightJudgeRanks <- function(fp) {
  fjr <- list()
  fjr$fp <- fp
  class(fjr) <- "FlightJudgeRanks"

  # Compute a raw score total from each judge
  fjr$rawScoresByJudge <- function() {
    return(NULL)
  }

  return(fjr)
}

