#' Retrieves US Treasury bill rates from eodhd
#'
#' @param filter_year Optional year to filter results (e.g. \code{2024}).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with Treasury bill rate data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_bills <- get_ust_bill_rates()
#' }
get_ust_bill_rates <- function(filter_year = NULL,
                               cache_folder = get_default_cache(),
                               check_quota = TRUE) {

  cli::cli_h1("retrieving US Treasury bill rates")

  ust_query("ust/bill-rates", "ust_bill_rates", filter_year,
            cache_folder, check_quota)
}

#' Retrieves US Treasury long-term rates from eodhd
#'
#' @inheritParams get_ust_bill_rates
#'
#' @return A dataframe with long-term Treasury rate data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_lt <- get_ust_long_term_rates()
#' }
get_ust_long_term_rates <- function(filter_year = NULL,
                                    cache_folder = get_default_cache(),
                                    check_quota = TRUE) {

  cli::cli_h1("retrieving US Treasury long-term rates")

  ust_query("ust/long-term-rates", "ust_long_term_rates", filter_year,
            cache_folder, check_quota)
}

#' Retrieves US Treasury yield curve rates from eodhd
#'
#' @inheritParams get_ust_bill_rates
#'
#' @return A dataframe with Treasury yield curve rate data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_yield <- get_ust_yield_rates()
#' }
get_ust_yield_rates <- function(filter_year = NULL,
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving US Treasury yield curve rates")

  ust_query("ust/yield-curve-rates", "ust_yield_rates", filter_year,
            cache_folder, check_quota)
}

#' Retrieves US Treasury real yield curve rates from eodhd
#'
#' @inheritParams get_ust_bill_rates
#'
#' @return A dataframe with Treasury real yield curve rate data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_real <- get_ust_real_yield_rates()
#' }
get_ust_real_yield_rates <- function(filter_year = NULL,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving US Treasury real yield curve rates")

  ust_query("ust/real-yield-curve-rates", "ust_real_yield_rates", filter_year,
            cache_folder, check_quota)
}

#' Internal helper for UST rate queries
#'
#' @noRd
ust_query <- function(path, cache_name, filter_year,
                      cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  year_str <- ifelse(is.null(filter_year), "ALL", as.character(filter_year))
  cache_tag <- paste0(cache_name, "_", year_str)
  f_out <- get_cache_file("ust", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  year_param <- ""
  if (!is.null(filter_year)) year_param <- paste0("&filter_year=", filter_year)

  url <- glue::glue(
    '{get_base_url()}/{path}?api_token={token}&fmt=json{year_param}'
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no UST rate data found")
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

  cli::cli_alert_success("got {nrow(df_out)} rows of UST rate data")

  return(df_out)
}
