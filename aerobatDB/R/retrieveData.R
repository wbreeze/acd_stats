require("jsonlite")

# Retrieve JSON data with error handling
# Returns a list with:
#    success: TRUE if no error or warning, FALSE otherwise
#    errors: Vector of strings
#    data: returned by fromJSON given the URL
cdb.retrieveData <- function(url) {
  errors <- c()
  success <- TRUE
  onError <- function(e) {
    errors <<- c(errors, sprintf("Failed retrieval \"%s\", error: %s",
      url, e$message))
    success <<- FALSE
    list()
  }
  data <- tryCatch(fromJSON(url), error=onError, warning=onError)
  list(url=url, success=success, errors=errors, data=data)
}
