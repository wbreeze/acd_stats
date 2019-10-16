\name{one_contest}
\docType{data}
\title{List with content of one contest record}
\description{
  Retrieved by:
    one_contest <- sed.retrieveData(
      "https://iaccdb.iac.org/contests/686.json")$data
    usethis::use_data(one_contest, overwrite=TRUE)
  Contains contest record for James K. Polk Open, 2019-09-17
}
\format{
  A list with elements:
  List of 10
      id              : int 686
      start           : chr "2019-09-07"
      name            : chr "JAMES K POLK OPEN INVITATIONAL"
      year            : int 2019
      region          : chr "NorthEast"
      city            : chr "Warrenton"
      state           : chr "VA"
      chapter         : int 11
      director        : chr "Adam Cope"
      category_results:'data.frame':	4 obs. of  7 variables:
}
\keyword{datasets}
