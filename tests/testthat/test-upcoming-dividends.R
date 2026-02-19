test_that("upcoming dividends", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for upcoming dividends queries")

  suppressMessages({
    set_token()

    df_divs1 <- get_upcoming_dividends()

    expect_true(nrow(df_divs1) > 0)

    # run it again for testing local cache
    df_divs2 <- get_upcoming_dividends()

    expect_true(identical(df_divs1, df_divs2))
  })
})
