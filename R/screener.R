#' Retrieves stock screener results from eodhd
#'
#' This function queries the stock screener endpoint and returns
#' stocks matching the supplied filter criteria.
#'
#' @param filters A named list of filter criteria to pass as JSON body
#'   (e.g. \code{list(market_capitalization_morningstar = list(gte = 1e9))}).
#'   See the EODHD screener API docs for available filters.
#' @param sort Column name to sort results by (e.g. \code{"market_capitalization"}).
#' @param order Sort order: \code{"asc"} or \code{"desc"} (default \code{"desc"}).
#' @param limit Maximum number of results to return (default 100).
#' @param offset Number of results to skip for pagination (default 0).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with screener results
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_screen <- get_screener(
#'   sort = "market_capitalization",
#'   limit = 10
#' )
#' }
get_screener <- function(filters = NULL,
                         sort = NULL,
                         order = "desc",
                         limit = 100,
                         offset = 0,
                         cache_folder = get_default_cache(),
                         check_quota = TRUE) {

  cli::cli_h1("retrieving screener results")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  cache_tag <- paste0("screener_", limit, "_", offset)
  f_out <- get_cache_file("screener", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  params <- paste0("api_token=", token, "&fmt=json",
                   "&limit=", limit,
                   "&offset=", offset)
  if (!is.null(sort))  params <- paste0(params, "&sort=", sort)
  if (!is.null(order)) params <- paste0(params, "&order=", order)
  if (!is.null(filters)) params <- paste0(params, "&filters=", jsonlite::toJSON(filters, auto_unbox = TRUE))

  url <- glue::glue('{get_base_url()}/screener?{params}')

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$data)) {
    df_out <- dplyr::as_tibble(result$data)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    cli::cli_alert_danger("unexpected screener response format")
    return(dplyr::tibble())
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} screener results")

  return(df_out)
}
