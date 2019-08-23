This is a solution to running Chi-Squared tests using judge grade data.
The grade data is discreet, but ordinal. Grades are increments of five
from zero to one-hundred. (In reality, judges say, for example "five point
five" or "eight" or "eight point oh". We code those as 55, 80, 80.)

With counts of how often a judge gives a grade, there are sometimes low
numbers associated with a grade. The judge gave the grade not at all, or
one or two times. To do the Chi-Squared analysis, we join those
low-incidence classes with neighboring ones.

## Installation

Build the package using `R CMD build .`
The output of that command should include something like,
"* building ‘prechi_0.0.1.tar.gz’".
Now install it using, `R CMD INSTALL prechi_0.0.1.tar.gz`.

You can now load the package in an R session with `library(prechi)`.

## Usage

The package installs one R function, `prechi.cluster_neighbors`.
Call the function with a vector of grades, an equal length vector
of counts, and an optional third parameter that is the minimum count
desired in each cluster. Here is an example:

    grades <- c(55, 60, 65, 70, 75, 80, 85)
    counts <- c( 2,  0,  5,  8, 12, 10,  4)
    clustered <- prechi.cluster_neighbors(grades, counts)

The output is a list that includes the clustered counts and the
boundaries of each cluster. From the exmple above,

    > str(clustered)
    List of 7
     $ count            : int 4
     $ boundaries       : num [1:5] -Inf 67.5 72.5 77.5 Inf
     $ counts           : int [1:4] 7 8 12 14
     $ target_mean      : num 74
     $ target_variance  : num 51.5
     $ solution_mean    : num 74
     $ solution_variance: num 61.5

The returned list includes the weighted mean and variance computed from the
original data and from the clustered data. The values are the grades
and the weights are the counts. The values of joined clusters are the
average of the grades in the cluster.

## Testing

There are two kinds of tests: C tests and R tests.
The C tests are using Cutter. The R tests, testthat.

To get started with the C tests, you need a C compiler and GNU Autoconf
installed. With those, change to the `test` directory and say,

    $ autoreconf --install

Run the C tests from this directory using the run_tests.sh script,
`./run_tests.sh`. This will build any outdated dependencies for
the test suite from the `test` directory and run the tests.

Run the R tests from an R session initiated from the `test` directory:

    > library(devtools)
    > library(testthat)
    > load_all()
    > test_dir("test")

The last two commands may be used repeatedly after the first two have run.
