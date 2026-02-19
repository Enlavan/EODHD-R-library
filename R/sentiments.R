#' Retrieves sentiment data from eodhd
#'
#' This function queries the financial news sentiments endpoint and returns
#' aggregated sentiment scores for a given ticker and date range.
#'
#' @inheritParams get_fundamentals
#' @param first_date Start date for sentiments (default previous 30 days).
#' @param last_date End date for sentiments (default today).
#'
#' @return A dataframe with sentiment data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token(get_demo_token())
#' df_sent <- get_sentiments(ticker = "AAPL", exchange = "US")
#' }
get_sentiments <- function(ticker = "AAPL",
                           exchange = "US",
                           first_date = Sys.Date() - 30,
                           last_date = Sys.Date(),
                           cache_folder = get_default_cache(),
                           check_quota = TRUE) {

  cli::cli_h1("retrieving sentiments for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  cache_tag <- paste0("sentiments_", first_date, "_", last_date)
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/sentiments?',
           's={ticker}.{exchange}&',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (length(result) == 0) {
    cli::cli_alert_danger("no sentiment data found for {ticker}|{exchange}")
    return(dplyr::tibble())
  }

  if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    df_out <- dplyr::bind_rows(result)
  }

  if ("date" %in% names(df_out)) {
    df_out$date <- as.Date(df_out$date)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of sentiment data")

  return(df_out)
}
