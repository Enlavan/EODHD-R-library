#' Retrieves macro indicator data from eodhd
#'
#' This function queries the macro-indicator endpoint and returns
#' macroeconomic time-series for a given country and indicator.
#'
#' @param country A three-letter ISO country code (e.g. \code{"USA"}, \code{"GBR"}).
#' @param indicator The indicator code (e.g. \code{"gdp_current_usd"},
#'   \code{"inflation_consumer_prices_annual"}). See EODHD docs for full list.
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with macro indicator values
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_gdp <- get_macro_indicator(country = "USA", indicator = "gdp_current_usd")
#' }
get_macro_indicator <- function(country = "USA",
                                indicator = "gdp_current_usd",
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving macro indicator ({indicator}) for {country}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("macro_", indicator)
  f_out <- get_cache_file(country, "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/macro-indicator/{country}?api_token={token}&fmt=json&indicator={indicator}'
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no macro data found for {country}/{indicator}")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of macro data")

  return(df_out)
}
