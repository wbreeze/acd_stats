main <- function() {
  cdbc <- CDBContests('https://iaccdb.iac.org')
  print("Loading contests...")
  ctsts <- cdbc$allContests()
  print(sprintf("%d contests loaded", nrow(ctsts)))
  pc <- ProcessContests(ctsts)
  pc$process()
}
