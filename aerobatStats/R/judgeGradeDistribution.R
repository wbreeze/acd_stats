require('prechi')

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
  # TODO this moves to GradesByJudge, as grouping
  jgd$figureGrades <- function(figure_number) {
    subset(jgd$fp, jgd$fp$FN == figure_number)
  }

  # Subset the data into groups according to FPS 3.3
  # Returns a list or vector of data frames that match the format of fp
  # TODO this moves to GradesByJudge, as grouping
  jgd$groups <- function() {
    jgd$fp
  }

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

  # Chi-square probability of fit of collection of judge grades to normal
  # Return a list with the following:
  #   pu: ChiSq p-value against normal derived from unclustered data
  #   pc: ChiSq p-value against normal derived from clustered data
  #   df: Degrees of freedom
  #   valid: whether the test was valid, true or false
  # The test is not valid if the grade clustering produces fewer than four
  #   intervals, or if there are fewer than four different grades given
  #   to begin with. A judge who limits themselves to grades from
  #   7.0 to 8.0, or to 6.0, 7.5, and 9.0 defeats this test.
  # We also mark the test invalid if the chisq.test function produces a warning
  # Do not confuse valid with significant. The p-values determine significance.
  #   Of course, not valid means you can't reject, and that the p-values
  #   are meaningless
  jgd$chiSqP <- function(grades) {
    rv <- list(valid=T, df=NaN, pu=NaN, pc=NaN)
    t <- jgd$gradeCounts(grades)
    set_invalid_warn <- function(w) {
      rv$valid <<- F
      invokeRestart("muffleWarning")
    }
    set_invalid_error <- function(w) {
      rv$valid <<- F
    }
    clust <- tryCatch(prechi.cluster_neighbors(t$range, t$counts),
        error=set_invalid_error, warning = set_invalid_error)
    if (rv$valid) {
      rv$df <- clust$count - 3
      dist <- diff(pnorm(clust$boundaries, clust$target_mean,
        sqrt(clust$target_variance)))
      rv$pu <- withCallingHandlers(
        tryCatch(chisq.test(clust$counts, p=dist)$p.value,
          error=set_invalid_error),
        warning = set_invalid_warn
      )
      dist <- diff(pnorm(clust$boundaries, clust$solution_mean,
        sqrt(clust$solution_variance)))
      rv$pc <- withCallingHandlers(
        tryCatch(chisq.test(clust$counts, p=dist)$p.value,
          error=set_invalid_error),
        warning = set_invalid_warn
      )
    }
    rv
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
