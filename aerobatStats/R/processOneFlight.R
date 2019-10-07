require(aerobatDB)

ProcessOneFlight <- function(flight) {
  cp <- list()
  cp$flight = flight

  cp$process <- function() {
    fp.sed <- cdb.retrieveData(cp$flight$url)
    if (fp.sed$success) {
      print("FP.SED"); str(fp.sed)
      cfp <- CDBFlightProgram(fp.sed$data)
      cfp.sed <- cfp$gradesByJudge()
      if (cfp.sed$success) {
        list(
          success = TRUE,
          errors = c(),
          data = jgd.processFlight(flight$id, flight$aircat, flight$level,
            flight$name, flight$year, cfp.sed$data)
        )
      } else {
        cfp.sed
      }
    } else {
      fp.sed
    }
  }

  cp
}
