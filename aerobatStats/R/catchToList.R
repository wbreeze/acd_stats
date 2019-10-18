require("jsonlite")

# This is more or less copied from: https://stackoverflow.com/a/4952908/608359
# fun: function to call
# ctxt: string copied to error and warning messages
# Returns a function that calls fun and returns a list with:
#    success: TRUE if no error or warning, FALSE otherwise
#    errors: Vector of strings
#    data: value returned from fun
sed.catchToList <- function(fun, ctxt) {
  function(...) {
    errorDescriptions <- NULL
    successFlag <- TRUE
    res <- withCallingHandlers(
        tryCatch(fun(...), error=function(e) {
            errorDescriptions <<- c(errorDescriptions, sprintf(
              "Error in %s is: %s", ctxt, conditionMessage(e))
            )
            successFlag <<- FALSE
            NULL
        }), warning=function(w) {
            errorDescriptions <<- c(errorDescriptions, sprintf(
              "Warning in %s is: %s", ctxt, conditionMessage(w))
            )
            invokeRestart("muffleWarning")
        })
    list(success=successFlag, errors=errorDescriptions, data=res)
  }
}

# Retrieve JSON data with error handling
# Returns a list with:
#    success: TRUE if no error or warning, FALSE otherwise
#    errors: Vector of strings
#    data: returned by fromJSON given the URL
sed.retrieveData <- function(url) {
  ctxt <- sprintf("fromJSON(%s)", url)
  sed <- sed.catchToList(fromJSON, ctxt)(url)
  sed$url <- url
  sed
}
