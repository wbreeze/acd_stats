library(cdb)
context("flight program")

test_that("constructor retrieves a flight program", {
  fp <- CDBFlightProgram("https://iaccdb.iac.org/flights/9014.json")
  expect_is(fp, "CDBFlightProgram")
  fpl <- fp$raw
  expect_is(fpl, "list")
  flight <- fpl$flight
  expect_is(flight, "list")
  expect_equal(flight$id, 9014)
  print(fp$raw)
})

