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
  vr <- d[d$chiSq.valid,]
  print("ChiSq t p"); print(summary(vr$chiSq.t.p));
  print("ChiSq t p-value <= 0.05");
  print(table(vr$chiSq.t.p <= 0.05));
  print("ChiSq d p"); print(summary(vr$chiSq.d.p));
  print("ChiSq d p-value <= 0.05");
  print(table(vr$chiSq.d.p <= 0.05));

  print("Shapiro Wilks Valid"); print(table(d$sw.valid));
  vr <- d[d$sw.valid,]
  print("Shapiro Wilks p"); print(summary(vr$sw.p.value));
  print("Shapiro Wilks p-value <= 0.05");
  print(table(vr$sw.p.value <= 0.05));

  print("Lillifors Valid"); print(table(d$lf.valid));
  vr <- d[d$lf.valid,]
  print("Lillifors p"); print(summary(vr$lf.p.value));
  print("Lillifors p-value <= 0.05");
  print(table(vr$lf.p.value <= 0.05));

  print("Anderson Darling Valid"); print(table(d$ad.valid));
  vr <- d[d$ad.valid,]
  print("Anderson Darling p"); print(summary(vr$ad.p.value));
  print("Anderson Darling p-value <= 0.05");
  print(table(vr$ad.p.value <= 0.05));

  print("Cramer-von Mises Valid"); print(table(d$cvm.valid));
  vr <- d[d$cvm.valid,]
  print("Cramer-von Mises p"); print(summary(vr$cvm.p.value));
  print("Cramer-von Mises p-value <= 0.05");
  print(table(vr$cvm.p.value <= 0.05));

  print("D'Agostino Valid"); print(table(d$da.valid));
  vr <- d[d$da.valid,]
  print("D'Agostino p"); print(summary(vr$da.p.value));
  print("D'Agostino skew"); print(summary(vr$da.skew));

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
