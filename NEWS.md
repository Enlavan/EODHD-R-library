## Version 0.8 (2026-02-19)

- Added `get_us_tick_data()` for US tick-level trade data
- Added `get_user_details()` for account information
- Added `get_logo()` and `get_logo_svg()` for company logo downloads
- Added `get_mp_tick_data()` for Unicorn Bay marketplace tick data
- Added `get_options_underlyings()` for options underlying symbols
- Added `get_indices_list()` for S&P Global indices list
- Added `get_cboe_index_data()` and `get_cboe_indices_list()` for CBOE data
- Added ESG endpoints: `get_esg_companies()`, `get_esg_countries()`, `get_esg_sectors()`, `get_esg_company()`, `get_esg_country()`, `get_esg_sector()`
- Added Illio analytics: `get_illio_best_and_worst()`, `get_illio_beta_bands()`, `get_illio_volume()`, `get_illio_performance()`, `get_illio_risk()`, `get_illio_volatility()`, `get_illio_category_performance()`, `get_illio_category_risk()`
- Added PRAAMS financial analytics: bank data, bond/equity analysis, PDF reports, bond/equity screeners (12 functions)
- Added TradingHours endpoints: `get_tradinghours_markets()`, `get_tradinghours_lookup()`, `get_tradinghours_details()`, `get_tradinghours_status()`
- Added internal infrastructure: `query_api_binary()` for binary downloads, `query_api_post()` for POST requests

## Version 0.6 (2025-11-06)

- implemented `get_index_composition()`, a function to fetch index composition from eodhd
- fixed slow tests for `get_news()`

## Version 0.5.2 (2025-07-28)

- implemented `get_intraday()`, a function to download intraday prices from eodhd

## Version 0.5.1 (2024-09-03)

- implemented `get_news()`
- implemented `get_ipos()`

## Version 0.5.0 (2024-08-08)

- first version on CRAN
