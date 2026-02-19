#' Retrieves US delayed quote data from eodhd
#'
#' This function queries the us-quote-delayed endpoint and returns
#' delayed quote data for one or more US symbols.
#'
#' @param symbols A comma-separated string of ticker symbols
#'   (e.g. \code{"AAPL.US,MSFT.US"}).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with delayed US quote data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_quote <- get_us_quote(symbols = "AAPL.US,MSFT.US")
#' }
get_us_quote <- function(symbols = "AAPL.US",
                         cache_folder = get_default_cache(),
                         check_quota = TRUE) {

  cli::cli_h1("retrieving US delayed quotes for {symbols}")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  sym_str <- gsub("[^a-zA-Z0-9]", "_", symbols)
  cache_tag <- paste0("us_quote_", sym_str)
  f_out <- get_cache_file("quote", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/us-quote-delayed?s={symbols}&api_token={token}&fmt=json'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else if (!is.null(result$data) && is.data.frame(result$data)) {
    df_out <- dplyr::as_tibble(result$data)
  } else {
    df_out <- dplyr::as_tibble(as.data.frame(t(unlist(result)), stringsAsFactors = FALSE))
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} rows of US quote data")

  return(df_out)
}
