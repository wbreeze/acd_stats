require(purrr)

# Expects a list of one contest data values, one record from the data.frame
#   returned by CDBContests$allContests
ProcessOneContest <- function(contest,
  contestRetriever=sed.retrieveData,
  flightProcessor=ProcessOneFlight
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

  flightsReducer <- function(accum, flight.sed) {
    list(
      success = accum$success && flight.sed$success,
      errors = c(accum$errors, flight.sed$errors),
      data = if (is.null(accum$data)) {
        flight.sed$data
      } else {
        rbind(accum$data, flight.sed$data)
      }
    )
  }

  # Process the contest, processing all of its flights
  pc$process <- function() {
    crv <- pc$contestRetriever(pc$contest$url)
    if (crv$success) {
      flights <- contestFlights(crv$data)
      reduce(
        map(
          apply(flights, 1, pc$flightProcessor),
          function(fproc) fproc$process()
        ),
      flightsReducer)
    } else {
      list(success=FALSE, data=c(), errors=crv$errors)
    }
  }

  pc
}
