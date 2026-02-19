#' Retrieves earnings trends data from eodhd
#'
#' This function queries the calendar/trends endpoint and returns
#' earnings trend / estimate data for the given symbols.
#'
#' @param symbols A comma-separated string of ticker symbols (e.g. \code{"AAPL.US,MSFT.US"}).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with earnings trends
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_trends <- get_earnings_trends(symbols = "AAPL.US")
#' }
get_earnings_trends <- function(symbols = "AAPL.US",
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving earnings trends for {symbols}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  sym_str <- gsub("[^a-zA-Z0-9]", "_", symbols)
  cache_tag <- paste0("earnings_trends_", sym_str)
  f_out <- get_cache_file("calendar", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/calendar/trends?symbols={symbols}&api_token={token}&fmt=json'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$trends)) {
    df_out <- dplyr::as_tibble(result$trends)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("no earnings trends found for {symbols}")
    return(dplyr::tibble())
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} earnings trend records")

  return(df_out)
}
