\name{contest_selection}
\docType{data}
\title{Selected contests}
\description{
  Retrieved by:
    cdbc <- CDBContests('https://iaccdb.iac.org')
    cdb_contests <- cdbc$allContests()
    tn <- subset(cdb_contests, year == 2019)
    nn <- subset(cdb_contests, grepl("National", name))
    contest_selection <- rbind(tn, nn)
    usethis::use_data(contest_selection)
  Contains contests from 2019 and contests with "National" in the name
  The data set contains contest records for a selection of 57 IAC contests,
    including National Championships
}
\format{
  A data.frame with columns:
  > names(contest_selection)
 [1] "id"          "name"        "city"        "state"       "start"
 [6] "chapter"     "director"    "region"      "has_results" "url"
[11] "year"
  See aerobatStats::CBDContests$allContests
}
\source{ https://iaccdb.iac.org/contests.json }
\keyword{datasets}
