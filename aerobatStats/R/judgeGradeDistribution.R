# Analyze judge grade distributions for each judge and each figure
# id: flight identifier
# class: flight competition class, e.g. glider 'G' or power 'P'
# category: flight competition category, e.g. "Unlimited"
# format: is the flight program format, e.g. "Known", "Unknown"
# fp: Flight Program data in form returned by
#   CDBFlightProgram::gradesByJudge, like this:
#
#         K FN   PN X1695 X744 X657 X456
#     1  10  1 2915    65   80   70   80
#     2  14  2 2915    70   75   75   85
#     ...
#     7   3  7 2915    45   70   65   80
#     8  10  1 1415    90   90   85   80
#     9  14  2 1415    90   90   85   85
#     ...
#     14  3  7 1415    90   80   90   80
#
#     K: figure difficulty
#     FN: figure number
#     PN: pilot id number
#     X1695 X744 X657 X456: grades from four judges
jgd.processFlight <- function(id, class, category, format, fp) {
}

# Plot grade frequency histogram overlayed with the derived normal curve
jgd.densityPlot <- function(gradeCounts) {
  g <- gradeCounts.grades
  cutp <- seq(min(g)-2.5, max(g)+2.5, 5)
  x <- rep(gradeCounts$range, times=gradeCounts$counts)
  hist(x, prob=T, br=cutp, col="skyblue2",
    xlim=c(0,100), ylim=c(0,.06))
    curve(dnorm(x, mean(g), sd(g)), add=T, lwd=2, col="red")
}
