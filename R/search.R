#' Searches for financial instruments on eodhd
#'
#' This function queries the search endpoint and returns
#' matching tickers, names, and exchanges.
#'
#' @param query The search query string (e.g. \code{"Apple"}, \code{"AAPL"}).
#' @param limit Maximum number of results (default 20).
#' @param type Optional instrument type filter (\code{"stock"}, \code{"fund"},
#'   \code{"etf"}, \code{"index"}, \code{"crypto"}, \code{"bond"}, etc.).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with search results
#' @export
#'
#' @examples
#' \dontrun{
#' set_token(get_demo_token())
#' df_results <- get_search(query = "Apple")
#' }
get_search <- function(query,
                       limit = 20,
                       type = NULL,
                       cache_folder = get_default_cache(),
                       check_quota = TRUE) {

  cli::cli_h1("searching for '{query}'")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  query_clean <- gsub("[^a-zA-Z0-9]", "_", query)
  cache_tag <- paste0("search_", query_clean, "_", limit)
  f_out <- get_cache_file("search", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  type_param <- ""
  if (!is.null(type)) type_param <- paste0("&type=", type)

  url <- glue::glue(
    '{get_base_url()}/search/{query}?api_token={token}&fmt=json&limit={limit}{type_param}'
  )

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no results found for '{query}'")
    return(dplyr::tibble())
  }

  df_out <- jsonlite::fromJSON(content)

  if (!is.data.frame(df_out)) {
    df_out <- dplyr::as_tibble(df_out)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} search results")

  return(df_out)
}
