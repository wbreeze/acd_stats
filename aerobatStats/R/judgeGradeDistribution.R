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

  # Subset data for a given figure number
  jgd$figureGrades <- function(figure_number) {
    subset(jgd$fp, jgd$fp$FN == figure_number)
  }

  # Count number of occurrences within the range of grade values
  #   encompassed by the grades
  # This is something like, table(), but includes zero counts and
  #   also returns the range
  # Returns a list with range and counts elements
  jgd$distribution <- function(grades) {
    g <- grades[!is.na(grades)]
    r <- seq(min(g), max(g), 5)
    fct <- function(X, g) {
      length(g[g==X])
    }
    ct <- sapply(r, fct, g)
    list(range=r, counts=ct)
  }

  # Subset the data into groups according to FPS 3.3
  # Returns a list or vector of data frames that match the format of fp
  jgd$groups <- function() {
    jgd$fp
  }

  # Determine the intervals for Chi-square goodness of fit
  #   and the counts within them.
  # The intervals must encompass five or more grades.
  # Where there are fewer than five grades of a given value,
  #   the interval is extended to encompass more than one value.
  # TODO
  jgd$intervals <- function(grades) {
    g <- grades[!is.na(grades)]
    c(-Inf, seq(min(g)+2.5, max(g)-2.5, 5), Inf)
  }

  # Compute normal distribution for a collection of judge grades
  jgd$normal_distribution <- function(grades) {
    g <- grades[!is.na(grades)]
    diff(pnorm(jgd$intervals(grades), mean(g), sd(g)))
  }

  # Chi-square probability of fit of collection of judge grades to normal
  jgd$chiSqP <- function(grades) {
    g <- grades[!is.na(grades)]
    t <- jgd$distribution(g)
    chisq.test(t$counts, p=jgd$normal_distribution(g))$p.value
  }

  # Plot grade frequency histogram overlayed with the derived normal curve
  jgd$densityPlot <- function(grades) {
    g <- grades[!is.na(grades)]
    cutp <- seq(min(g)-2.5, max(g)+2.5, 5)
    d <- jgd$distribution(g)
    x <- rep(d$range, times=d$counts)
    hist(x, prob=T, br=cutp, col="skyblue2",
      xlim=c(0,100), ylim=c(0,.06))
      curve(dnorm(x, mean(g), sd(g)), add=T, lwd=2, col="red")
  }

  return(jgd)
}
