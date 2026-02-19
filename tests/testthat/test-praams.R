test_that("PRAAMS bank balance sheet by ISIN", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result1 <- get_praams_bank_balance_sheet_isin("US0378331005")

    expect_true(is.list(result1))

    # run it again for testing local cache
    result2 <- get_praams_bank_balance_sheet_isin("US0378331005")

    expect_true(identical(result1, result2))
  })
})

test_that("PRAAMS bank balance sheet by ticker", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_bank_balance_sheet_ticker("AAPL", "US")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS bank income statement by ISIN", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_bank_income_statement_isin("US0378331005")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS bank income statement by ticker", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_bank_income_statement_ticker("AAPL", "US")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS bond analysis", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_bond_analysis("US0378331005")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS equity analysis by ISIN", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_equity_analysis_isin("US0378331005")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS equity analysis by ticker", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    result <- get_praams_equity_analysis_ticker("AAPL", "US")

    expect_true(is.list(result))
  })
})

test_that("PRAAMS bond report", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    pdf_path <- get_praams_bond_report("US0378331005", "test@example.com")

    expect_true(file.exists(pdf_path))
  })
})

test_that("PRAAMS equity report by ISIN", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    pdf_path <- get_praams_equity_report_isin("US0378331005", "test@example.com")

    expect_true(file.exists(pdf_path))
  })
})

test_that("PRAAMS equity report by ticker", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    pdf_path <- get_praams_equity_report_ticker("AAPL", "US", "test@example.com")

    expect_true(file.exists(pdf_path))
  })
})

test_that("PRAAMS bond screener", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_bonds <- get_praams_bond_screener()

    expect_true(nrow(df_bonds) > 0)
  })
})

test_that("PRAAMS equity screener", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for PRAAMS queries")

  skip("marketplace endpoint requires specific subscription")

  suppressMessages({
    set_token()

    df_equities <- get_praams_equity_screener()

    expect_true(nrow(df_equities) > 0)
  })
})
