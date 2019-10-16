require(purrr)

# Process contests from contest list, appending results to file
# Expects a data frame of the form returned by CDBContests$allContests
ProcessContests <- function(ctsts,
  processedFileName="pc_processed.rds",
  errorsFileName="pc_errors.rds",
  dataFileName="pc_data.rds",
  contestProcessor=ProcessOneContest
) {
  pc <- list()
  pc$ctsts <- ctsts

  # processedRecords is just a vector of contest id's
  # We store the vector so that we don't process a contest that we've
  #   already processed on a prior run
  pc$processedRecordsFileName <- processedFileName

  pc$errorsFileName <- errorsFileName
  pc$dataFileName <- dataFileName
  pc$contestProcessor = contestProcessor

  # load the named file with recovery and a message on error
  loadFile <- function(fileName, fileDescription, errorMessage) {
    onError <- function(w) {
      print(
        sprintf("%s file, \"%s\" retrieval error: \"%s\". %s",
        fileDescription, fileName, w$message, errorMessage),
        quote=FALSE
      )
      NULL
    }
    tryCatch(
      readRDS(fileName),
      error=onError, warning=onError
    )
  }

  processContestId <- function(cid) {
    record <- pc$ctsts[pc$ctsts$id == cid,]
    if (0 < nrow(record)) {
      contest <- record[1,,drop=TRUE]
      p <- pc$contestProcessor(contest)
      p$process()
    } else {
      list(success=FALSE, errors=c('Contest record not found'))
    }
  }

  processContestAndRecord <- function(trackingList, cid) {
    result = processContestId(cid)
    if (result$success) {
      trackingList$data <- if (is.null(trackingList$data)) {
        result$data
      } else {
        rbind(trackingList$data, result$data)
      }
      saveRDS(trackingList$data, file=pc$dataFileName)
      trackingList$done <- c(trackingList$done, cid)
      saveRDS(trackingList$done, file=pc$processedRecordsFileName)
    } else {
      trackingList$errors <- c(
        trackingList$errors,
        sprintf("There was trouble with contest Id %d", cid),
        result$errors
      )
      saveRDS(trackingList$errors, file=pc$errorsFileName)
    }
    trackingList
  }

  # Process the contests in the ctsts data frame
  # Only processes contests for which have_data is TRUE
  # Writes a bookmarking file to pc$processedRecordsFileName
  # Only processes contests whose Id is not already in the bookmarks file
  # Writes errors to pc$errorsFileName
  # Uses a "process" method of pc$contestProcessor called with
  #   each contest record
  # Processes up to max_count records, where max_count defaults to
  #   a large number, 1000
  pc$process <- function(max_count=1000) {
    processedRecords <- loadFile(pc$processedRecordsFileName,
      "Processed records", "NOTE: Processing all contests.")
    processErrors <- loadFile(pc$errorsFileName, "Errors", "Will start one.")
    processedData <- loadFile(pc$dataFileName, "Data", "Starting data file.")
    toProcess <- pc$ctsts$id[pc$ctsts$has_results]
    toProcess <- unique(toProcess[!(toProcess %in% processedRecords)])
    if (max_count < length(toProcess)) {
      toProcess <- toProcess[seq(1, max_count)]
    }
    reduce(toProcess, processContestAndRecord,
      .init=list(done=processedRecords, errors=processErrors,
        data=processedData))
  }

  pc
}
