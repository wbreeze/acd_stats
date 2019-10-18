context("Process")

describe("one flight", {
  flightRecord <- c(
    "11337",
    "3",
    "Unknown",
    "https://iaccdb.iac.org/flights/11337.json",
    "2019",
    "unlimited",
    "P"
  )
  names(flightRecord) <- c(
    "id",
    "sequence",
    "name",
    "url",
    "year",
    "level",
    "aircat"
  )

  it("Processes the flight", {
    pof <- ProcessOneFlight(flightRecord)
    sed <- pof$process()
    expect_true(sed$success)
  })
})
