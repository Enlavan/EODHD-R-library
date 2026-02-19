test_that("symbol changes", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for symbol change queries")

  suppressMessages({
    set_token()

    df_changes1 <- get_symbol_changes()

    expect_true(nrow(df_changes1) > 0)

    # run it again for testing local cache
    df_changes2 <- get_symbol_changes()

    expect_true(identical(df_changes1, df_changes2))
  })
})
