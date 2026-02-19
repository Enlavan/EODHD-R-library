test_that("Illio best-and-worst", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result1 <- get_illio_best_and_worst("SnP500")

    expect_true(is.list(result1))

    # run it again for testing local cache
    result2 <- get_illio_best_and_worst("SnP500")

    expect_true(identical(result1, result2))
  })
})

test_that("Illio beta bands", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_beta_bands("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio volume", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_volume("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio performance", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_performance("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio risk", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_risk("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio volatility", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_volatility("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio category performance", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_category_performance("SnP500")

    expect_true(is.list(result))
  })
})

test_that("Illio category risk", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for Illio queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_illio_category_risk("SnP500")

    expect_true(is.list(result))
  })
})
