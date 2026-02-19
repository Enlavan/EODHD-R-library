test_that("indices list", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for marketplace queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_indices1 <- get_indices_list()

    expect_true(nrow(df_indices1) > 0)

    # run it again for testing local cache
    df_indices2 <- get_indices_list()

    expect_true(identical(df_indices1, df_indices2))
  })
})
