#' Retrieves real-time / delayed stock prices
#'
#' This function queries the real-time endpoint of eodhd and returns
#' the latest price data for a given ticker and optionally extra symbols.
#'
#' @inheritParams get_fundamentals
#' @param extra_symbols Optional character vector of additional tickers
#'   (e.g. \code{c("MSFT.US", "GOOG.US")}). When supplied, prices for all
#'   symbols are returned in one call.
#'
#' @return A dataframe with real-time price data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token(get_demo_token())
#' df_rt <- get_live_prices(ticker = "AAPL", exchange = "US")
#' }
get_live_prices <- function(ticker = "AAPL",
                            exchange = "US",
                            extra_symbols = NULL,
                            cache_folder = get_default_cache(),
                            check_quota = TRUE) {

  cli::cli_h1("retrieving real-time prices for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file(ticker, exchange, cache_folder, "live-prices")

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  extra_param <- ""
  if (!is.null(extra_symbols)) {
    extra_param <- paste0("&s=", paste(extra_symbols, collapse = ","))
  }

  url <- glue::glue(
    '{get_base_url()}/real-time/{ticker}.{exchange}?api_token={token}&fmt=json{extra_param}'
  )

  content <- query_api(url)
  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result)) {
    df_out <- result
  } else {
    df_out <- dplyr::as_tibble(as.data.frame(t(unlist(result)), stringsAsFactors = FALSE))
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of live price data")

  return(df_out)
}
