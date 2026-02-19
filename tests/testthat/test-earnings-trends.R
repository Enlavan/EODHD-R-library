test_that("earnings trends", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for earnings trends queries")

  suppressMessages({
    set_token()

    df_trends1 <- get_earnings_trends(symbols = "AAPL.US")

    expect_true(nrow(df_trends1) > 0)

    # run it again for testing local cache
    df_trends2 <- get_earnings_trends(symbols = "AAPL.US")

    expect_true(identical(df_trends1, df_trends2))
  })
})
