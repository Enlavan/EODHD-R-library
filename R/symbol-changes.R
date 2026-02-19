#' Retrieves symbol change history from eodhd
#'
#' This function queries the symbol-change-history endpoint and returns
#' a record of ticker symbol changes (renames, mergers, etc.).
#'
#' @param first_date Start date (default previous year).
#' @param last_date End date (default today).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with symbol change records
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_changes <- get_symbol_changes()
#' }
get_symbol_changes <- function(first_date = Sys.Date() - 365,
                               last_date = Sys.Date(),
                               cache_folder = get_default_cache(),
                               check_quota = TRUE) {

  cli::cli_h1("retrieving symbol change history")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  cache_tag <- paste0("symbol_changes_", first_date, "_", last_date)
  f_out <- get_cache_file("symbols", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    paste0('{get_base_url()}/symbol-change-history?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no symbol changes found")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} symbol change records")

  return(df_out)
}
