test_that("trading hours markets", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for trading hours queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result1 <- get_tradinghours_markets()

    expect_true(is.data.frame(result1) || is.list(result1))

    # run it again for testing local cache
    result2 <- get_tradinghours_markets()

    expect_true(identical(result1, result2))
  })
})

test_that("trading hours lookup", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for trading hours queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_tradinghours_lookup("NYSE")

    expect_true(is.data.frame(result) || is.list(result))
  })
})

test_that("trading hours details", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for trading hours queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_tradinghours_details("US.NYSE")

    expect_true(is.list(result))
  })
})

test_that("trading hours status", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for trading hours queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_tradinghours_status("US.NYSE")

    expect_true(is.list(result))
  })
})
