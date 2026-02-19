test_that("CBOE index data", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for CBOE queries")

  suppressMessages({
    set_token()

    df_vix1 <- get_cboe_index_data("VIX")

    expect_true(nrow(df_vix1) > 0)

    # run it again for testing local cache
    df_vix2 <- get_cboe_index_data("VIX")

    expect_true(identical(df_vix1, df_vix2))
  })
})

test_that("CBOE indices list", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for CBOE queries")

  suppressMessages({
    set_token()

    df_list1 <- get_cboe_indices_list()

    expect_true(nrow(df_list1) > 0)

    # run it again for testing local cache
    df_list2 <- get_cboe_indices_list()

    expect_true(identical(df_list1, df_list2))
  })
})
