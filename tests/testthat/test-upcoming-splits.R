test_that("upcoming splits", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for upcoming splits queries")

  suppressMessages({
    set_token()

    df_splits1 <- get_upcoming_splits()

    expect_true(nrow(df_splits1) > 0)

    # run it again for testing local cache
    df_splits2 <- get_upcoming_splits()

    expect_true(identical(df_splits1, df_splits2))
  })
})
