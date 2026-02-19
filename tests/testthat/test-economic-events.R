test_that("economic events", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for economic event queries")

  suppressMessages({
    set_token()

    df_events1 <- get_economic_events(country = "US")

    expect_true(nrow(df_events1) > 0)

    # run it again for testing local cache
    df_events2 <- get_economic_events(country = "US")

    expect_true(identical(df_events1, df_events2))
  })
})
