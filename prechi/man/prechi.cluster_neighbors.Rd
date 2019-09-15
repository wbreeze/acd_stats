\name{prechi.cluster_neighbors}
\alias{prechi.cluster_neighbors}
\title{
  Prepare judge grade frequency data for
  Chi-Square goodness of fit measurement
}
\description{
  The grades given by judges are discrete, however ordinal.
  When a judge awards a grade to fewer than five pilots, in order to do
  a Chi-Squared goodness of fit test, the instances of that grade must be
  merged with an adjacent grade. This process must iterate until there are
  five instances for each grade group. The code here does that using a full
  scan of the possible groupings, following a heuristic of smallest first,
  and bounded by largest possible number of groupings.
}
\usage{
prechi.cluster_neighbors(grades, counts, minimum_count = 5, timeout = 0,
  minimum_partition_count = 3)
}
\arguments{
  \item{grades}{
  A vector of grade values, increasing. It should include all of
  the grade values within the domain of grades from the least
  grade given to the greatest.
  }
  \item{counts}{
  A vector of integer counts, one per grade. The counts are the
  number of times the grade was given.
  }
  \item{minimum_count}{
  Minimum count needed for any grade or combination of grades.
  This defaults to five.
  }
  \item{timeout}{
  Maximum time in seconds. Defaults to one hour.
  Sending zero (the default) will result in a
  one hour timeout. The algorithm returns the current result at the
  timeout, or the first result found after the timeout.
  }
  \item{minimum_partition_count}{
  Minimum number of partitions in the solution.
  This defaults to three.
  }
}
\details{
  When a grade has a count less than the minimum, this combines counts
  with that of a neighboring grade. The process repeats
  until there are no grades that have fewer than the
  minimum count. With a solution or minimum of minimum_partition_count
  clusters, it backtracks to seach all other solutions.

  The search uses the heuristic of choosing to first try joining grades
  with the smallest counts. It bounds the search using number of joins.
  Having a solution, it rejects any solutions that contain a greater
  number of joins. Given two solutions with an equal number of joins,
  it favors the one with smaller difference from the original in
  weighted mean and variation.
}
\value{
The output is a list that includes the clustered counts and the
boundaries of each cluster.

  \item{count }{Integer number of grade values}
  \item{boundaries }{Real valued boundaries between clusters of grade values.
    This always starts with -Inf and ends with Inf.
    The number of values is one greater than count.}
  \item{counts }{The integer count of grades for each cluster}
  \item{target_mean }{The weighted mean of the original data}
  \item{target_variance }{The weighted variance of the original data}
  \item{solution_mean }{The weighted mean of the returned clusters}
  \item{solution_variance }{The weighted variance of the returned clusters}
}
\author{
Douglas Lovell
}
\examples{
    grades <- c(55, 60, 65, 70, 75, 80, 85)
    counts <- c( 2,  0,  5,  8, 12, 10,  4)
    clustered <- prechi.cluster_neighbors(grades, counts)
}
\keyword{cluster}
\keyword{distribution}
