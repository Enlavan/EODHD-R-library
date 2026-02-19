test_that("options", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for options queries")

  suppressMessages({
    set_token()

    df_opts1 <- get_options(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_opts1) > 0)

    # run it again for testing local cache
    df_opts2 <- get_options(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_opts1, df_opts2))
  })
})
