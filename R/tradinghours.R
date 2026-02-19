#' Retrieves trading hours market list
#'
#' @param group Optional market group to filter by.
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with markets and their trading hours
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_markets <- get_tradinghours_markets()
#' }
get_tradinghours_markets <- function(group = NULL,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving trading hours markets")

  params <- list(group = group)
  cache_tag <- paste0("tradinghours_markets",
                       ifelse(is.null(group), "", paste0("_", group)))

  tradinghours_query("mp/tradinghours/markets", params, cache_tag,
                     cache_folder, check_quota)
}

#' Looks up markets by query string
#'
#' @param q A search query string.
#' @param group Optional market group to filter by.
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with matching markets
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_lookup <- get_tradinghours_lookup("NYSE")
#' }
get_tradinghours_lookup <- function(q,
                                    group = NULL,
                                    cache_folder = get_default_cache(),
                                    check_quota = TRUE) {

  cli::cli_h1("looking up trading hours for '{q}'")

  params <- list(q = q, group = group)
  cache_tag <- paste0("tradinghours_lookup_", q)

  tradinghours_query("mp/tradinghours/markets/lookup", params, cache_tag,
                     cache_folder, check_quota)
}

#' Retrieves trading hours details for a market
#'
#' @param fin_id A FinID identifying the market.
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A named list with market trading hours details
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' details <- get_tradinghours_details("US.NYSE")
#' }
get_tradinghours_details <- function(fin_id,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving trading hours details for {fin_id}")

  params <- list(fin_id = fin_id)
  cache_tag <- paste0("tradinghours_details_", fin_id)

  tradinghours_query("mp/tradinghours/markets/details", params, cache_tag,
                     cache_folder, check_quota)
}

#' Retrieves current trading status for a market
#'
#' @inheritParams get_tradinghours_details
#'
#' @return A named list with market status information
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' status <- get_tradinghours_status("US.NYSE")
#' }
get_tradinghours_status <- function(fin_id,
                                    cache_folder = get_default_cache(),
                                    check_quota = TRUE) {

  cli::cli_h1("retrieving trading status for {fin_id}")

  params <- list(fin_id = fin_id)
  cache_tag <- paste0("tradinghours_status_", fin_id)

  tradinghours_query("mp/tradinghours/markets/status", params, cache_tag,
                     cache_folder, check_quota)
}

#' Internal helper for TradingHours queries
#'
#' @noRd
tradinghours_query <- function(path, params, cache_name,
                               cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("tradinghours", "", cache_folder, cache_name)

  if (fs::file_exists(f_out)) {
    result <- read_cache(f_out)
    return(result)
  }

  query_str <- paste0("api_token=", token, "&fmt=json")
  for (nm in names(params)) {
    if (!is.null(params[[nm]])) {
      query_str <- paste0(query_str, "&", nm, "=", params[[nm]])
    }
  }

  url <- glue::glue('{get_base_url()}/{path}?{query_str}')

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no trading hours data found")
    return(dplyr::tibble())
  }

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result)) {
    result <- dplyr::as_tibble(result)
  }

  write_cache(result, f_out)

  if (is.data.frame(result)) {
    cli::cli_alert_success("got {nrow(result)} trading hours records")
  } else {
    cli::cli_alert_success("got trading hours data")
  }

  return(result)
}
