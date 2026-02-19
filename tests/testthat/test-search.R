test_that("search", {

  skip_if_offline()
  skip_on_cran()

  suppressMessages({
    set_token()

    df_search1 <- get_search(query = "Apple", limit = 5)

    expect_true(nrow(df_search1) > 0)

    # run it again for testing local cache
    df_search2 <- get_search(query = "Apple", limit = 5)

    expect_true(identical(df_search1, df_search2))
  })
})
