test_that("bulk fundamentals", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for bulk fundamental queries")

  suppressMessages({
    set_token()

    l_bulk1 <- get_bulk_fundamentals(exchange = "US", limit = 5)

    expect_true(length(l_bulk1) > 0)

    # run it again for testing local cache
    l_bulk2 <- get_bulk_fundamentals(exchange = "US", limit = 5)

    expect_true(identical(l_bulk1, l_bulk2))
  })
})
