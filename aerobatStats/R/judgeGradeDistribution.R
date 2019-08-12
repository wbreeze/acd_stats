# Analyze judge grade distributions for each judge and each figure
# fp is Flight Program data in form returned by
#    CDBFlightProgram::gradesByJudge
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
JudgeGradeDistribution <- function(fp) {
  jgd <- list()
  jgd$fp <- fp
  class(jgd) <- "JudgeGradeDistribution"

  # Subset data for a given figure number
  jgd$figureGrades <- function(figure_number) {
    subset(jgd$fp, jgd$fp$FN == figure_number)
  }

  return(jgd)
}
