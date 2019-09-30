library('purrr')

context("contests")

describe("retrieval", {
  base_url <- "https://iaccdb.iac.org"

  setupCDBContests <- function() {
    CDBContests(base_url)
  }

  test_that("constructor accepts a source", {
    cl <- setupCDBContests()
    expect_is(cl, "CDBContests")
    expect_equal(cl$base, base_url)
  })

  test_that("retrieves contest year urls", {
    cl <- setupCDBContests()
    years <- cl$contestYears()
    expect_is(years, "character")
    urls <- reduce(years, function(s, y) { paste(s, y, sep=", ") })
    vapply(c(2020, 2019, 2018, 2006), function(year) {
      expect_match(urls, toString(year), fixed=TRUE)
    }, c(''))
  })

  test_that("retrieves contests", {
    cl <- setupCDBContests()
    contests <- cl$allContests()
    expect_is(contests, "data.frame")
    expect_equal(c("id", "name", "city", "state", "start", "chapter",
      "director", "region", "has_results", "url", "year"), names(contests))
    expected_ids <- c(678, 588, 545, 503, 355, 310, 247, 4, 49, 1)
    expect_true(all(!is.na(match(expected_ids, contests$id))))
    expected_years <- c(2019, 2018, 2017, 2009, 2006)
    expect_true(all(!is.na(match(expected_years, contests$year))))
  })
})
