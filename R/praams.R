#' Retrieves PRAAMS bank balance sheet data by ISIN
#'
#' @param isin An ISIN identifier (e.g. \code{"US0378331005"}).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A named list with balance sheet data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_bank_balance_sheet_isin("US0378331005")
#' }
get_praams_bank_balance_sheet_isin <- function(isin,
                                               cache_folder = get_default_cache(),
                                               check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS bank balance sheet for ISIN {isin}")

  praams_json_query(
    paste0("mp/praams/bank/balance_sheet/isin/", isin),
    isin, paste0("praams_bank_bs_isin_", isin),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS bank balance sheet data by ticker
#'
#' @param ticker A ticker symbol (e.g. \code{"AAPL"}).
#' @param exchange An exchange code (e.g. \code{"US"}).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A named list with balance sheet data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_bank_balance_sheet_ticker("AAPL", "US")
#' }
get_praams_bank_balance_sheet_ticker <- function(ticker,
                                                 exchange,
                                                 cache_folder = get_default_cache(),
                                                 check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS bank balance sheet for {ticker}.{exchange}")

  praams_json_query(
    paste0("mp/praams/bank/balance_sheet/ticker/", ticker, ".", exchange),
    paste0(ticker, ".", exchange),
    paste0("praams_bank_bs_ticker_", ticker, "_", exchange),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS bank income statement data by ISIN
#'
#' @inheritParams get_praams_bank_balance_sheet_isin
#'
#' @return A named list with income statement data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_bank_income_statement_isin("US0378331005")
#' }
get_praams_bank_income_statement_isin <- function(isin,
                                                  cache_folder = get_default_cache(),
                                                  check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS bank income statement for ISIN {isin}")

  praams_json_query(
    paste0("mp/praams/bank/income_statement/isin/", isin),
    isin, paste0("praams_bank_is_isin_", isin),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS bank income statement data by ticker
#'
#' @inheritParams get_praams_bank_balance_sheet_ticker
#'
#' @return A named list with income statement data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_bank_income_statement_ticker("AAPL", "US")
#' }
get_praams_bank_income_statement_ticker <- function(ticker,
                                                    exchange,
                                                    cache_folder = get_default_cache(),
                                                    check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS bank income statement for {ticker}.{exchange}")

  praams_json_query(
    paste0("mp/praams/bank/income_statement/ticker/", ticker, ".", exchange),
    paste0(ticker, ".", exchange),
    paste0("praams_bank_is_ticker_", ticker, "_", exchange),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS bond analysis data
#'
#' @inheritParams get_praams_bank_balance_sheet_isin
#'
#' @return A named list with bond analysis data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_bond_analysis("US0378331005")
#' }
get_praams_bond_analysis <- function(isin,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS bond analysis for {isin}")

  praams_json_query(
    paste0("mp/praams/analyse/bond/", isin),
    isin, paste0("praams_bond_analysis_", isin),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS equity analysis data by ISIN
#'
#' This endpoint also serves as the risk-scoring endpoint.
#'
#' @inheritParams get_praams_bank_balance_sheet_isin
#'
#' @return A named list with equity analysis data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_equity_analysis_isin("US0378331005")
#' }
get_praams_equity_analysis_isin <- function(isin,
                                            cache_folder = get_default_cache(),
                                            check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS equity analysis for ISIN {isin}")

  praams_json_query(
    paste0("mp/praams/analyse/equity/isin/", isin),
    isin, paste0("praams_equity_analysis_isin_", isin),
    cache_folder, check_quota
  )
}

#' Retrieves PRAAMS equity analysis data by ticker
#'
#' This endpoint also serves as the risk-scoring endpoint.
#'
#' @inheritParams get_praams_bank_balance_sheet_ticker
#'
#' @return A named list with equity analysis data
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' result <- get_praams_equity_analysis_ticker("AAPL", "US")
#' }
get_praams_equity_analysis_ticker <- function(ticker,
                                              exchange,
                                              cache_folder = get_default_cache(),
                                              check_quota = TRUE) {

  cli::cli_h1("retrieving PRAAMS equity analysis for {ticker}.{exchange}")

  praams_json_query(
    paste0("mp/praams/analyse/equity/ticker/", ticker, ".", exchange),
    paste0(ticker, ".", exchange),
    paste0("praams_equity_analysis_ticker_", ticker, "_", exchange),
    cache_folder, check_quota
  )
}

#' Downloads PRAAMS bond report as PDF
#'
#' @param isin An ISIN identifier.
#' @param email Email address for the report.
#' @param output_path File path to save the PDF. Defaults to a temporary file.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return The file path of the downloaded report (character string)
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' pdf_path <- get_praams_bond_report("US0378331005", "user@example.com")
#' }
get_praams_bond_report <- function(isin,
                                   email,
                                   output_path = tempfile(fileext = ".pdf"),
                                   check_quota = TRUE) {

  cli::cli_h1("downloading PRAAMS bond report for {isin}")

  praams_report_query(
    paste0("mp/praams/reports/bond/", isin),
    isin, email, output_path, check_quota
  )
}

#' Downloads PRAAMS equity report as PDF by ISIN
#'
#' @inheritParams get_praams_bond_report
#'
#' @return The file path of the downloaded report (character string)
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' pdf_path <- get_praams_equity_report_isin("US0378331005", "user@example.com")
#' }
get_praams_equity_report_isin <- function(isin,
                                          email,
                                          output_path = tempfile(fileext = ".pdf"),
                                          check_quota = TRUE) {

  cli::cli_h1("downloading PRAAMS equity report for ISIN {isin}")

  praams_report_query(
    paste0("mp/praams/reports/equity/isin/", isin),
    isin, email, output_path, check_quota
  )
}

#' Downloads PRAAMS equity report as PDF by ticker
#'
#' @param ticker A ticker symbol (e.g. \code{"AAPL"}).
#' @param exchange An exchange code (e.g. \code{"US"}).
#' @param email Email address for the report.
#' @param output_path File path to save the PDF. Defaults to a temporary file.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return The file path of the downloaded report (character string)
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' pdf_path <- get_praams_equity_report_ticker("AAPL", "US", "user@example.com")
#' }
get_praams_equity_report_ticker <- function(ticker,
                                            exchange,
                                            email,
                                            output_path = tempfile(fileext = ".pdf"),
                                            check_quota = TRUE) {

  cli::cli_h1("downloading PRAAMS equity report for {ticker}.{exchange}")

  praams_report_query(
    paste0("mp/praams/reports/equity/ticker/", ticker, ".", exchange),
    paste0(ticker, ".", exchange), email, output_path, check_quota
  )
}

#' Runs PRAAMS bond screener
#'
#' @param filters A named list of filter criteria.
#' @param skip Number of results to skip (default 0).
#' @param take Number of results to return (default 20).
#' @param cache_folder A local directory to store cache files.
#' @param check_quota A flag for whether to check the current quota status.
#'
#' @return A dataframe with bond screener results
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_bonds <- get_praams_bond_screener(filters = list())
#' }
get_praams_bond_screener <- function(filters = list(),
                                     skip = 0,
                                     take = 20,
                                     cache_folder = get_default_cache(),
                                     check_quota = TRUE) {

  cli::cli_h1("running PRAAMS bond screener")

  praams_screener_query(
    "mp/praams/explore/bond",
    body = list(filters = filters, skip = skip, take = take),
    cache_name = paste0("praams_bond_screener_", skip, "_", take),
    cache_folder = cache_folder,
    check_quota = check_quota
  )
}

#' Runs PRAAMS equity screener
#'
#' @inheritParams get_praams_bond_screener
#'
#' @return A dataframe with equity screener results
#' @export
#'
#' @examples
#' \dontrun{
#' set_token("YOUR_VALID_TOKEN")
#' df_equities <- get_praams_equity_screener(filters = list())
#' }
get_praams_equity_screener <- function(filters = list(),
                                       skip = 0,
                                       take = 20,
                                       cache_folder = get_default_cache(),
                                       check_quota = TRUE) {

  cli::cli_h1("running PRAAMS equity screener")

  praams_screener_query(
    "mp/praams/explore/equity",
    body = list(filters = filters, skip = skip, take = take),
    cache_name = paste0("praams_equity_screener_", skip, "_", take),
    cache_folder = cache_folder,
    check_quota = check_quota
  )
}

#' Internal helper for PRAAMS JSON queries
#'
#' @noRd
praams_json_query <- function(path, identifier, cache_name,
                              cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("praams", "", cache_folder, cache_name)

  if (fs::file_exists(f_out)) {
    result <- read_cache(f_out)
    return(result)
  }

  url <- glue::glue('{get_base_url()}/{path}?api_token={token}&fmt=json')

  content <- query_api(url)

  result <- jsonlite::fromJSON(content)

  write_cache(result, f_out)

  cli::cli_alert_success("got PRAAMS data for {identifier}")

  return(result)
}

#' Internal helper for PRAAMS binary report queries
#'
#' @noRd
praams_report_query <- function(path, identifier, email, output_path,
                                check_quota) {

  if (fs::file_exists(output_path)) {
    cli::cli_alert_info("report already exists at {output_path}")
    return(output_path)
  }

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  url <- glue::glue(
    '{get_base_url()}/{path}?api_token={token}&email={email}'
  )

  result <- query_api_binary(url, output_path)

  cli::cli_alert_success("PRAAMS report for {identifier} saved to {result}")

  return(result)
}

#' Internal helper for PRAAMS screener (POST) queries
#'
#' @noRd
praams_screener_query <- function(path, body, cache_name,
                                  cache_folder, check_quota) {

  if (check_quota) {
    get_quota_status()
  }

  token <- get_token()

  f_out <- get_cache_file("praams", "", cache_folder, cache_name)

  if (fs::file_exists(f_out)) {
    df_out <- read_cache(f_out)
    return(df_out)
  }

  url <- glue::glue('{get_base_url()}/{path}?api_token={token}')

  content <- query_api_post(url, body)

  if (content == "[]") {
    cli::cli_alert_danger("no PRAAMS screener results found")
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

  cli::cli_alert_success("got {nrow(df_out)} PRAAMS screener results")

  return(df_out)
}
