test_that("logo download", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for logo queries")

  suppressMessages({
    set_token()

    logo_path <- get_logo("AAPL.US")

    expect_true(file.exists(logo_path))
  })
})

test_that("SVG logo download", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for logo queries")

  suppressMessages({
    set_token()

    logo_path <- get_logo_svg("AAPL.US")

    expect_true(file.exists(logo_path))
  })
})
