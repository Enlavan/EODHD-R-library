#' Retrieves upcoming dividends calendar from eodhd
#'
#' This function queries the calendar/dividends endpoint and returns
#' upcoming and recent dividend events.
#'
#' @inheritParams get_fundamentals
#' @param first_date Start date (default previous 30 days).
#' @param last_date End date (default 30 days from now).
#'
#' @return A dataframe with upcoming dividends
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_divs <- get_upcoming_dividends()
#' }
get_upcoming_dividends <- function(ticker = NULL,
                                   exchange = NULL,
                                   first_date = Sys.Date() - 30,
                                   last_date = Sys.Date() + 30,
                                   cache_folder = get_default_cache(),
                                   check_quota = TRUE) {

  cli::cli_h1("retrieving upcoming dividends calendar")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  ticker_str <- ifelse(is.null(ticker), "ALL", ticker)
  exchange_str <- ifelse(is.null(exchange), "", exchange)
  cache_tag <- paste0("upcoming_dividends_", ticker_str, "_", first_date, "_", last_date)
  f_out <- get_cache_file(ticker_str, exchange_str, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  sym_param <- ""
  if (!is.null(ticker) && !is.null(exchange)) {
    sym_param <- paste0("&symbols=", ticker, ".", exchange)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/calendar/dividends?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}',
           '{sym_param}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$dividends)) {
    df_out <- dplyr::as_tibble(result$dividends)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("no upcoming dividends found")
    return(dplyr::tibble())
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} upcoming dividend records")

  return(df_out)
}
