#' Retrieves upcoming splits calendar from eodhd
#'
#' This function queries the calendar/splits endpoint and returns
#' upcoming and recent stock split events.
#'
#' @param symbols A comma-separated string of ticker symbols (e.g. \code{"AAPL.US"}).
#'   If \code{NULL}, returns broad calendar data.
#' @param first_date Start date (default previous 30 days).
#' @param last_date End date (default 30 days from now).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with upcoming splits
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_splits <- get_upcoming_splits()
#' }
get_upcoming_splits <- function(symbols = NULL,
                                first_date = Sys.Date() - 30,
                                last_date = Sys.Date() + 30,
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving upcoming splits calendar")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  sym_str <- ifelse(is.null(symbols), "ALL", gsub("[^a-zA-Z0-9]", "_", symbols))
  cache_tag <- paste0("upcoming_splits_", sym_str, "_", first_date, "_", last_date)
  f_out <- get_cache_file("calendar", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  sym_param <- ""
  if (!is.null(symbols)) sym_param <- paste0("&symbols=", symbols)

  url <- glue::glue(
    paste0('{get_base_url()}/calendar/splits?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}',
           '{sym_param}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$splits)) {
    df_out <- dplyr::as_tibble(result$splits)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("no upcoming splits found")
    return(dplyr::tibble())
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} upcoming split records")

  return(df_out)
}
