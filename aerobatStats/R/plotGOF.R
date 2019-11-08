PlotGOF <- function(base.url) {
  pgf <- list()
  pgf$url <- base.url

  # Plot grade frequency histogram overlayed with the derived normal curve
  pgf$densityPlot <- function(gradeCounts,
    judge="", flight="", pilot.ct=NA, p.value=NA, k.mean=NA
  ) {
    g <- gradeCounts$grades
    cts <- gradeCounts$counts
    width <- 5
    hwidth <- width / 2
    cutp <- seq(min(g)-hwidth, max(g)+hwidth, width)
    x <- rep(gradeCounts$range, times=cts)
    maxp <- (max(cts) + mean(cts))/(width * sum(cts))
    hist(x, freq=F, br=cutp, col="skyblue2",
      xlim=c(0,100), ylim=c(0,maxp),
      main=sprintf("Distribution of %d grades", sum(cts)),
      sub=sprintf(
        "Judge %s, flight %s, %d pilots, mean K %5.2f",
        judge, flight, pilot.ct, k.mean
      ),
      xlab="Grade x 10"
    )
    curve(dnorm(x, mean(g), sd(g)), add=T, lwd=2, col="red")
    legend(legend=sprintf("AD p-value = %5.4e", p.value), x="topleft")
  }

  pgf$qqPlot <- function(gradeCounts,
    judge="", flight="", pilot.ct=NA, p.value=NA, k.mean=NA
  ) {
    g <- gradeCounts$grades
    qqnorm(g,
      main=sprintf("Normal Q-Q with %d grades", length(g)),
      sub=sprintf(
        "Judge %s, flight %s, %d pilots, mean K %5.2f",
        judge, flight, pilot.ct, k.mean
      )
    )
    qqline(g, col="red")
    legend(legend=sprintf("AD p-value = %5.4e", p.value), x="topleft")
  }

  plotGroup <- function(group, gbj, quart, flight, judge, k.mean) {
    grades <- gbj$grades[[as.character(judge)]][group]
    counts <- jgd.gradeCounts(grades)
    ad.sed <- sed.catchToList(ad.test, "Anderson-Darling")(grades)
    if (ad.sed$success) {
      pgf$densityPlot(counts, flight=flight, judge=judge,
        p.value=ad.sed$data$p.value,
        k.mean=k.mean, pilot.ct=gbj$pilotCount(gbj))
      pgf$qqPlot(counts, flight=flight, judge=judge,
        p.value=ad.sed$data$p.value,
        k.mean=k.mean, pilot.ct=gbj$pilotCount(gbj))
    } else {
      print(sprintf("Trouble computing fit for flight %s judge %s is %s",
        flight, judge, paste(ad.sed$errors)))
    }
  }

  plotGroupIfMatchK <- function(group, gbj, quart, flight, judge, k.mean) {
    mean.K <- mean(gbj$grades[["K"]][group])
    if (abs(mean.K - k.mean) < 0.1) {
      plotGroup(group, gbj, quart, flight, judge, k.mean=mean.K)
    }
  }

  plotJGD <- function(quart, flight, judge, cfp, k.mean) {
    cfp.sed <- cfp$gradesByJudge()
    if (cfp.sed$success) {
      gbj <- GradesByJudge(cfp.sed$data)
      groups <- gbj$groups(gbj)
      lapply(groups, plotGroupIfMatchK, gbj, quart, flight, judge, k.mean)
      plotGroupIfMatchK(seq(1,nrow(gbj$grades)),
        gbj, quart, flight, judge, k.mean)
    } else {
      print(sprintf("Trouble retrieving grades for flight %s", flight))
    }
  }

  retrieveGradesAndPlot <- function(quart, flight, judge, k.mean) {
    print(sprintf("Retrieve and plot Q: %s, F: %s, J: %s, K: %5.2f",
      quart, flight, judge, k.mean))
    path <- file.path(pgf$url, "flights", sprintf("%s.json", flight))
    fp.sed <- sed.retrieveData(path)
    if (fp.sed$success) {
      cfp <- CDBFlightProgram(fp.sed$data)
      fnm <- sprintf("plot_f%s_j%s_%5.2f_%%02d.svg", flight, judge, k.mean)
      print(paste("Plotting to ", fnm))
      svg(filename=fnm)
      plotJGD(quart, flight, judge, cfp, k.mean)
      dev.off()
    } else {
      print(sprintf("Trouble with flight %s, path %s", flight, path))
    }
  }

  determineFlightJudgeAndPlot <- function(quart, vad, d) {
    r1 <- d[
      d$ad.p.value >= vad[quart],
      c("ad.p.value", "flight", "judge", "grade.ct", "k.mean")
    ]
    r1 <- r1[
      order(c(r1$ad.p.value, r1$grade.ct), decreasing=c(FALSE, TRUE)),
    ]
    retrieveGradesAndPlot(quart, r1$flight[1], r1$judge[1], r1$k.mean[1])
  }

  pgf$doPlots <- function(d) {
    d <- d[d$ad.valid,]
    vad <- summary(d$ad.p.value)
    n <- names(vad)
    lapply(n[n != "Mean"], determineFlightJudgeAndPlot, vad, d)
    c()
  }

  pgf
}
