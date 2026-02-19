test_that("news word weights", {

  skip_if_offline()
  skip_on_cran()

  skip_if(get_token() == get_demo_token(),
          "Found a test/demo token, which does not allow for news word weight queries")

  suppressMessages({
    set_token()

    df_words1 <- get_news_word_weights(ticker = "AAPL", exchange = "US")

    expect_true(nrow(df_words1) > 0)

    # run it again for testing local cache
    df_words2 <- get_news_word_weights(ticker = "AAPL", exchange = "US")

    expect_true(identical(df_words1, df_words2))
  })
})
