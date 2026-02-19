test_that("insider transactions", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for insider transaction queries")

  suppressMessages({
    set_token()

    df_ins1 <- get_insider_transactions(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_ins1) > 0)

    # run it again for testing local cache
    df_ins2 <- get_insider_transactions(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_ins1, df_ins2))
  })
})
