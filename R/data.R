# document datasets exported with this package

#' NY Times COVID case data for mid-Atlantic USA in first two pandemic years
#'
#' A dataset containing COVID cases and deaths for 6 US states and territories
#' from 1 April 2020 to 31 March 2022.
#'
#' @format Data frame with 4368 observations of 11 variables:
#'  - **date** Date, YYYY-MM-DD
#'  - **geoid* Character, code for US state or territory
#'  - **state** Character, name of US state or territory
#'  - **cases** Integer, reported daily COVID cases
#'  - **cases_avg** Numeric, rolling daily average number of cases within
#'  "state" in previous 2 weeks
#'  - **cases_avg_per_100k** Numeric, rolling daily average case rate per 100k
#'  residents in previous 2 weeks
#'  - **deaths** Integer, reported daily COVID-related deaths
#'  - **deaths_avg** Numeric, rolling daily average number of deaths within
#'  "state" in previous 2-weeks
#'  - **deaths_avg_per_100k** Numeric, rolling daily average death rate per 100k
#'  residents in previous 2 weeks
#'
#'  @source  Data from The New York Times, based on reports from state and local
#'  health agencies. \url{https://github.com/nytimes/covid-19-data}

"vid"


#' NY Times COVID case data for mid-Atlantic USA in first two pandemic years, with additional columns
#'
#' A dataset containing COVID cases and deaths for 6 US states and territories
#' from 1 April 2020 to 31 March 2022.
#'
#' @format Data frame with 4368 observations of 11 variables:
#'  - **date** Date, YYYY-MM-DD
#'  - **state** Character, name of US state or territory
#'  - **cases** Integer, reported daily COVID cases
#'  - **cases_avg** Numeric, rolling daily average number of cases within
#'  "state" in previous 2 weeks
#'  - **cases_avg_per_100k** Numeric, rolling daily average case rate per 100k
#'  residents in previous 2 weeks
#'  - **deaths** Integer, reported daily COVID-related deaths
#'  - **deaths_avg** Numeric, rolling daily average number of deaths within
#'  "state" in previous 2-weeks
#'  - **deaths_avg_per_100k** Numeric, rolling daily average death rate per 100k
#'  residents in previous 2 weeks
#'  - **ref_case_rate** Numeric, rolling daily average case rate per 100k
#'  residents in reference 2-week time period
#'  - **nel_rate** Numeric, case rate rescaled to reference and expressed in
#'  "nels"
#'  - **prop_rate** Numeric, case rate rescaled to reference and expressed as a
#'  proprtion of the reference rate
#'
#'  @source  Data from The New York Times, based on reports from state and local
#'  health agencies. \url{https://github.com/nytimes/covid-19-data}

"nel_vid"

#' USD-CAD exchange rate in first two COVID pandemic years
#'
#' A dataset with weekday average exchange rate between Canadian and US Dollars
#' between 1 April 2020 and 31 March 2022.
#'
#' @format Data frame with 1044 observations of 4 variables
#' - **date** Date, "YYYY-MM-DD"
#' - **direction** Character, direction of exchange rate
#' - *exRate** Numeric, exchange rate
#' - **exRate_scale** Numeric, proportional difference in exchnage rate from 2020-04-01
#'
#' @source Data from the Federal Reserve Economic Data (FRED), accessed with the
#' R package **alfred**.

 "exch"


