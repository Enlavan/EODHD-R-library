#' Retrieves S&P Global indices list from Unicorn Bay
#'
#' This function queries the Unicorn Bay S&P Global list endpoint
#' and returns available indices.
#'
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with indices
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_indices <- get_indices_list()
#' }
get_indices_list <- function(cache_folder = get_default_cache(),
                             check_quota = TRUE) {

  cli::cli_h1("retrieving S&P Global indices list")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("spglobal", "list", cache_folder, "indices_list")

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue(
    '{get_base_url()}/mp/unicornbay/spglobal/list?api_token={token}&fmt=json'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (length(result) == 0) {
    cli::cli_alert_danger("no indices found")
    return(dplyr::tibble())
  }

  df_out <- dplyr::as_tibble(result)

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} indices")

  return(df_out)
}
