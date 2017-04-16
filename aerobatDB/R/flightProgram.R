library(jsonlite)

# url is the CDB REST url for a Flight
# We call it a "Flight Program" to distinguish it from one pilot's performance.
# It is about a collection of pilot competitors performing once each
# in a category before a panel of judges.
CDBFlightProgram <- function(url) {
  cfp <- list()
  cfp$url <- url
  class(cfp) <- "CDBFlightProgram"
  cfp$raw <- fromJSON(url)

  # Gather all of the judges' grades for all of the pilots in the flight program.
  # A grade of -30 encodes HZ: Hard Zero
  # A grade of -20 encodes CA: Conference Average
  # A grade of -10 encodes  A: Average
  # A grade of   0 encodes a soft zero
  # In IAC prior to the year 2014, 0 encodes a hard zero
  # 'data.frame':  14 obs. of  7 variables:
  #  $ K    : int  10 14 10 4 5 10 3 10 14 10 4 ... Figure K value
  #  $ FN   : int  1 2 3 4 5 6 7 1 2 3 4 5 6 7 ... Figure number
  #  $ PN   : int  2915 2915 2915 2915 2915 2915 ... Pilot identifier
  #  $ X1695: int  65 70 70 70 80 75 45 90 90 95 ... Judge grades
  #  $ X744 : int  80 75 90 80 80 75 70 90 90 90 ...
  #  $ X657 : int  70 75 75 80 75 80 65 85 85 90 ...
  #  $ X456 : int  80 85 80 80 75 85 80 80 85 90 ...
  cfp$gradesByJudge <- function() {
    judges <- cfp$raw$flight$line_judges
    judgeId <- judges$judge$id
    pfrs <- cfp$raw$flight$pilot_results
    pfUrls <- pfrs$url
    pfds <- lapply(pfUrls, function(url) fromJSON(url)[[1]])
    judgePilotGrades <- lapply(judgeId, function(jid) {
      vector(mode='integer', length=0)
    })
    names(judgePilotGrades) <- judgeId
    kValues <- c()
    pilotIds <- c()
    figureNumbers <- c()
    for(pfd in pfds) {
      pid <- pfd$pilot$id
      seq <- pfd$sequence$k_values
      pilotIds <- c(recursive=TRUE, pilotIds, rep(pid, length(seq)))
      kValues <- c(recursive=TRUE, kValues, seq)
      figureNumbers <- c(recursive=TRUE, figureNumbers, 1:length(seq))
      grades <- pfd$grades
      for (i in 1:nrow(grades)) {
        jg = grades[i,]
        jid <- as.character(jg$judge$id)
        judgePilotGrades[[jid]] <- c(recursive=TRUE,
          judgePilotGrades[[jid]], jg$values)
      }
    }
    return(data.frame(K=kValues, FN=figureNumbers, PN=pilotIds,
      judgePilotGrades))
  }

  return(cfp)
}

