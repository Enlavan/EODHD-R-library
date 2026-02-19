test_that("live prices", {

  skip_if_offline()
  skip_on_cran()

  suppressMessages({
    set_token()

    df_rt1 <- get_live_prices(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_rt1) > 0)

    # run it again for testing local cache
    df_rt2 <- get_live_prices(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_rt1, df_rt2))
  })
})
