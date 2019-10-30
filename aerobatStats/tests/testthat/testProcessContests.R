context("ProcessContests")

describe("process contests", {
  contestProcessReturn <- list(success=TRUE)
  contestProcessor <- function(contest) {
    cp <- list()
    cp$contest <- contest
    cp$process <- function(pfs) {
      cp$pfs <<- pfs
      return(contestProcessReturn)
    }
    cp
  }

  cleanup <- function(pc) {
    unlink(c(pc$processedRecordsFileName, pc$errorsFileName, pc$dataFileName))
  }

  setup <- function() {
    pc <- ProcessContests(contest_selection,
      processedFileName="../tempPCProcessed.rds",
      errorsFileName="../tempPCErrors.rds",
      dataFileName="../tempPCData.rds",
      contestProcessor=contestProcessor)
    cleanup(pc)
    pc
  }

  it("Writes a contest to a processed contest list", {
    pc <- setup()
    pc$process(1)
    expect_true(file.exists(pc$processedRecordsFileName))
    pcr <- readRDS(pc$processedRecordsFileName)
    expect_true(695 %in% pcr)
    cleanup(pc)
  })

  it("Writes flight processed data to a data file", {
    pc <- setup()
    data <- c(1,2,3)
    contestProcessReturn <<- list(success=TRUE, data=data)
    pc$process(1)
    expect_true(file.exists(pc$dataFileName))
    stats <- readRDS(pc$dataFileName)
    expect_equal(stats, data)
    cleanup(pc)
  })

  it("Processes contests not in a processed contest list", {
    pc <- setup()
    cids <- pc$ctsts$id[pc$ctsts$has_results]
    cid <- cids[1]
    pcr <- cids[cids != cid]
    saveRDS(pcr, file=pc$processedRecordsFileName)
    pc$process()
    pcr <- readRDS(pc$processedRecordsFileName)
    expect_true(cid %in% pcr)
    cleanup(pc)
  })

  it("Writes error to error file if a contest fails", {
    pc <- setup()
    errorList <- c("Failed to read the contest")
    contestProcessReturn <<- list(success=FALSE, errors=errorList)
    pc$process(1)
    expect_true(file.exists(pc$errorsFileName))
    pce <- readRDS(pc$errorsFileName)
    expect_true(errorList %in% pce)
    cleanup(pc)
  })
})
