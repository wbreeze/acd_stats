library(jsonlite)

# url is the CDB REST base url
CDBContests <- function(url) {
  cdbc <- list()
  cdbc$base <- url
  class(cdbc) <- "CDBContests"

  # Gather all of the contest year URL's
  cdbc$contestYears <- function() {
    raw <- fromJSON(file.path(cdbc$base, "contests.json"))
    return(raw$years)
  }

  cdbc$allContests <- function() {
    years <- cdbc$contestYears()
    reduce(lapply(years, function(year) {
      ycs <- fromJSON(year)
      cbind(ycs$contests, list(year=c(as.integer(ycs$contest_year))))
    }), rbind)
  }

  return(cdbc)
}
