\name{grades_IAC_flight_10780}
\docType{data}
\title{flight grades from IAC contest flight number 10780}
\description{
  Retrieved by:
    fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/10780.json")
    grades_IAC_flight_10780 <- fp$gradesByJudge()
    usethis::use_data(grades_IAC_flight_10780)
  Contains grades for Intermediate Known flight at the Snowbird Classic,
  Dunnellon, Florida, March, 2019.
  The data set contains grades for ten pilots from five judges.
}
\format{
  A data.frame with columns: K, FN, PN, X3045, X49, X2414, X1041, X36.
  The X columns represent judges and contain grades.
  See aerobatStats::CBDFlightProgram$gradesByJudge
}
\source{ https://iaccdb.iac.org/flights/10780.json }
\keyword{datasets}
