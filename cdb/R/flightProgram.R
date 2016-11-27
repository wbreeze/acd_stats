library(jsonlite)

# url is the CDB REST url for a Flight
# We call it a "Flight Program" to distinguish it from one pilot's performance.
# It is about a collection of pilot competitors performing once each
# in a category before a panel of judges.
CDBFlightProgram <- function(url) {
  cfp <- list()
  cfp$url <- url
  class(cfp) <- "CDBFlightProgram"
  fp <- fromJSON(url)
  cfp$raw <- fp

  # gather grades for all of the pilots from all of the judges
  # together with k values of the sequences and any penalties
  cfp$collectCDBjf <- function(url) {
    resource = sprintf("%s/jf_results/%d", "https://iaccdb.iac.org", id)
    jf <- fromJSON(resource)
  }

  return(cfp)
}

