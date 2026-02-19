#' Retrieves technical indicator data from eodhd
#'
#' This function queries the technical indicator endpoint and returns
#' time-series data for a chosen indicator function.
#'
#' @inheritParams get_fundamentals
#' @param func The technical indicator function name (e.g. \code{"sma"},
#'   \code{"ema"}, \code{"rsi"}, \code{"macd"}, \code{"bbands"}, etc.).
#' @param period The period/window for the indicator (default 50).
#' @param from Start date for the data (character or Date).
#' @param to End date for the data (character or Date).
#'
#' @return A dataframe with technical indicator values
#' @export
#'
#' @examples
#' \dontrun{
#' set_token(get_demo_token())
#' df_sma <- get_technical(ticker = "AAPL", exchange = "US",
#'                         func = "sma", period = 50)
#' }
get_technical <- function(ticker = "AAPL",
                          exchange = "US",
                          func = "sma",
                          period = 50,
                          from = NULL,
                          to = NULL,
                          cache_folder = get_default_cache(),
                          check_quota = TRUE) {

  cli::cli_h1("retrieving technical indicator ({func}) for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("technical_", func, "_", period)
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  date_params <- ""
  if (!is.null(from)) date_params <- paste0(date_params, "&from=", as.character(from))
  if (!is.null(to))   date_params <- paste0(date_params, "&to=", as.character(to))

  url <- glue::glue(
    '{get_base_url()}/technical/{ticker}.{exchange}?api_token={token}&fmt=json&function={func}&period={period}{date_params}'
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no technical data found for {ticker}|{exchange} with func={func}")
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

  cli::cli_alert_success("got {nrow(df_out)} rows of technical data")

  return(df_out)
}
