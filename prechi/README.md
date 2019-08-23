## Testing
There are two kinds of tests: C tests and R tests.
The C tests are using Cutter. The R tests, testthat.

Run the C tests from this directory using the run_tests.sh script,
`./run_tests.sh`. This will build the test suite from the `test` directory.

Run the R tests from an R session as follows:

    > library(devtools)
    > library(testthat)
    > load_all()
    > test_dir("test")

The last two commands may be used repeatedly after the first two have run.
