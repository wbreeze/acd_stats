# Analyze judge grade distributions for each judge and each figure
# fp is Flight Program data in form returned by
#    CDBFlightProgram::gradesByJudge
# zeroNA, if set FALSE, will override default conversion of
#    all zero-ish and average values to NA
#
#     K FN   PN X1695 X744 X657 X456
# 1  10  1 2915    65   80   70   80
# 2  14  2 2915    70   75   75   85
# ...
# 7   3  7 2915    45   70   65   80
# 8  10  1 1415    90   90   85   80
# 9  14  2 1415    90   90   85   85
# ...
# 14  3  7 1415    90   80   90   80
# ...
#
# K: figure difficulty
# FN: figure number
# PN: pilot id number
# X1695 X744 X657 X456: grades from four judges
JudgeGradeDistribution <- function(fp, zeroNA=TRUE) {
  jgd <- list()
  jgd$fp <- fp
  if(zeroNA) {
    jgd$fp[jgd$fp <= 0] <- NA
  }
  class(jgd) <- "JudgeGradeDistribution"

  # Count number of occurrences within the range of grade values
  #   encompassed by the grades
  # This is something like, table(), but includes zero counts and
  #   also returns the range
  # Returns a list with:
  #   grades: non-NA grades,
  #   range: all grade values in order, covering the range of grades
  #   counts: number of occurrences of each grade value
  jgd$gradeCounts <- function(grades) {
    g <- grades[!is.na(grades)]
    r <- seq(min(g), max(g), 5)
    fct <- function(X, g) {
      length(g[g==X])
    }
    ct <- sapply(r, fct, g)
    list(range=r, counts=ct, grades=g)
  }

  # Plot grade frequency histogram overlayed with the derived normal curve
  jgd$densityPlot <- function(grades) {
    g <- grades[!is.na(grades)]
    cutp <- seq(min(g)-2.5, max(g)+2.5, 5)
    d <- jgd$gradeCounts(g)
    x <- rep(d$range, times=d$counts)
    hist(x, prob=T, br=cutp, col="skyblue2",
      xlim=c(0,100), ylim=c(0,.06))
      curve(dnorm(x, mean(g), sd(g)), add=T, lwd=2, col="red")
  }

  return(jgd)
}
