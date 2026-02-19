test_that("marketplace tick data", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for marketplace queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_ticks1 <- get_mp_tick_data(
      symbol = "AAPL",
      from = Sys.Date() - 1,
      to = Sys.Date()
    )

    expect_true(nrow(df_ticks1) > 0)

    # run it again for testing local cache
    df_ticks2 <- get_mp_tick_data(
      symbol = "AAPL",
      from = Sys.Date() - 1,
      to = Sys.Date()
    )

    expect_true(identical(df_ticks1, df_ticks2))
  })
})
