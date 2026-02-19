test_that("sentiments", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for sentiment queries")

  suppressMessages({
    set_token()

    df_sent1 <- get_sentiments(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_sent1) > 0)

    # run it again for testing local cache
    df_sent2 <- get_sentiments(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_sent1, df_sent2))
  })
})
