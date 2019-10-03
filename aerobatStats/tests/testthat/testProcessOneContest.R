context("Process")

describe("one contest", {
  flightProcessReturn <- list(success=TRUE)
  flightProcessor <- function(flight) {
    cp <- list()
    cp$flight = flight
    cp$process <- function() {
      return(flightProcessReturn)
    }
    cp
  }

  setupProcessOneContest <- function() {
    contest_record <- list(
      id         = 686,
      name       = "JAMES K POLK OPEN INVITATIONAL",
      city       = "Warrenton",
      state      = "VA",
      start      = "2019-09-07",
      chapter    = 11,
      director   = "Adam Cope",
      region     = "NorthEast",
      has_results= TRUE,
      url        = "https://iaccdb.iac.org/contests/686.json",
      year       = 2019
    )
    contestRetriever <- function(url) {
      list(url=url, success=TRUE, errors=c(), data=one_contest)
    }
    ProcessOneContest(
      contest_record,
      flightProcessor=flightProcessor,
      contestRetriever=contestRetriever
    )
  }

  it("Processes the contest", {
    pc <- setupProcessOneContest()
    v <- pc$process()
    expect_equal(length(v), 12)
  })

  it("Processes flights not in processed results", {
    skip("later")
    pc <- setupProcessOneContest()
    pc$process()
    expect_true(FALSE, "pend")
  })

  it("Returns error when a flight fails", {
    skip("later")
    pc <- setupProcessOneContest()
    errorList <- c("Failed to read the flight")
    flightProcessReturn <<- list(success=FALSE, errors=errorList)
    pc$process()
    expect_true(FALSE, "pend")
  })
})
