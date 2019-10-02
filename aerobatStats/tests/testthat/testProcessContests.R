context("Contests")

describe("process contests", {
  contestProcessReturn <- list(success=TRUE)
  contestProcessor <- function(contest) {
    cp <- list()
    cp$contest = contest
    cp$process <- function() {
      return(contestProcessReturn)
    }
    cp
  }

  setupProcessContests <- function() {
    pc <- ProcessContests(contest_selection,
      processedFileName='../tempPCProcessed.rds',
      errorsFileName='../tempPCErrors.rds',
      contestProcessor=contestProcessor)
    if (file.exists(pc$processedRecordsFileName)) {
      file.remove(pc$processedRecordsFileName)
    }
    pc
  }

  it("Writes a contest to a processed contest list", {
    pc <- setupProcessContests()
    pc$process(1)
    expect_true(file.exists(pc$processedRecordsFileName))
    pcr <- readRDS(pc$processedRecordsFileName)
    expect_true(695 %in% pcr)
  })

  it("Processes contests not in a processed contest list", {
    pc <- setupProcessContests()
    pcr <- pc$ctsts$id
    cids <- pcr[pc$ctsts$has_results]
    cid <- cids[1]
    pcr <- cids[cids != cid]
    saveRDS(pcr, file=pc$processedRecordsFileName)
    pc$process(1)
    pcr <- readRDS(pc$processedRecordsFileName)
    expect_true(cid %in% pcr)
  })

  it("Writes error to error file if a contest fails", {
    pc <- setupProcessContests()
    errorList <- c("Failed to read the contest")
    contestProcessReturn <<- list(success=FALSE, errors=errorList)
    pc$process(1)
    expect_true(file.exists(pc$errorsFileName))
    pce <- readRDS(pc$errorsFileName)
    expect_true(errorList %in% pce)
  })
})
