test_that("UST bill rates", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for UST rate queries")

  suppressMessages({
    set_token()

    df_bills1 <- get_ust_bill_rates()

    expect_true(nrow(df_bills1) > 0)

    # run it again for testing local cache
    df_bills2 <- get_ust_bill_rates()

    expect_true(identical(df_bills1, df_bills2))
  })
})

test_that("UST long-term rates", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for UST rate queries")

  suppressMessages({
    set_token()

    df_lt1 <- get_ust_long_term_rates()

    expect_true(nrow(df_lt1) > 0)

    # run it again for testing local cache
    df_lt2 <- get_ust_long_term_rates()

    expect_true(identical(df_lt1, df_lt2))
  })
})

test_that("UST yield rates", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for UST rate queries")

  suppressMessages({
    set_token()

    df_yield1 <- get_ust_yield_rates()

    expect_true(nrow(df_yield1) > 0)

    # run it again for testing local cache
    df_yield2 <- get_ust_yield_rates()

    expect_true(identical(df_yield1, df_yield2))
  })
})

test_that("UST real yield rates", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for UST rate queries")

  suppressMessages({
    set_token()

    df_real1 <- get_ust_real_yield_rates()

    expect_true(nrow(df_real1) > 0)

    # run it again for testing local cache
    df_real2 <- get_ust_real_yield_rates()

    expect_true(identical(df_real1, df_real2))
  })
})
