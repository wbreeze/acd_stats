\name{IAC_flight_9014}
\docType{data}
\title{flight data from IAC contest flight number 9014}
\description{
  Retrieved by:
    IAC_flight_9014 <- fromJSON("https://iaccdb.iac.org/flights/9014.json")
    usethis::use_data(IAC_flight_9014)
  Contains flight for Primary Known flight at the Tequila Cup, November, 2016.
}
\format{
  A list with seven items:
   $ flight:List of 7
  ..$ id           : int 9014
  ..$ sequence     : int 1
  ..$ name         : chr "Known"
  ..$ contest      :List of 5
  ..$ categories   :'data.frame':	1 obs. of  4 variables:
  ..$ pilot_results:'data.frame':	2 obs. of  10 variables:
  ..$ line_judges  :'data.frame':	4 obs. of  17 variables:
}
\source{ https://iaccdb.iac.org/flights/9014.json }
\keyword{datasets}
