test_that("user details", {

  skip_if_offline()
  skip_on_cran()

  suppressMessages({
    set_token()

    result <- get_user_details()

    expect_true(is.list(result))
    expect_true("name" %in% names(result))
  })
})
