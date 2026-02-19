#' Retrieves bulk end-of-day data from eodhd
#'
#' This function queries the eod-bulk-last-day endpoint and returns
#' the last day's EOD prices for all symbols on a given exchange.
#'
#' @inheritParams get_fundamentals
#'
#' @return A dataframe with bulk EOD price data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_bulk <- get_bulk_eod(exchange = "US")
#' }
get_bulk_eod <- function(exchange = "US",
                         cache_folder = get_default_cache(),
                         check_quota = TRUE) {

  cli::cli_h1("retrieving bulk EOD data for {exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("bulk_eod", exchange, cache_folder, "bulk-eod")

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/eod-bulk-last-day/{exchange}?api_token={token}&fmt=json'
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no bulk EOD data found for {exchange}")
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

  cli::cli_alert_success("got {nrow(df_out)} rows of bulk EOD data")

  return(df_out)
}
