test_that("options underlyings", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for marketplace queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_underlyings1 <- get_options_underlyings()

    expect_true(nrow(df_underlyings1) > 0)

    # run it again for testing local cache
    df_underlyings2 <- get_options_underlyings()

    expect_true(identical(df_underlyings1, df_underlyings2))
  })
})
