context("API")

describe("retrieval", {
  test_that("retrieves a good JSON URL", {
    url <- "https://iaccdb.iac.org/flights/11326.json"
    rv <- cdb.retrieveData(url)
    expect_equal(rv$url, url)
    expect_true(rv$success)
    expect_equal(length(rv$errors), 0)
    expect_type(rv$data, "list")
    expect_equal(c("flight"), names(rv$data))
  })

  test_that("returns error on good URL bad data", {
    url <- "https://google.com"
    rv <- cdb.retrieveData(url)
    expect_equal(rv$url, url)
    expect_false(rv$success)
    expect_equal(length(rv$errors), 1)
    expect_type(rv$data, "list")
    expect_equal(length(rv$data), 0)
  })

  test_that("returns error on bad URL", {
    url <- "file://nofile.err"
    rv <- cdb.retrieveData(url)
    expect_equal(rv$url, url)
    expect_false(rv$success)
    expect_equal(length(rv$errors), 1)
    expect_type(rv$data, "list")
    expect_equal(length(rv$data), 0)
  })
})
