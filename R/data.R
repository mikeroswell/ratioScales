# document datasets exported with this package

#' NY Times COVID case data for mid-Atlantic USA in first two pandemic years
#'
#' A dataset containing COVID cases and deaths for 6 US states and territories
#' from 1 April 2020 to 31 March 2022.
#'
#' @format Data frame with 4368 observations of 11 variables:
#'  - **date** Date, YYYY-MM-DD
#'  - **geoid** Character, code for US state or territory
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


#' Opportunity Insights data from Chetty et al. 2023 Selective Colleges
#' published 24 July 2023 by the NYT upshot
#'
#' A dataset containing college admissions rates for different socio-economic
#' groups. Further information at [Opportunity Insights](https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Codebook.pdf)
#'
#' @format Data frame with 1946 observations of 57 variables:
#'  - **super_opeid** Integer, institutional ID
#'  - **name** Character, name of college or group
#'  - **par_income_bin** Numeric, parent income percentile bin
#'  - **par_income_bin** Character, bin range for parental income
#'  - **attend** Numeric, test-score-weighted attendance rate
#'  - **stderr_attend** Numeric, standard error of attendance rate
#'  - **attend_level** Numeric, denominator for attend rate
#'  - **attend_sat** Numeric, attendance rate for specific test score band based
#'   on school tier
#'  - **stderr_attend_sat** Numeric, standard error of attend_sat
#'  - **attend_level_sat** Numeric, relative attendance rate for specific test
#'  score band based on school tier
#'  - **rel_apply** 	Numeric, relative fraction of all standardized test takers
#'   who send test scores to a given college
#'  - **stderr_rel_apply** Numeric, standard error of rel_apply
#'  - **rel_attend**	Numeric, fraction of students attending that college among
#'   all test-takers within a parent income bin, as a proportion of the mean
#'   attendance rate across all parent income bins for each college
#'  - **rel_att_cond_app** Numeric, ratio of rel_attend to rel_apply
#'  - **rel_apply_sat** Numeric, relative application rate for school-tier
#'  - **rel_attend_sat** Numeric, relative attendance rate at school-tier test
#'  band
#'  -	**stderr_rel_attend_sat** Numeric, standard error of rel_attend_sat
#'  -	**rel_att_cond_app_sat** Numerica, relative attendance rate for school-
#'  tier test band
#'  - **attend_instate** Numeric, test-score weighted attendance rate for in-
#'  state students matriculating from public high schools	stderr_attend_instate
#'  - **attend_level_instate** Numeric, denominator for attend_instate
#'  -	**attend_instate_sat** Numeric, test-score specific attendance rate for
#'  in-state students matriculating from public-schools
#'  - **stderr_attend_instate_sat** Numeric, standard error of
#'  attend_instate_sat
#'  - **attend_level_instate_sat** Numeric, denominator for attend_instate_sat
#'  -	**attend_oostate** Numeric, test-score weighted attendance rate for out-
#'  of-state students matriculating from public schools
#'  - **stderr_attend_oostate** Numeric, standard error in attend_oostate
#'  - **attend_level_oostate**	Numeric, denominator for attend_instate
#'  - **attend_oostate_sat** 	Numeric, relative out-of-state attendance rate at
#'  school-tier test band
#'  - **stderr_attend_oostate_sat** Numeric, standard error in
#'  attend_oostate_sat
#'  - **attend_level_oostate_sat**
#'  -	**rel_apply_instate**
#'  -	**stderr_rel_apply_instate**
#'  -	**rel_attend_instate**
#'  - **stderr_rel_attend_instate**
#'  -	**rel_att_cond_app_instate**
#'  -	**rel_apply_oostate**
#'  -	**stderr_rel_apply_oostate**
#'  -	**rel_attend_oostate**
#'  -	**stderr_rel_attend_oostate**
#'  -	**rel_att_cond_app_oostate**
#'  -	**rel_apply_instate_sat**
#'  -	**stderr_rel_apply_instate_sat**
#'  -	**rel_attend_instate_sat**
#'  -	**stderr_rel_attend_instate_sat**
#'  -	**rel_att_cond_app_instate_sat**
#'  - **rel_apply_oostate_sat**
#'  -	**stderr_rel_apply_oostate_sat**
#'  -	**rel_attend_oostate_sat**
#'  - **stderr_rel_attend_oostate_sat**
#'  -	**rel_att_cond_app_oostate_sat**
#'  -	**public**
#'  -	**flagship**
#'  -	**tier**
#'  - **tier_name**
#'  -	**test_band_tier**
#'
#'
#'
#' @source  Data from Opportunity Insights \url{https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Data.csv}

"admit"

#' US home values by region
#'
#' A dataset containing seasonally adjusted, monthly estimated typical home
#' values within the middle 30th percentiles (35th to 65th) for regions across
#' the United States
#'
#' @format Data frame with 255,970 observations of 7 variables:
#'  - **RegionID** Integer, numeric region identifier
#'  - **Size_Rank** Integer, rank of region size
#'  - **RegionName** Character, name of region
#'  - **RegionType** Character, one of `c("country", "msa")`
#'  - **StateName** Character, name of state in which region falls, if applicable
#'  - **RecordDate** Date, time for which home values were estimated
#'  - **TypicalHomeValue** Numeric, estimated mean value, in US dollars, of
#'    typical homes within region and time period
#'
#' @source Zillow Home Value Index \url{https://files.zillowstatic.com/research/public_csvs/zhvi/Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_month.csv?t=1700060680}

"ushs"



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

 #' Rockfish catch by region and vessel type
 #'
 #' A dataset with annual catch of striped bass ("Rockfish") in Atlantic fishing
 #' regions between 2005 and first 3 quarters of 2023
 #'
 #' @format Data frame with 234 observations of 14 variables
 #'
 #' - **Estimate.Status** Character, one of "FINAL" or
 #' - **Year**
 #' - **Fishing.Year**
 #' - **Region**
 #' - **Common.Name**
 #' - **Fishing.Mode**
 #' - **Cumulative.Through**
 #' - **PSE.Total.Catch..A.B1.B2.**
 #' - **Does.Total.Catch..A.B1.B2..Meet.MRIP.Standard**
 #' - **Is.Total.Catch..A.B1.B2..Significantly.Different.From.0**
 #' - **Total.Catch..A.B1.B2.**
 #' - **Total.Catch..A.B1.B2..Lower.95..Confidence.Limit**
 #' - **Total.Catch..A.B1.B2..Upper.95..Confidence.Limit**
 #' - **X...Contribution.of.Imputed.Data.to.Total.Catch.Rate**
 #'
 #'
 #' @source Data from NOAA NMFS \url{https://www.st.nmfs.noaa.gov/SASStoredProcess/guest?_program=%2F%2FFoundation%2FSTP%2Fmrip_qry_index&qrycatch=Time+Series&subcatch=Goto+Query&qryeffort=Time+Series&qryparticipation=Select+a+Participation+Query}


