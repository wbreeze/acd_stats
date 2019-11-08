main <- function() {
  intfn <- getOption("interrupt")
  options(interrupt = browser)
  cdbc <- CDBContests('https://iaccdb.iac.org')
  print("Loading contests...")
  ctsts <- cdbc$allContests()
  print(sprintf("%d contests loaded", nrow(ctsts)))
  pc <- ProcessContests(ctsts)
  r <- pc$process()
  options(interrupt = intfn)
  r
}

characterizeJGF <- function(d) {
  print("Grade Count"); print(summary(d$grade.ct));
  print("Pilot Count"); print(summary(d$pilot.ct));
  print("Group Type"); print(table(d$group.type));
  print("Category"); print(table(d$category));
  print("Class"); print(table(d$class));
  print("Format"); print(table(d$format));
  print("ChiSq Valid"); print(table(d$chiSq.valid));
  print("ChiSq t p"); print(summary(d[d$chiSq.valid,]$chiSq.t.p));
  print("ChiSq d p"); print(summary(d[d$chiSq.valid,]$chiSq.d.p));
  print("Shapiro Wilks Valid"); print(table(d$sw.valid));
  print("Shapiro Wilks p"); print(summary(d[d$sw.valid,]$sw.p.value));
  print("Lillifors Valid"); print(table(d$lf.valid));
  print("Lillifors p"); print(summary(d[d$lf.valid,]$lf.p.value));
  print("Anderson Darling Valid"); print(table(d$ad.valid));
  print("Anderson Darling p"); print(summary(d[d$ad.valid,]$ad.p.value));
  print("Cramer-von Mises Valid"); print(table(d$cvm.valid));
  print("Cramer-von Mises p"); print(summary(d[d$cvm.valid,]$cvm.p.value));
  print("D'Agostino Valid"); print(table(d$da.valid));
  print("D'Agostino p"); print(summary(d[d$da.valid,]$da.p.value));
  print("D'Agostino skew"); print(summary(d[d$da.valid,]$da.skew));
  correlateJGF(d)
}

correlateJGF <- function(d) {
  cg <- d[d$sw.valid & d$lf.valid & d$ad.valid & d$cvm.valid,]
  cg <- cg[,c(
    "sw.p.value","lf.p.value", "ad.p.value", "cvm.p.value"
  )]
  print("Correlation Matrix");
  cor(cg)
}

knownK <- function(d) {
  d[d$format %in% c(
    "Known", "Unknown", "Unknown II", "Flight 1", "Flight 2", "Flight 3"
    ) &
    d$class %in% c("P", "G"),]
}

manyGrades <- function(d) {
  d[5 < d$pilot.ct & 11 < d$grade.ct,]
}
