#' Retrieves ESG company list from Investverte
#'
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with ESG companies
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_companies <- get_esg_companies()
#' }
get_esg_companies <- function(cache_folder = get_default_cache(),
                              check_quota = TRUE) {

  cli::cli_h1("retrieving ESG company list")

  esg_query("mp/investverte/companies", "esg_companies",
            cache_folder, check_quota)
}

#' Retrieves ESG country list from Investverte
#'
#' @inheritParams get_esg_companies
#'
#' @return A dataframe with ESG countries
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_countries <- get_esg_countries()
#' }
get_esg_countries <- function(cache_folder = get_default_cache(),
                              check_quota = TRUE) {

  cli::cli_h1("retrieving ESG country list")

  esg_query("mp/investverte/countries", "esg_countries",
            cache_folder, check_quota)
}

#' Retrieves ESG sector list from Investverte
#'
#' @inheritParams get_esg_companies
#'
#' @return A dataframe with ESG sectors
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_sectors <- get_esg_sectors()
#' }
get_esg_sectors <- function(cache_folder = get_default_cache(),
                            check_quota = TRUE) {

  cli::cli_h1("retrieving ESG sector list")

  esg_query("mp/investverte/sectors", "esg_sectors",
            cache_folder, check_quota)
}

#' Retrieves ESG data for a specific company from Investverte
#'
#' @param symbol A ticker symbol (e.g. \code{"AAPL.US"}).
#' @param year Optional year to filter results.
#' @param frequency Optional frequency (\code{"annual"} or \code{"quarterly"}).
#' @inheritParams get_esg_companies
#'
#' @return A dataframe with ESG data for the company
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_esg <- get_esg_company("AAPL.US")
#' }
get_esg_company <- function(symbol = "AAPL.US",
                            year = NULL,
                            frequency = NULL,
                            cache_folder = get_default_cache(),
                            check_quota = TRUE) {

  cli::cli_h1("retrieving ESG data for {symbol}")

  extra_params <- list(year = year, frequency = frequency)
  cache_tag <- paste0("esg_company_", symbol)

  esg_query(paste0("mp/investverte/esg/", symbol), cache_tag,
            cache_folder, check_quota, extra_params = extra_params)
}

#' Retrieves ESG data for a specific country from Investverte
#'
#' @param symbol A country code (e.g. \code{"US"}).
#' @param year Optional year to filter results.
#' @param frequency Optional frequency.
#' @inheritParams get_esg_companies
#'
#' @return A dataframe with ESG country data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_esg_country <- get_esg_country("US")
#' }
get_esg_country <- function(symbol = "US",
                            year = NULL,
                            frequency = NULL,
                            cache_folder = get_default_cache(),
                            check_quota = TRUE) {

  cli::cli_h1("retrieving ESG country data for {symbol}")

  extra_params <- list(year = year, frequency = frequency)
  cache_tag <- paste0("esg_country_", symbol)

  esg_query(paste0("mp/investverte/country/", symbol), cache_tag,
            cache_folder, check_quota, extra_params = extra_params)
}

#' Retrieves ESG data for a specific sector from Investverte
#'
#' @param symbol A sector identifier.
#' @inheritParams get_esg_companies
#'
#' @return A dataframe with ESG sector data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_esg_sector <- get_esg_sector("Technology")
#' }
get_esg_sector <- function(symbol,
                           cache_folder = get_default_cache(),
                           check_quota = TRUE) {

  cli::cli_h1("retrieving ESG sector data for {symbol}")

  cache_tag <- paste0("esg_sector_", symbol)

  esg_query(paste0("mp/investverte/sector/", symbol), cache_tag,
            cache_folder, check_quota)
}

#' Internal helper for ESG queries
#'
#' @noRd
esg_query <- function(path, cache_name,
                      cache_folder, check_quota,
                      extra_params = list()) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("esg", "", cache_folder, cache_name)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  query_str <- paste0("api_token=", token, "&fmt=json")
  for (nm in names(extra_params)) {
    if (!is.null(extra_params[[nm]])) {
      query_str <- paste0(query_str, "&", nm, "=", extra_params[[nm]])
    }
  }

  url <- glue::glue('{get_base_url()}/{path}?{query_str}')

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no ESG data found")
    return(dplyr::tibble())
  }

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else if (!is.null(result$data) && is.data.frame(result$data)) {
    df_out <- dplyr::as_tibble(result$data)
  } else {
    df_out <- dplyr::as_tibble(result)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of ESG data")

  return(df_out)
}
