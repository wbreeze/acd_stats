# Expects a data frame of the form returned by
# aerobatDB::CDBFlightProgram$gradesByJudge
GradesByJudge <- function(gradesByJudge) {
  gbj <- list()
  gbj$grades <- gradesByJudge
  gbj$column_for <- function(pilot, figure) {
    fcols <- (gbj$grades[["FN"]] == figure)
    pcols <- (gbj$grades[["PN"]] == pilot)
    return(which(fcols & pcols))
  }
  class(gbj) <- c("list", "GradesByJudge")
  return(gbj)
}

getGrade <- function(gbj, judge, pilot, figure) {
  UseMethod("getGrade", gbj)
}
getGrade.GradesByJudge <- function(gbj, judge, pilot, figure) {
  return(gbj$grades[[judge]][gbj$column_for(pilot, figure)])
}

setGrade <- function(gbj, judge, pilot, figure, grade) {
  UseMethod("setGrade", gbj)
}
setGrade.GradesByJudge <- function(gbj, judge, pilot, figure, grade) {
  gbj$grades[[judge]][gbj$column_for(pilot, figure)] <- grade
  return(gbj)
}
