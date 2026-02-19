#' Low level (unexported) function for retrieving data from API
#'
#' @param url A well formed url
#'
#' @return a content (txt) object
#'
#' @noRd
query_api <- function(url) {

  response <- httr::GET(url)
  parse_status_code(response$status_code)

  content <- httr::content(response, "text",
                           encoding = "UTF-8")

  return(content)

}

#' Low level function for downloading binary content from API
#'
#' @param url A well formed url
#' @param output_path File path to write the binary content to
#'
#' @return The output_path on success
#'
#' @noRd
query_api_binary <- function(url, output_path) {

  response <- httr::GET(url, httr::write_disk(output_path, overwrite = TRUE))
  parse_status_code(response$status_code)

  return(output_path)

}

#' Low level function for POST requests to API
#'
#' @param url A well formed url
#' @param body A list to be serialized as JSON body
#'
#' @return a content (txt) object
#'
#' @noRd
query_api_post <- function(url, body) {

  json_body <- jsonlite::toJSON(body, auto_unbox = TRUE)

  response <- httr::POST(
    url,
    httr::content_type_json(),
    body = json_body
  )
  parse_status_code(response$status_code)

  content <- httr::content(response, "text",
                           encoding = "UTF-8")

  return(content)

}

#' base url for eodhd
#'
#' @noRd
get_base_url <- function() {

  base_url <- "https://eodhd.com/api"

  return(base_url)

}
