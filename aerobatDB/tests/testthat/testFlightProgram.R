library(aerobatDB)
context("flight program")

test_that("constructor retrieves a flight program", {
  fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
  expect_is(fp, "CDBFlightProgram")
  fpl <- fp$raw
  expect_is(fpl, "list")
  flight <- fpl$flight
  expect_is(flight, "list")
  expect_equal(flight$id, 9014)
})

test_that("flight program retrieves grades from all judges", {
  fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
  gbj <- fp$gradesByJudge()
  expect_is(gbj$K, "integer")
  expect_equal(10, gbj$K[1])
  expect_equal(14, gbj$K[2])
  expect_equal(10, gbj$K[8])
  expect_equal(14, gbj$K[9])
  expect_is(gbj$FN, "integer")
  expect_equal(1, gbj$FN[1])
  expect_equal(1, gbj$FN[8])
  expect_is(gbj$PN, "integer")
  expect_equal(2915, gbj$PN[1])
  expect_equal(2915, gbj$PN[7])
  expect_equal(1415, gbj$PN[8])
  expect_equal(1415, gbj$PN[14])
  expect_is(gbj$X1695, "integer")
  expect_equal(65, gbj$X1695[1])
  expect_equal(45, gbj$X1695[7])
  expect_equal(-30, gbj$X1695[13])
  expect_equal(90, gbj$X1695[14])
  expect_equal(0, gbj$X657[12])
  expect_equal(75, gbj$X456[5])
})

