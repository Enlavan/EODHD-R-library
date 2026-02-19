#' Retrieves options contract data from eodhd
#'
#' This function queries the options contracts marketplace endpoint
#' and returns available options contracts for a given ticker.
#'
#' @inheritParams get_fundamentals
#' @param type Option type: \code{"call"} or \code{"put"}. If \code{NULL},
#'   returns both.
#' @param exp_date_from Earliest expiration date to include.
#' @param exp_date_to Latest expiration date to include.
#'
#' @return A dataframe with options contract data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_opts <- get_options(ticker = "AAPL", exchange = "US")
#' }
get_options <- function(ticker = "AAPL",
                        exchange = "US",
                        type = NULL,
                        exp_date_from = NULL,
                        exp_date_to = NULL,
                        cache_folder = get_default_cache(),
                        check_quota = TRUE) {

  cli::cli_h1("retrieving options data for {ticker}|{exchange}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- "options"
  f_out <- get_cache_file(ticker, exchange, cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  extra_params <- ""
  if (!is.null(type)) extra_params <- paste0(extra_params, "&type=", type)
  if (!is.null(exp_date_from)) extra_params <- paste0(extra_params, "&exp_date_from=", as.character(exp_date_from))
  if (!is.null(exp_date_to)) extra_params <- paste0(extra_params, "&exp_date_to=", as.character(exp_date_to))

  url <- glue::glue(
    '{get_base_url()}/mp/unicornbay/options/contracts?ticker={ticker}.{exchange}&api_token={token}&fmt=json{extra_params}'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$data)) {
    df_out <- dplyr::as_tibble(result$data)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("no options data found for {ticker}|{exchange}")
    return(dplyr::tibble())
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} options contracts")

  return(df_out)
}
