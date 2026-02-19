test_that("us quote", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for US quote queries")

  suppressMessages({
    set_token()

    df_quote1 <- get_us_quote(symbols = "AAPL.US")

    expect_true(nrow(df_quote1) > 0)

    # run it again for testing local cache
    df_quote2 <- get_us_quote(symbols = "AAPL.US")

    expect_true(identical(df_quote1, df_quote2))
  })
})
