FlightJudgeRanks <- function(fp) {
  fjr <- list()
  fjr$fp <- fp
  class(fjr) <- "FlightJudgeRanks"

  # Compute a raw score total from each judge
  fjr$rawScoresByJudge <- function() {
    grades <- fp$gradesByJudge()
    grades <- fjr$processZerosAndAverages(grades$data)
    return(grades)
  }

  # Adjust confirmed hard zeros to zero
  # Adjust remaining hard zeros to NA
  # Adjust averages and conference averages to NA
  # Works against a flight grades data.frame
  fjr$processZerosAndAverages <- function(grades) {
    for (r in 1 : nrow(grades)) {
      # we know that judge grades start at the fourth column
      judgeCt <- ncol(grades) - 3
      minCtHZ <- floor(judgeCt / 2) + 1
      grades[r, 4:ncol(grades)] <- fjr$processHZ(grades[r,4:ncol(grades)], minCtHZ)
    }
    return(grades)
  }

  # Adjust hard zeros to zero if their count is greater than or equal to minCtHZ
  # Otherwise adjust hard zeros to NA
  # Works on the grade columns from a row of a flight grades data frame
  fjr$processHZ <- function(figureGrades, minCtHZ) {
    ctHZ <- sum(figureGrades == -30, na.rm=TRUE)
    if (minCtHZ <= ctHZ) {
      figureGrades[,] <- 0
    } else {
      figureGrades[which(figureGrades == -30)] <- NA
    }
    figureGrades
  }

  return(fjr)
}

