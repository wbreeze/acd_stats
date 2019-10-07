context("Process")

describe("one flight", {
  flightRecord <- list(
    id = "11337",
    sequence = "3",
    name = "Unknown",
    url = "https://iaccdb.iac.org/flights/11337.json",
    year = "2019",
    level = "unlimited",
    aircat = "P"
  )

  it("Processes the flight", {
    pof <- ProcessOneFlight(flightRecord)
    sed <- pof$process()
    print("SED"); str(sed)
    expect_true(sed$success)
  })
})
