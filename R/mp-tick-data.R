#' Retrieves marketplace tick data from Unicorn Bay
#'
#' This function queries the Unicorn Bay marketplace tick data endpoint.
#'
#' @param symbol A ticker symbol (e.g. \code{"AAPL"}).
#' @param from Start date (\code{Date} or character in \code{YYYY-MM-DD} format).
#' @param to End date (\code{Date} or character in \code{YYYY-MM-DD} format).
#' @param limit Maximum number of ticks to return (default 1000).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with marketplace tick data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_mp_ticks <- get_mp_tick_data("AAPL",
#'                                  from = Sys.Date() - 1,
#'                                  to = Sys.Date())
#' }
get_mp_tick_data <- function(symbol = "AAPL",
                             from = Sys.Date() - 1,
                             to = Sys.Date(),
                             limit = 1000,
                             cache_folder = get_default_cache(),
                             check_quota = TRUE) {

  cli::cli_h1("retrieving marketplace tick data for {symbol}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("mp_ticks_", as.character(from), "_", as.character(to),
                       "_", limit)
  f_out <- get_cache_file(symbol, "MP", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  from_unix <- as.numeric(as.POSIXct(as.character(from), tz = "UTC"))
  to_unix <- as.numeric(as.POSIXct(paste0(as.character(to), " 23:59:59"),
                                     tz = "UTC"))

  url <- glue::glue(
    '{get_base_url()}/mp/unicornbay/tickdata/ticks?api_token={token}&fmt=json',
    '&s={symbol}&from={from_unix}&to={to_unix}&limit={limit}'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (length(result) == 0) {
    cli::cli_alert_danger("no marketplace tick data found for {symbol}")
    return(dplyr::tibble())
  }

  df_out <- dplyr::as_tibble(result)

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} marketplace tick records")

  return(df_out)
}
