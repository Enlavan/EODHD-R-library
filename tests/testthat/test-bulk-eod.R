test_that("bulk eod", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for bulk EOD queries")

  suppressMessages({
    set_token()

    df_bulk1 <- get_bulk_eod(exchange = "US")

    expect_true(nrow(df_bulk1) > 0)

    # run it again for testing local cache
    df_bulk2 <- get_bulk_eod(exchange = "US")

    expect_true(identical(df_bulk1, df_bulk2))
  })
})
