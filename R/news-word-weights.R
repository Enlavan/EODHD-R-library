#' Retrieves news word weights from eodhd
#'
#' This function queries the news-word-weights endpoint and returns
#' word frequency / weight data from financial news for a given ticker.
#'
#' @inheritParams get_fundamentals
#' @param first_date Start date (default previous 30 days).
#' @param last_date End date (default today).
#' @param limit Maximum number of results (default 100).
#'
#' @return A dataframe with word weight data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_words <- get_news_word_weights(ticker = "AAPL", exchange = "US")
#' }
get_news_word_weights <- function(ticker = "AAPL",
                                  exchange = "US",
                                  first_date = Sys.Date() - 30,
                                  last_date = Sys.Date(),
                                  limit = 100,
                                  cache_folder = get_default_cache(),
                                  check_quota = TRUE) {

  cli::cli_h1("retrieving news word weights for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  cache_tag <- paste0("news_word_weights_", first_date, "_", last_date)
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/news-word-weights?',
           's={ticker}.{exchange}&',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}&',
           'limit={limit}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no news word weights found for {ticker}|{exchange}")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} word weight records")

  return(df_out)
}
