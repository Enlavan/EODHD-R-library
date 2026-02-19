test_that("exchange details", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for exchange detail queries")

  suppressMessages({
    set_token()

    l_details1 <- get_exchange_details(exchange = "US")

    expect_true(is.list(l_details1))
    expect_true(length(l_details1) > 0)

    # run it again for testing local cache
    l_details2 <- get_exchange_details(exchange = "US")

    expect_true(identical(l_details1, l_details2))
  })
})
