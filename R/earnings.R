#' Retrieves earnings calendar data from eodhd
#'
#' This function queries the calendar/earnings endpoint and returns
#' upcoming and historical earnings announcements.
#'
#' @param symbols A comma-separated string of ticker symbols (e.g. \code{"AAPL.US,MSFT.US"}).
#'   If \code{NULL}, returns broad calendar data.
#' @param first_date Start date (default previous 30 days).
#' @param last_date End date (default today).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with earnings data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_earn <- get_earnings(symbols = "AAPL.US")
#' }
get_earnings <- function(symbols = NULL,
                         first_date = Sys.Date() - 30,
                         last_date = Sys.Date(),
                         cache_folder = get_default_cache(),
                         check_quota = TRUE) {

  cli::cli_h1("retrieving earnings calendar")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  sym_str <- ifelse(is.null(symbols), "ALL", gsub("[^a-zA-Z0-9]", "_", symbols))
  cache_tag <- paste0("earnings_", sym_str, "_", first_date, "_", last_date)
  f_out <- get_cache_file("calendar", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  sym_param <- ""
  if (!is.null(symbols)) sym_param <- paste0("&symbols=", symbols)

  url <- glue::glue(
    paste0('{get_base_url()}/calendar/earnings?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}',
           '{sym_param}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$earnings)) {
    df_out <- dplyr::as_tibble(result$earnings)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("no earnings data found")
    return(dplyr::tibble())
  }

  if ("report_date" %in% names(df_out)) {
    df_out$report_date <- as.Date(df_out$report_date)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} earnings records")

  return(df_out)
}
