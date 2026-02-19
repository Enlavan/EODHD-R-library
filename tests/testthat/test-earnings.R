test_that("earnings calendar", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for earnings queries")

  suppressMessages({
    set_token()

    df_earn1 <- get_earnings(symbols = "AAPL.US")

    expect_true(nrow(df_earn1) > 0)

    # run it again for testing local cache
    df_earn2 <- get_earnings(symbols = "AAPL.US")

    expect_true(identical(df_earn1, df_earn2))
  })
})
