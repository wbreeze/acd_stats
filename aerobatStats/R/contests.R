library(jsonlite)
library(purrr)

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

  extractCategoryFlights <- function(categoryRow, year) {
    cbind(categoryRow$flights, year=c(year), level=c(categoryRow$level),
      aircat=c(categoryRow$aircat))
  }

  # url is the contest url from the url column of a row from #allContests
  cdbc$contestFlights <- function(url) {
    cdata <- fromJSON(url)
    reduce(
      apply(cdata$category_results, 1, extractCategoryFlights, cdata$year),
      rbind
    )
  }

  return(cdbc)
}
