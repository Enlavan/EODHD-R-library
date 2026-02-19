test_that("screener", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for screener queries")

  suppressMessages({
    set_token()

    df_screen1 <- get_screener(sort = "market_capitalization", limit = 10)

    expect_true(nrow(df_screen1) > 0)

    # run it again for testing local cache
    df_screen2 <- get_screener(sort = "market_capitalization", limit = 10)

    expect_true(identical(df_screen1, df_screen2))
  })
})
