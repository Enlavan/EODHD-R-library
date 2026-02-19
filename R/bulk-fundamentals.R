#' Retrieves bulk fundamental data from eodhd
#'
#' This function queries the bulk-fundamentals endpoint and returns
#' fundamental data for multiple symbols from a given exchange in one call.
#'
#' @inheritParams get_fundamentals
#' @param symbols Optional comma-separated string of symbols to filter.
#' @param limit Maximum number of results (default 500).
#' @param offset Number of results to skip for pagination (default 0).
#'
#' @return A list or dataframe with bulk fundamental data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' l_bulk <- get_bulk_fundamentals(exchange = "US", limit = 10)
#' }
get_bulk_fundamentals <- function(exchange = "US",
                                  symbols = NULL,
                                  limit = 500,
                                  offset = 0,
                                  cache_folder = get_default_cache(),
                                  check_quota = TRUE) {

  cli::cli_h1("retrieving bulk fundamentals for {exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("bulk_fund_", limit, "_", offset)
  f_out <- get_cache_file("bulk", exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    l_out <- read_cache(f_out)
    return(l_out)
  }

  params <- paste0("api_token=", token, "&fmt=json",
                   "&limit=", limit,
                   "&offset=", offset)
  if (!is.null(symbols)) params <- paste0(params, "&symbols=", symbols)

  url <- glue::glue('{get_base_url()}/bulk-fundamentals/{exchange}?{params}')

  content <- query_api(url)
  l_out <- jsonlite::fromJSON(content)

  write_cache(l_out, f_out)

  if (is.data.frame(l_out)) {
    cli::cli_alert_success("got {nrow(l_out)} rows of bulk fundamental data")
  } else {
    cli::cli_alert_success("got {length(l_out)} elements of bulk fundamental data")
  }

  return(l_out)
}
