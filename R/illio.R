#' Retrieves Illio best-and-worst data
#'
#' @param id Index identifier: one of \code{"SnP500"}, \code{"DJI"}, \code{"NDX"}.
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A named list with best-and-worst data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_best_and_worst("SnP500")
#' }
get_illio_best_and_worst <- function(id = "SnP500",
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving Illio best-and-worst for {id}")

  illio_query("chapters", "best-and-worst", id,
              cache_folder, check_quota)
}

#' Retrieves Illio beta bands data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with beta bands data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_beta_bands("SnP500")
#' }
get_illio_beta_bands <- function(id = "SnP500",
                                 cache_folder = get_default_cache(),
                                 check_quota = TRUE) {

  cli::cli_h1("retrieving Illio beta bands for {id}")

  illio_query("chapters", "beta-bands", id,
              cache_folder, check_quota)
}

#' Retrieves Illio volume data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with volume data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_volume("SnP500")
#' }
get_illio_volume <- function(id = "SnP500",
                             cache_folder = get_default_cache(),
                             check_quota = TRUE) {

  cli::cli_h1("retrieving Illio volume for {id}")

  illio_query("chapters", "volume", id,
              cache_folder, check_quota)
}

#' Retrieves Illio performance data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with performance data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_performance("SnP500")
#' }
get_illio_performance <- function(id = "SnP500",
                                  cache_folder = get_default_cache(),
                                  check_quota = TRUE) {

  cli::cli_h1("retrieving Illio performance for {id}")

  illio_query("chapters", "performance", id,
              cache_folder, check_quota)
}

#' Retrieves Illio risk data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with risk data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_risk("SnP500")
#' }
get_illio_risk <- function(id = "SnP500",
                           cache_folder = get_default_cache(),
                           check_quota = TRUE) {

  cli::cli_h1("retrieving Illio risk for {id}")

  illio_query("chapters", "risk", id,
              cache_folder, check_quota)
}

#' Retrieves Illio volatility data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with volatility data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_volatility("SnP500")
#' }
get_illio_volatility <- function(id = "SnP500",
                                 cache_folder = get_default_cache(),
                                 check_quota = TRUE) {

  cli::cli_h1("retrieving Illio volatility for {id}")

  illio_query("chapters", "volatility", id,
              cache_folder, check_quota)
}

#' Retrieves Illio category performance data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with category performance data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_category_performance("SnP500")
#' }
get_illio_category_performance <- function(id = "SnP500",
                                           cache_folder = get_default_cache(),
                                           check_quota = TRUE) {

  cli::cli_h1("retrieving Illio category performance for {id}")

  illio_query("categories", "performance", id,
              cache_folder, check_quota)
}

#' Retrieves Illio category risk data
#'
#' @inheritParams get_illio_best_and_worst
#'
#' @return A named list with category risk data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_illio_category_risk("SnP500")
#' }
get_illio_category_risk <- function(id = "SnP500",
                                    cache_folder = get_default_cache(),
                                    check_quota = TRUE) {

  cli::cli_h1("retrieving Illio category risk for {id}")

  illio_query("categories", "risk", id,
              cache_folder, check_quota)
}

#' Internal helper for Illio queries
#'
#' @noRd
illio_query <- function(category, type, id,
                        cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("illio_", category, "_", type, "_", id)
  f_out <- get_cache_file("illio", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    result <- read_cache(f_out)
    return(result)
  }

  url <- glue::glue(
    '{get_base_url()}/mp/illio/{category}/{type}/{id}?api_token={token}&fmt=json'
  )

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  write_cache(result, f_out)

  cli::cli_alert_success("got Illio {category}/{type} data for {id}")

  return(result)
}
