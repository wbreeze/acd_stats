require(purrr)
require(aerobatDB)

# Expects a list of one contest data values, one record from the data.frame
#   returned by aerobatDB::CDBContests$allContests
ProcessOneContest <- function(contest,
  contestRetriever=cdb.retrieveData,
  flightProcessor=NULL
) {
  pc <- list()
  pc$contest <- contest
  pc$contestRetriever = contestRetriever
  pc$flightProcessor = flightProcessor

  extractCategoryFlights <- function(categoryRow, year) {
    cbind(categoryRow$flights, year=c(year), level=c(categoryRow$level),
      aircat=c(categoryRow$aircat))
  }

  contestFlights <- function(cdata) {
    reduce(
      apply(cdata$category_results, 1, extractCategoryFlights, cdata$year),
      rbind
    )
  }

  # Process the contest, processing all of its flights
  pc$process <- function() {
    crv <- pc$contestRetriever(pc$contest$url)
    if (!crv$success) {
      list(success=FALSE, results=c(), errors=crv$errors)
    } else {
      flights <- contestFlights(crv$data)
      map(apply(flights, 1, pc$flightProcessor), function(pc) pc$process())
    }
  }

  pc
}
