# Expects a data frame of the form returned by
# aerobatStats::CDBFlightProgram$gradesByJudge
GradesByJudge <- function(gradesByJudge) {
  gbj <- list()
  gbj$grades <- gradesByJudge

  gbj$column_for <- function(pilot, figure) {
    fcols <- (gbj$grades[["FN"]] == figure)
    pcols <- (gbj$grades[["PN"]] == pilot)
    return(which(fcols & pcols))
  }

  # Subset the data into groups according to FPS 3.3
  # Returns a list of groups, each being a list of row indices
  #   for the rows in the group
  # FPS 3.3 uses a minimum group size of 11, the default for group_size
  # The function may be used to make larger sized groups
  gbj$groups <- function(gbj, group_size=11) {
    kfps <- order(gbj$grades$K, gbj$grades$FN, gbj$grades$PN,
      decreasing=c(TRUE, FALSE, FALSE))
    chunk <- gbj$pilotCount(gbj)
    chunk <- (group_size %/% chunk + 1) * chunk
    length <- length(kfps)
    chunk_count <- length %/% chunk
    if (1 < chunk_count) {
      firsts <- seq(1, length - length %% chunk, chunk)
      lasts <- c(seq(chunk, length - chunk, chunk), length)
      mapply(function(from, to) {
        kfps[seq(from,to)]
      }, firsts, lasts)
    } else list(kfps)
  }

  gbj$pilotCount <- function(gbj) {
    length(unique(gbj$grades$PN))
  }

  gbj$judgeList <- function(gbj) {
    colns <- names(gbj$grades)
    xCols <- vapply(colns, function(name) {
      length(grep("X[[:digit:]]+", name)) != 0
    }, c(TRUE))
    colns[xCols]
  }

  gbj$getGrade <- function(gbj, judge, pilot, figure) {
    return(gbj$grades[[judge]][gbj$column_for(pilot, figure)])
  }

  gbj$setGrade <- function(gbj, judge, pilot, figure, grade) {
    gbj$grades[[judge]][gbj$column_for(pilot, figure)] <- grade
    return(gbj)
  }

  class(gbj) <- c("list", "GradesByJudge")
  return(gbj)
}
