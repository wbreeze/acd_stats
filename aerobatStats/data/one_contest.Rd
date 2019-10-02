\name{one_contest}
\docType{data}
\title{List with content of one contest record}
\description{
  Retrieved by:
    one_contest <- contest_selection[contest_selection$has_results == TRUE,][3,,drop=TRUE]
    usethis::use_data(one_contest)
  Contains contest record for James K. Polk Open, 2019-09-17 in form
    of a list
}
\format{
  A list with elements:
    $id [1] 686
    $name [1] "JAMES K POLK OPEN INVITATIONAL"
    $city [1] "Warrenton"
    $state [1] "VA"
    $start [1] "2019-09-07"
    $chapter [1] 11
    $director [1] "Adam Cope"
    $region [1] "NorthEast"
    $has_results [1] TRUE
    $url [1] "https://iaccdb.iac.org/contests/686.json"
    $year [1] 2019
}
\keyword{datasets}
