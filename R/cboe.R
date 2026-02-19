#' Retrieves CBOE index data from eodhd
#'
#' This function queries the CBOE index endpoint for historical
#' index data by index code.
#'
#' @param index_code The CBOE index code (e.g. \code{"VIX"}).
#' @param feed_type The data feed type (e.g. \code{"daily"}).
#' @param date Optional date to filter data (character or Date).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with CBOE index data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_vix <- get_cboe_index_data("VIX")
#' }
get_cboe_index_data <- function(index_code = "VIX",
                                feed_type = NULL,
                                date = NULL,
                                cache_folder = get_default_cache(),
                                check_quota = TRUE) {

  cli::cli_h1("retrieving CBOE index data for {index_code}")

  cache_tag <- paste0("cboe_index_", index_code)
  if (!is.null(date)) cache_tag <- paste0(cache_tag, "_", date)

  cboe_query(
    path = "cboe/index",
    params = list(index_code = index_code, feed_type = feed_type, date = date),
    cache_tag = cache_tag,
    cache_folder = cache_folder,
    check_quota = check_quota
  )
}

#' Retrieves list of CBOE indices from eodhd
#'
#' This function queries the CBOE indices list endpoint and returns
#' all available CBOE indices. Handles auto-pagination.
#'
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with CBOE indices
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_cboe_list <- get_cboe_indices_list()
#' }
get_cboe_indices_list <- function(cache_folder = get_default_cache(),
                                  check_quota = TRUE) {

  cli::cli_h1("retrieving CBOE indices list")

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("cboe", "indices", cache_folder, "cboe_indices_list")

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  all_data <- list()
  page <- 1
  url <- glue::glue(
    '{get_base_url()}/cboe/indices?api_token={token}&fmt=json'
  )

  while (!is.null(url) && url != "") {

    content <- query_api(url)
    result <- jsonlite::fromJSON(content)

    if (is.data.frame(result$data)) {
      all_data[[page]] <- result$data
    } else if (is.data.frame(result)) {
      all_data[[page]] <- result
      break
    } else {
      break
    }

    # follow pagination link
    next_url <- result$links$`next`
    if (is.null(next_url) || next_url == "") {
      break
    }
    url <- next_url
    page <- page + 1
  }

  if (length(all_data) == 0) {
    cli::cli_alert_danger("no CBOE indices found")
    return(dplyr::tibble())
  }

  df_out <- purrr::list_rbind(all_data)

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} CBOE indices")

  return(df_out)
}

#' Internal helper for CBOE queries
#'
#' @noRd
cboe_query <- function(path, params, cache_tag,
                       cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("cboe", "", cache_folder, cache_tag)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  query_str <- paste0("api_token=", token, "&fmt=json")
  for (nm in names(params)) {
    if (!is.null(params[[nm]])) {
      query_str <- paste0(query_str, "&", nm, "=", params[[nm]])
    }
  }

  url <- glue::glue('{get_base_url()}/{path}?{query_str}')

  content <- query_api(url)

  if (content == "[]") {
    cli::cli_alert_danger("no CBOE data found")
    return(dplyr::tibble())
  }

  result <- jsonlite::fromJSON(content)

  if (is.data.frame(result$data)) {
    df_out <- dplyr::as_tibble(result$data)
  } else if (is.data.frame(result)) {
    df_out <- dplyr::as_tibble(result)
  } else {
    df_out <- dplyr::as_tibble(result)
  }

  write_cache(df_out, f_out)

  cli::cli_alert_success("got {nrow(df_out)} CBOE data rows")

  return(df_out)
}
