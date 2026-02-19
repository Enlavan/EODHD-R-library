test_that("technical indicators", {

  skip_if_offline()
  skip_on_cran()

  suppressMessages({
    set_token()

    df_tech1 <- get_technical(ticker = "AAPL", exchange = "US",
                              func = "sma", period = 50)

    expect_true(nrow(df_tech1) > 0)

    # run it again for testing local cache
    df_tech2 <- get_technical(ticker = "AAPL", exchange = "US",
                              func = "sma", period = 50)

    expect_true(identical(df_tech1, df_tech2))
  })
})
