ProcessOneFlight <- function(flight) {
  cp <- list()
  cp$flight <- flight

  cp$process <- function() {
    fp.sed <- sed.retrieveData(cp$flight["url"])
    if (fp.sed$success) {
      cfp <- CDBFlightProgram(fp.sed$data)
      cfp.sed <- cfp$gradesByJudge()
      if (cfp.sed$success) {
        fdf <- jgd.processFlight(flight["id"], flight["aircat"],
          flight["level"], flight["name"], flight["year"],
          GradesByJudge(cfp.sed$data)
        )
        list(success=TRUE, errors=c(), data=fdf)
      } else {
        cfp.sed
      }
    } else {
      fp.sed
    }
  }

  cp
}
