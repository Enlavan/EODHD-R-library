#' Retrieves economic events calendar from eodhd
#'
#' This function queries the economic-events endpoint and returns
#' scheduled economic events (e.g. GDP releases, CPI, employment data)
#' for a given country and date range.
#'
#' @param country A two-letter ISO country code (e.g. \code{"US"}, \code{"GB"}).
#'   If \code{NULL}, all countries are returned.
#' @param first_date Start date (default previous 30 days).
#' @param last_date End date (default today).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with economic events
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_events <- get_economic_events(country = "US")
#' }
get_economic_events <- function(country = "US",
                                first_date = Sys.Date() - 30,
                                last_date = Sys.Date(),
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving economic events")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  first_date <- as.Date(first_date)
  last_date <- as.Date(last_date)

  country_str <- ifelse(is.null(country), "ALL", country)
  cache_tag <- paste0("econ_events_", country_str, "_", first_date, "_", last_date)
  f_out <- get_cache_file("econ", country_str, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  country_param <- ""
  if (!is.null(country)) country_param <- paste0("&country=", country)

  url <- glue::glue(
    paste0('{get_base_url()}/economic-events?',
           'from={as.character(first_date)}&',
           'to={as.character(last_date)}',
           '{country_param}&',
           'api_token={token}&fmt=json')
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no economic events found")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} economic events")

  return(df_out)
}
