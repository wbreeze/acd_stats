\name{IAC_JGF_Normal}
\docType{data}
\title{IAC judge grade goodness of fit to normal}
\description{
  Retrieved using main() from main.R during the first week of November, 2019
  Contains almost fifty thousand judge grade goodness of fit measurements
  for 194 IAC aerobatic contests from year 2014 to year 2019.
  The measurements include judge grades within FPS groups as well as within
  an entire flight.
}
\format{
  A data.frame with 38 variables:
"flight": IACCDB flight record identifier
"class": P_ower, G_lider, F_our minute
"category": Competition category, such as "Sportsman"
"format": Flight format such as "Known" or "Free"
"year": Year of the flight
"judge": IACCDB judge record identifier (prepended with "X")
"pilot.ct": Count of pilots in the flight
"figure.ct": Count of figures in the group or flight
"group.type": "fps" for FPS group, "all" for all grades given the flight
"k.mean": Mean of K values
"grade.ct": Count of grades
"grades.mean": Mean of grade values
"grades.sd": Standard deviation of grade values
"cluster.mean": Mean of the clustered grade values used for chiSq
"cluster.sd": Standard deviation of the clustered grade values used for chiSq
"chiSq.df": Degrees of freedom of the chiSq measurement
"chiSq.t.p": ChiSq p-value for GOF with normal having grades.mean, sd
"chiSq.d.p": ChiSq p-value for GOF with normal having cluster.mean, sd
"chiSq.valid": TRUE or FALSE valid ChiSq result
"chiSq.valid.reason": Reason if chiSq.valid == FALSE
"sw.p.value": Shapiro Wilks p-value for GOF
"sw.valid": TRUE or FALSE valid Shapiro Wilks result
"sw.valid.reason" Reason if sw.valid == FALSE
"lf.p.value": Lilifords measure p-value for GOF
"lf.valid": TRUE or FALSE valid Lilifords result
"lf.valid.reason": Reason if lf.valid == FALSE
"ad.p.value": Anderson-Darling measure p-value for GOF
"ad.valid": TRUE or FALSE valid Anderson-Darling result
"ad.valid.reason": Reason if ad.valid == FALSE
"cvm.p.value": Cramer-von Mises measure p-value for GOF
"cvm.valid": TRUE or FALSE valid Cramer-von Mises result
"cvm.valid.reason": Reason if cvm.valid == FALSE
"da.skew": Skew value from D'Agostino test
"da.z": D'Agostino test value
"da.p.value": D'Agostino p-value for Skew
"da.alt": D'Agostino skew description
"da.valid": TRUE or FALSE valid D'Agostino skew measurement
"da.valid.reason": Reason if da.valid == FALSE
}
\source{ https://iaccdb.iac.org/ }
\keyword{datasets}
