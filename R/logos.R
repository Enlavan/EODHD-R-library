#' Downloads a company logo image from eodhd
#'
#' Downloads the PNG logo for a given symbol and saves it to disk.
#'
#' @param symbol A ticker symbol with exchange suffix (e.g. \code{"AAPL.US"}).
#' @param output_path File path to save the logo. Defaults to a temporary file.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return The file path of the downloaded logo (character string)
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' logo_path <- get_logo("AAPL.US")
#' }
get_logo <- function(symbol = "AAPL.US",
                     output_path = tempfile(fileext = ".png"),
                     check_quota = TRUE) {

  cli::cli_h1("downloading logo for {symbol}")

  if (fs::file_exists(output_path)) {
    cli::cli_alert_info("logo already exists at {output_path}")
    return(output_path)
  }

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  url <- glue::glue('{get_base_url()}/logo/{symbol}?api_token={token}')

  result <- query_api_binary(url, output_path)

  cli::cli_alert_success("logo saved to {result}")

  return(result)
}

#' Downloads a company logo in SVG format from eodhd
#'
#' Downloads the SVG logo for a given symbol and saves it to disk.
#'
#' @param symbol A ticker symbol with exchange suffix (e.g. \code{"AAPL.US"}).
#' @param output_path File path to save the logo. Defaults to a temporary file.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return The file path of the downloaded logo (character string)
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' logo_path <- get_logo_svg("AAPL.US")
#' }
get_logo_svg <- function(symbol = "AAPL.US",
                         output_path = tempfile(fileext = ".svg"),
                         check_quota = TRUE) {

  cli::cli_h1("downloading SVG logo for {symbol}")

  if (fs::file_exists(output_path)) {
    cli::cli_alert_info("logo already exists at {output_path}")
    return(output_path)
  }

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  url <- glue::glue('{get_base_url()}/logo-svg/{symbol}?api_token={token}')

  result <- query_api_binary(url, output_path)

  cli::cli_alert_success("SVG logo saved to {result}")

  return(result)
}
