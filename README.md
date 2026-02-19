
<!-- README.md is generated from README.Rmd. Please edit that file -->

# About eodhdR2

![](inst/extdata/figs/website-eodhd.png)

<!-- badges: start -->

[![R-CMD-check](https://github.com/EodHistoricalData/R-Library-for-financial-data-2024/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/EodHistoricalData/R-Library-for-financial-data-2024/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

[eodhd](https://eodhd.com/) is a private company that offers APIs to a
set of comprehensive and high quality financial data for over 70+
exchanges across the world. This includes:

- Adjusted and unadjusted prices of financial contracts (equity, funds,
  ETF, cryptocurrencies, ..)
- Financial information of companies (Balance Sheet, Income/Cashflow
  statement)
- Valuation indicators
- Technical indicators
- Macro-economic data
- Insider transactions
- And [more](https://eodhd.com/)..

Package eodhdR2 is the second and backwards incompatible version of
[eodhd](https://github.com/EodHistoricalData/EODHD-APIs-R-Financial-Library),
allowing fast and intelligent access to most of the API's endpoints.

# Features

- A local caching system that saves all API queries to the disk,
  improving execution time and reducing api calls on repeated queries.
- A quota management system, informing the user of how much of the API
  daily quota was used and how much time is left to refresh it.
- Function for aggregating and organizing financial information into a
  single dataframe, allowing easier access to clean financial data in
  the [wide or long
  format](https://libguides.princeton.edu/R-reshape#:~:text=A%20dataset%20can%20be%20written,repeat%20in%20the%20first%20column.&text=We%20can%20see%20that%20in,value%20in%20the%20first%20column).

# Installation

``` r
# available in CRAN
install.packages("eodhdR2")

# development version
devtools::install_github("EodHistoricalData/R-Library-for-financial-data-2024")
```

# Usage

## Authentication

After registering in the [eodhd website](https://eodhd.com/) and
choosing a subscription, all users will authenticate an R session using
a token from the website. For that:

1)  Create an account at <https://eodhd.com/>
2)  Go in "Settings" and look for your API token

![](inst/extdata/figs/token.png)

While using `eodhdR2`, all authentications are managed with function
`eodhdR2::set_token()`:

``` r
eodhdR2::set_token("YOUR_TOKEN")
```

Alternatively, while testing the API, you can use the "demo" token for
demonstration.

``` r
token <- eodhdR2::get_demo_token()
eodhdR2::set_token(token)
```

# Examples

## Retrieving Financial Prices

``` r
ticker <- "AAPL"
exchange <- "US"

df_prices <- eodhdR2::get_prices(ticker, exchange)
head(df_prices)
```

## Retrieving Dividends

``` r
df_div <- eodhdR2::get_dividends("AAPL", "US")
head(df_div)
```

## Retrieving Stock Splits

``` r
# requires a paid token
df_splits <- eodhdR2::get_splits(ticker = "AAPL", exchange = "US")
```

## Retrieving Fundamentals

``` r
l_fun <- eodhdR2::get_fundamentals("AAPL", "US")
names(l_fun)
```

## Parsing Financials

``` r
# wide format
wide_financials <- eodhdR2::parse_financials(l_fun, "wide")
head(wide_financials)

# long format
long_financials <- eodhdR2::parse_financials(l_fun, "long")
head(long_financials)
```

## Live / Real-Time Prices

``` r
df_rt <- eodhdR2::get_live_prices(ticker = "AAPL", exchange = "US")
df_rt
```

## Technical Indicators

``` r
df_sma <- eodhdR2::get_technical(ticker = "AAPL", exchange = "US",
                                  func = "sma", period = 50)
head(df_sma)
```

## Stock Screener

``` r
# requires a paid token
df_screen <- eodhdR2::get_screener(sort = "market_capitalization", limit = 10)
head(df_screen)
```

## Sentiments

``` r
df_sent <- eodhdR2::get_sentiments(ticker = "AAPL", exchange = "US")
head(df_sent)
```

## News

``` r
df_news <- eodhdR2::get_news(ticker = "AAPL", exchange = "US")
head(df_news)
```

## News Word Weights

``` r
# requires a paid token
df_words <- eodhdR2::get_news_word_weights(ticker = "AAPL", exchange = "US")
head(df_words)
```

## Macro Indicators

``` r
# requires a paid token
df_gdp <- eodhdR2::get_macro_indicator(country = "USA", indicator = "gdp_current_usd")
head(df_gdp)
```

## Calendar: Earnings

``` r
# requires a paid token
df_earnings <- eodhdR2::get_earnings(symbols = "AAPL.US")
head(df_earnings)
```

## Calendar: Earnings Trends

``` r
# requires a paid token
df_trends <- eodhdR2::get_earnings_trends(symbols = "AAPL.US")
head(df_trends)
```

## Calendar: Upcoming Splits

``` r
# requires a paid token
df_upcoming_splits <- eodhdR2::get_upcoming_splits()
head(df_upcoming_splits)
```

## Calendar: Upcoming Dividends

``` r
# requires a paid token
df_upcoming_divs <- eodhdR2::get_upcoming_dividends()
head(df_upcoming_divs)
```

## Calendar: IPOs

``` r
# requires a paid token
df_ipos <- eodhdR2::get_ipos()
head(df_ipos)
```

## Insider Transactions

``` r
# requires a paid token
df_insider <- eodhdR2::get_insider_transactions(ticker = "AAPL", exchange = "US")
head(df_insider)
```

## Economic Events

``` r
# requires a paid token
df_events <- eodhdR2::get_economic_events(country = "US")
head(df_events)
```

## Exchange Details

``` r
# requires a paid token
l_details <- eodhdR2::get_exchange_details(exchange = "US")
str(l_details, max.level = 1)
```

## Exchange List

``` r
# requires a paid token
df_exchanges <- eodhdR2::get_exchanges()
head(df_exchanges)
```

## Ticker List

``` r
# requires a paid token
df_tickers <- eodhdR2::get_tickers(exchange = "US")
head(df_tickers)
```

## Bulk Data: End-of-Day

``` r
# requires a paid token
df_bulk_eod <- eodhdR2::get_bulk_eod(exchange = "US")
head(df_bulk_eod)
```

## Bulk Data: Fundamentals

``` r
# requires a paid token
l_bulk_fund <- eodhdR2::get_bulk_fundamentals(exchange = "US", limit = 10)
```

## Intraday Prices

``` r
df_intraday <- eodhdR2::get_intraday(ticker = "AAPL", exchange = "US")
head(df_intraday)
```

## Index Composition

``` r
# requires a paid token
l_index <- eodhdR2::get_index_composition("GSPC.INDX")
str(l_index, max.level = 1)
```

## Search

``` r
df_results <- eodhdR2::get_search(query = "Apple", limit = 10)
head(df_results)
```

## Historical Market Capitalization

``` r
# requires a paid token
df_mcap <- eodhdR2::get_market_cap(ticker = "AAPL", exchange = "US")
head(df_mcap)
```

## Symbol Change History

``` r
# requires a paid token
df_changes <- eodhdR2::get_symbol_changes()
head(df_changes)
```

## US Delayed Quotes

``` r
# requires a paid token
df_quote <- eodhdR2::get_us_quote(symbols = "AAPL.US,MSFT.US")
head(df_quote)
```

## Options Contracts

``` r
# requires a paid token
df_opts <- eodhdR2::get_options(ticker = "AAPL", exchange = "US")
head(df_opts)
```

## US Treasury Rates

``` r
# requires a paid token
df_bills <- eodhdR2::get_ust_bill_rates()
df_lt    <- eodhdR2::get_ust_long_term_rates()
df_yield <- eodhdR2::get_ust_yield_rates()
df_real  <- eodhdR2::get_ust_real_yield_rates()
```

## US Tick Data

``` r
# requires a paid token
df_ticks <- eodhdR2::get_us_tick_data("AAPL",
                                       from = Sys.Date() - 1,
                                       to = Sys.Date())
head(df_ticks)
```

## User Account Details

``` r
user_info <- eodhdR2::get_user_details()
str(user_info)
```

## Company Logos

``` r
# requires a paid token
logo_png <- eodhdR2::get_logo("AAPL.US")
logo_svg <- eodhdR2::get_logo_svg("AAPL.US")
```

## Marketplace Tick Data (Unicorn Bay)

``` r
# requires marketplace subscription
df_mp_ticks <- eodhdR2::get_mp_tick_data("AAPL",
                                          from = Sys.Date() - 1,
                                          to = Sys.Date())
```

## Options Underlying Symbols

``` r
# requires marketplace subscription
df_underlyings <- eodhdR2::get_options_underlyings()
```

## S&P Global Indices List

``` r
# requires marketplace subscription
df_indices <- eodhdR2::get_indices_list()
```

## CBOE Index Data

``` r
# requires a paid token
df_vix <- eodhdR2::get_cboe_index_data("VIX")
df_cboe_list <- eodhdR2::get_cboe_indices_list()
```

## ESG Data (Investverte)

``` r
# requires marketplace subscription
df_esg_companies <- eodhdR2::get_esg_companies()
df_esg_countries <- eodhdR2::get_esg_countries()
df_esg_sectors   <- eodhdR2::get_esg_sectors()
df_esg_company   <- eodhdR2::get_esg_company("AAPL.US")
df_esg_country   <- eodhdR2::get_esg_country("US")
df_esg_sector    <- eodhdR2::get_esg_sector("Technology")
```

## Illio Analytics

``` r
# requires marketplace subscription
result_bw   <- eodhdR2::get_illio_best_and_worst("SnP500")
result_bb   <- eodhdR2::get_illio_beta_bands("SnP500")
result_vol  <- eodhdR2::get_illio_volume("SnP500")
result_perf <- eodhdR2::get_illio_performance("SnP500")
result_risk <- eodhdR2::get_illio_risk("SnP500")
result_vola <- eodhdR2::get_illio_volatility("SnP500")
result_cp   <- eodhdR2::get_illio_category_performance("SnP500")
result_cr   <- eodhdR2::get_illio_category_risk("SnP500")
```

## PRAAMS Financial Analytics

``` r
# requires marketplace subscription
# Bank data
bs_isin <- eodhdR2::get_praams_bank_balance_sheet_isin("US0378331005")
bs_tick <- eodhdR2::get_praams_bank_balance_sheet_ticker("AAPL", "US")
is_isin <- eodhdR2::get_praams_bank_income_statement_isin("US0378331005")
is_tick <- eodhdR2::get_praams_bank_income_statement_ticker("AAPL", "US")

# Analysis
bond_a <- eodhdR2::get_praams_bond_analysis("US0378331005")
eq_isin <- eodhdR2::get_praams_equity_analysis_isin("US0378331005")
eq_tick <- eodhdR2::get_praams_equity_analysis_ticker("AAPL", "US")

# PDF Reports
pdf_bond <- eodhdR2::get_praams_bond_report("US0378331005", "user@example.com")
pdf_eq_i <- eodhdR2::get_praams_equity_report_isin("US0378331005", "user@example.com")
pdf_eq_t <- eodhdR2::get_praams_equity_report_ticker("AAPL", "US", "user@example.com")

# Screeners (POST)
df_bonds   <- eodhdR2::get_praams_bond_screener()
df_equities <- eodhdR2::get_praams_equity_screener()
```

## TradingHours

``` r
# requires marketplace subscription
df_markets <- eodhdR2::get_tradinghours_markets()
df_lookup  <- eodhdR2::get_tradinghours_lookup("NYSE")
details    <- eodhdR2::get_tradinghours_details("US.NYSE")
status     <- eodhdR2::get_tradinghours_status("US.NYSE")
```

# Complete Function Reference

| Function | Description | Endpoint |
|---|---|---|
| `set_token()` | Authenticate R session | N/A |
| `get_demo_token()` | Get demo token | N/A |
| `get_prices()` | Historical EOD prices | `/eod/{SYMBOL}` |
| `get_live_prices()` | Real-time / delayed prices | `/real-time/{SYMBOL}` |
| `get_intraday()` | Intraday prices | `/intraday/{SYMBOL}` |
| `get_dividends()` | Historical dividends | `/div/{SYMBOL}` |
| `get_splits()` | Historical splits | `/splits/{SYMBOL}` |
| `get_fundamentals()` | Fundamental data | `/fundamentals/{SYMBOL}` |
| `parse_financials()` | Parse financial statements | N/A (local) |
| `get_technical()` | Technical indicators | `/technical/{SYMBOL}` |
| `get_screener()` | Stock screener | `/screener` |
| `get_sentiments()` | News sentiments | `/sentiments` |
| `get_news()` | Financial news | `/news` |
| `get_news_word_weights()` | News word weights | `/news-word-weights` |
| `get_macro_indicator()` | Macro indicators | `/macro-indicator/{COUNTRY}` |
| `get_earnings()` | Earnings calendar | `/calendar/earnings` |
| `get_earnings_trends()` | Earnings trends | `/calendar/trends` |
| `get_upcoming_splits()` | Upcoming splits | `/calendar/splits` |
| `get_upcoming_dividends()` | Upcoming dividends | `/calendar/dividends` |
| `get_ipos()` | IPO calendar | `/calendar/ipos` |
| `get_insider_transactions()` | Insider transactions | `/insider-transactions` |
| `get_economic_events()` | Economic events | `/economic-events` |
| `get_exchanges()` | Exchange list | `/exchanges-list` |
| `get_exchange_details()` | Exchange details | `/exchange-details/{CODE}` |
| `get_tickers()` | Ticker list | `/exchange-symbol-list/{EXCHANGE}` |
| `get_index_composition()` | Index components | `/fundamentals/{INDEX}` |
| `get_bulk_eod()` | Bulk EOD data | `/eod-bulk-last-day/{EXCHANGE}` |
| `get_bulk_fundamentals()` | Bulk fundamentals | `/bulk-fundamentals/{EXCHANGE}` |
| `get_search()` | Search instruments | `/search/{QUERY}` |
| `get_market_cap()` | Historical market cap | `/historical-market-cap/{TICKER}` |
| `get_symbol_changes()` | Symbol change history | `/symbol-change-history` |
| `get_us_quote()` | US delayed quotes | `/us-quote-delayed` |
| `get_options()` | Options contracts | `/mp/unicornbay/options/contracts` |
| `get_ust_bill_rates()` | US Treasury bill rates | `/ust/bill-rates` |
| `get_ust_long_term_rates()` | US Treasury long-term rates | `/ust/long-term-rates` |
| `get_ust_yield_rates()` | US Treasury yield rates | `/ust/yield-curve-rates` |
| `get_ust_real_yield_rates()` | US Treasury real yield rates | `/ust/real-yield-curve-rates` |
| `get_us_tick_data()` | US tick-level trade data | `/ticks/{SYMBOL}` |
| `get_user_details()` | User account details | `/user` |
| `get_logo()` | Company logo (PNG) | `/logo/{SYMBOL}` |
| `get_logo_svg()` | Company logo (SVG) | `/logo-svg/{SYMBOL}` |
| `get_mp_tick_data()` | Marketplace tick data | `/mp/unicornbay/tickdata/ticks` |
| `get_options_underlyings()` | Options underlying symbols | `/mp/unicornbay/options/underlying-symbols` |
| `get_indices_list()` | S&P Global indices list | `/mp/unicornbay/spglobal/list` |
| `get_cboe_index_data()` | CBOE index data | `/cboe/index` |
| `get_cboe_indices_list()` | CBOE indices list | `/cboe/indices` |
| `get_esg_companies()` | ESG company list | `/mp/investverte/companies` |
| `get_esg_countries()` | ESG country list | `/mp/investverte/countries` |
| `get_esg_sectors()` | ESG sector list | `/mp/investverte/sectors` |
| `get_esg_company()` | ESG company data | `/mp/investverte/esg/{SYMBOL}` |
| `get_esg_country()` | ESG country data | `/mp/investverte/country/{SYMBOL}` |
| `get_esg_sector()` | ESG sector data | `/mp/investverte/sector/{SYMBOL}` |
| `get_illio_best_and_worst()` | Illio best & worst | `/mp/illio/chapters/best-and-worst/{ID}` |
| `get_illio_beta_bands()` | Illio beta bands | `/mp/illio/chapters/beta-bands/{ID}` |
| `get_illio_volume()` | Illio volume | `/mp/illio/chapters/volume/{ID}` |
| `get_illio_performance()` | Illio performance | `/mp/illio/chapters/performance/{ID}` |
| `get_illio_risk()` | Illio risk | `/mp/illio/chapters/risk/{ID}` |
| `get_illio_volatility()` | Illio volatility | `/mp/illio/chapters/volatility/{ID}` |
| `get_illio_category_performance()` | Illio category performance | `/mp/illio/categories/performance/{ID}` |
| `get_illio_category_risk()` | Illio category risk | `/mp/illio/categories/risk/{ID}` |
| `get_praams_bank_balance_sheet_isin()` | PRAAMS bank balance sheet (ISIN) | `/mp/praams/bank/balance_sheet/isin/{ISIN}` |
| `get_praams_bank_balance_sheet_ticker()` | PRAAMS bank balance sheet (ticker) | `/mp/praams/bank/balance_sheet/ticker/{TICKER}` |
| `get_praams_bank_income_statement_isin()` | PRAAMS bank income statement (ISIN) | `/mp/praams/bank/income_statement/isin/{ISIN}` |
| `get_praams_bank_income_statement_ticker()` | PRAAMS bank income statement (ticker) | `/mp/praams/bank/income_statement/ticker/{TICKER}` |
| `get_praams_bond_analysis()` | PRAAMS bond analysis | `/mp/praams/analyse/bond/{ISIN}` |
| `get_praams_equity_analysis_isin()` | PRAAMS equity analysis (ISIN) | `/mp/praams/analyse/equity/isin/{ISIN}` |
| `get_praams_equity_analysis_ticker()` | PRAAMS equity analysis (ticker) | `/mp/praams/analyse/equity/ticker/{TICKER}` |
| `get_praams_bond_report()` | PRAAMS bond report (PDF) | `/mp/praams/reports/bond/{ISIN}` |
| `get_praams_equity_report_isin()` | PRAAMS equity report (ISIN, PDF) | `/mp/praams/reports/equity/isin/{ISIN}` |
| `get_praams_equity_report_ticker()` | PRAAMS equity report (ticker, PDF) | `/mp/praams/reports/equity/ticker/{TICKER}` |
| `get_praams_bond_screener()` | PRAAMS bond screener | `POST /mp/praams/explore/bond` |
| `get_praams_equity_screener()` | PRAAMS equity screener | `POST /mp/praams/explore/equity` |
| `get_tradinghours_markets()` | TradingHours market list | `/mp/tradinghours/markets` |
| `get_tradinghours_lookup()` | TradingHours market lookup | `/mp/tradinghours/markets/lookup` |
| `get_tradinghours_details()` | TradingHours market details | `/mp/tradinghours/markets/details` |
| `get_tradinghours_status()` | TradingHours market status | `/mp/tradinghours/markets/status` |
