test_that("ESG companies list", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_companies1 <- get_esg_companies()

    expect_true(nrow(df_companies1) > 0)

    # run it again for testing local cache
    df_companies2 <- get_esg_companies()

    expect_true(identical(df_companies1, df_companies2))
  })
})

test_that("ESG countries list", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_countries <- get_esg_countries()

    expect_true(nrow(df_countries) > 0)
  })
})

test_that("ESG sectors list", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_sectors <- get_esg_sectors()

    expect_true(nrow(df_sectors) > 0)
  })
})

test_that("ESG company detail", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_esg <- get_esg_company("AAPL.US")

    expect_true(nrow(df_esg) > 0)
  })
})

test_that("ESG country detail", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_country <- get_esg_country("US")

    expect_true(nrow(df_country) > 0)
  })
})

test_that("ESG sector detail", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for ESG queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_sector <- get_esg_sector("Technology")

    expect_true(nrow(df_sector) > 0)
  })
})
