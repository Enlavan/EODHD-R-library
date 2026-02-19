#' Retrieves user account details from eodhd
#'
#' This function queries the internal-user endpoint and returns
#' account information such as name, email, subscription and quota.
#'
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A named list with user account details
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' user_info <- get_user_details()
#' }
get_user_details <- function(check_quota = TRUE) {

  cli::cli_h1("retrieving user account details")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  url <- glue::glue('{get_base_url()}/user?api_token={token}')

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  cli::cli_alert_success("got user details for {result$name}")

  return(result)
}
