#' Retrieves exchange details from eodhd
#'
#' This function queries the exchange-details endpoint and returns
#' detailed information about a specific exchange including trading hours,
#' holidays, and more.
#'
#' @inheritParams get_fundamentals
#'
#' @return A list with exchange detail information
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' l_details <- get_exchange_details(exchange = "US")
#' }
get_exchange_details <- function(exchange = "US",
                                 cache_folder = get_default_cache(),
                                 check_quota = TRUE) {

  cli::cli_h1("retrieving exchange details for {exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("exchange", exchange, cache_folder, "exchange-details")

  if (fs::file_exists(f_out)) {
    l_out <- read_cache(f_out)
    return(l_out)
  }

  url <- glue::glue(
    '{get_base_url()}/exchange-details/{exchange}?api_token={token}&fmt=json'
  )

  content <- query_api(url)
  l_out <- jsonlite::fromJSON(content)

  write_cache(l_out, f_out)

  cli::cli_alert_success("got exchange details for {exchange}")

  return(l_out)
}
