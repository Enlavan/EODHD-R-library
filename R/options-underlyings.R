#' Retrieves options underlying symbols from Unicorn Bay
#'
#' This function queries the Unicorn Bay options underlying symbols endpoint
#' and returns available option underlying symbols.
#'
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with underlying symbols
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_underlyings <- get_options_underlyings()
#' }
get_options_underlyings <- function(cache_folder = get_default_cache(),
                                    check_quota = TRUE) {

  cli::cli_h1("retrieving options underlying symbols")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("options", "underlyings", cache_folder,
                           "options_underlyings")

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/mp/unicornbay/options/underlying-symbols?api_token={token}&fmt=json'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.null(result$data)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    df_out <- dplyr::as_tibble(result$data)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} underlying symbols")

  return(df_out)
}
