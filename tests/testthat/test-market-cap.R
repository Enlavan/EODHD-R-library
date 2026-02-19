test_that("market cap", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for market cap queries")

  suppressMessages({
    set_token()

    df_mcap1 <- get_market_cap(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_mcap1) > 0)

    # run it again for testing local cache
    df_mcap2 <- get_market_cap(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_mcap1, df_mcap2))
  })
})
