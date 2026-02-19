#' Retrieves insider transactions data from eodhd
#'
#' This function queries the insider-transactions endpoint and returns
#' reported insider trades for a given ticker and date range.
#'
#' @inheritParams get_fundamentals
#' @param first_date Start date (default previous year).
#' @param last_date End date (default today).
#' @param limit Maximum number of results (default 100).
#'
#' @return A dataframe with insider transaction records
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_ins <- get_insider_transactions(ticker = "AAPL", exchange = "US")
#' }
get_insider_transactions <- function(ticker = "AAPL",
                                     exchange = "US",
                                     first_date = Sys.Date() - 365,
                                     last_date = Sys.Date(),
                                     limit = 100,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving insider transactions for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  cache_tag <- paste0("insider_", first_date, "_", last_date)
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/insider-transactions?',
           'code={ticker}.{exchange}&',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}&',
           'limit={limit}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no insider transactions found for {ticker}|{exchange}")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} insider transaction records")

  return(df_out)
}
