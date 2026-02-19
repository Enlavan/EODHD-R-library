test_that("macro indicator", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for macro indicator queries")

  suppressMessages({
    set_token()

    df_macro1 <- get_macro_indicator(country = "USA", indicator = "gdp_current_usd")

    expect_true(nrow(df_macro1) > 0)

    # run it again for testing local cache
    df_macro2 <- get_macro_indicator(country = "USA", indicator = "gdp_current_usd")

    expect_true(identical(df_macro1, df_macro2))
  })
})
