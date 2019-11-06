require('purrr')
require('nortest') # for lillie.test and ad.test
require('moments') # for agostino.test

# Analyze judge grade distributions for each judge and each figure
# id: flight identifier
# class: flight competition class, e.g. glider 'G' or power 'P'
# category: flight competition category, e.g. Unlimited 'U', Intermediate 'I'
# format: is the flight program format, e.g. Known 'K', Unknown 'U'
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
jgd.processFlight <- function(id, class, category, format, year, fp) {
  judges <- fp$judgeList(fp)
  groups <- fp$groups(fp)
  type <- if (length(groups) == 1) 'all' else 'fps'
  reduce(lapply(
    judges, jgd.processJudge,
    groups, type, id, class, category, format, year, fp
  ), rbind)
}

jgd.processJudge <- function(
  judge, groups, type, id, class, category, format, year, fp
) {
  results <- reduce(lapply(groups, jgd.processJudgeGroup,
    judge, id, class, category, format, year, type, fp), rbind)
  if (1 < length(groups)) {  # more than one group
    all <- fp$groups(fp, length(fp$grades$K))
    a <- reduce(lapply(all, jgd.processJudgeGroup,
      judge, id, class, category, format, year, 'all', fp), rbind)
    results <- rbind(results, a)
  }
  results
}

jgd.processJudgeGroup <- function(
  group, judge, id, class, category, format, year, group.type, fp)
{
  ks <- fp$grades$K[group]
  figs <- fp$grades$FN[group]
  grades <- fp$grades[[judge]][group]
  counts <- jgd.gradeCounts(grades)
  p <- data.frame(
    flight=id, class=class, category=category, format=format, year=year,
    judge=judge,
    pilot.ct=length(unique(fp$grades$PN)),
    figure.ct=length(unique(figs)),
    group.type=group.type,
    k.mean=mean(ks),
    grade.ct=length(counts$grades),
    grades.mean=mean(grades),
    grades.sd=sd(grades)
  )
  chiSq <- jgd.chiSqP(counts)
  p <- cbind(p, list(
    cluster.mean=chiSq$solution_mean,
    cluster.sd=sqrt(chiSq$solution_variance),
    chiSq.df=chiSq$df,
    chiSq.t.p=chiSq$pu,
    chiSq.d.p=chiSq$pc,
    chiSq.valid=chiSq$valid,
    chiSq.valid.reason=if(is.null(chiSq$reason)) NA else chiSq$reason
  ))
  dGrades <- jgd.distributeGrades(counts)
  swilks <- sed.catchToList(shapiro.test, "Shapiro")(dGrades)
  p <- cbind(p, list(
    sw.p.value=if(is.null(swilks$data)) NA else swilks$data$p.value,
    sw.valid=swilks$success,
    sw.valid.reason=if(is.null(swilks$errors)) NA else swilks$errors
  ))
  lillie <- sed.catchToList(lillie.test, "Lillie")(counts$grades)
  p <- cbind(p, list(
    lf.p.value=if(is.null(lillie$data)) NA else lillie$data$p.value,
    lf.valid = lillie$success,
    lf.valid.reason=if(is.null(lillie$errors)) NA else lillie$errors
  ))
  ad <- sed.catchToList(ad.test, "Anderson-Darling")(counts$grades)
  p <- cbind(p, list(
    ad.p.value=if(is.null(ad$data)) NA else ad$data$p.value,
    ad.valid = ad$success,
    ad.valid.reason=if(is.null(ad$errors)) NA else ad$errors
  ))
  cvm <- sed.catchToList(cvm.test, "Cramer-von Mises")(counts$grades)
  p <- cbind(p, list(
    cvm.p.value=if(is.null(cvm$data)) NA else cvm$data$p.value,
    cvm.valid=cvm$success,
    cvm.valid.reason=if(is.null(cvm$errors)) NA else cvm$errors
  ))
  das <- sed.catchToList(agostino.test, "D'Agostino")(counts$grades)
  p <- cbind(p, list(
    da.skew=if(is.null(das$data)) NA else unname(das$data$statistic['skew']),
    da.z=if(is.null(das$data)) NA else unname(das$data$statistic['z']),
    da.p.value=if(is.null(das$data)) NA else das$data$p.value,
    da.alt=if(is.null(das$data)) NA else das$data$alternative,
    da.valid=das$success,
    da.valid.reason=if(is.null(das$errors)) NA else das$errors
  ))
  p
}

# Plot grade frequency histogram overlayed with the derived normal curve
jgd.densityPlot <- function(gradeCounts) {
  g <- gradeCounts$grades
  cutp <- seq(min(g)-2.5, max(g)+2.5, 5)
  x <- rep(gradeCounts$range, times=gradeCounts$counts)
  hist(x, prob=T, br=cutp, col="skyblue2",
    xlim=c(0,100), ylim=c(0,.06))
    curve(dnorm(x, mean(g), sd(g)), add=T, lwd=2, col="red")
}
