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

