#' Retrieves historical market capitalization data from eodhd
#'
#' This function queries the historical-market-cap endpoint and returns
#' time-series market cap data for a given ticker.
#'
#' @inheritParams get_fundamentals
#' @param first_date Start date (default previous year).
#' @param last_date End date (default today).
#'
#' @return A dataframe with historical market cap values
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_mcap <- get_market_cap(ticker = "AAPL", exchange = "US")
#' }
get_market_cap <- function(ticker = "AAPL",
                           exchange = "US",
                           first_date = Sys.Date() - 365,
                           last_date = Sys.Date(),
                           cache_folder = get_default_cache(),
                           check_quota = TRUE) {

  cli::cli_h1("retrieving historical market cap for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  cache_tag <- paste0("market_cap_", first_date, "_", last_date)
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/historical-market-cap/{ticker}.{exchange}?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no market cap data found for {ticker}|{exchange}")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  if ("date" %in% names(df_out)) {
    df_out$date <- as.Date(df_out$date)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of market cap data")

  return(df_out)
}
