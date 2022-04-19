# get some COVID data for the Nel and propDiff examples
library(tidyverse)
vid <- read.csv("https://github.com/nytimes/covid-19-data/raw/master/rolling-averages/us-states.csv")
ref_date <- vid %>% filter(date =="2021-10-17") %>%  select(state, ref_case_rate = cases_avg_per_100k)
new_vid<-vid %>% left_join(ref_date, by = "state")
near_states <-c("Maryland", "Virginia", "Delaware", "District of Columbia", "West Virginia", "Pennsylvania")

nel_vid<-new_vid %>% mutate(nel_rate = log(cases_avg_per_100k/ref_case_rate)
                            , prop_rate = cases_avg_per_100k/ref_case_rate
                            , date = as.Date(date)) %>%
  filter(state %in% near_states) %>%
  filter(date > as.Date("2020-04-01")) %>%
  filter(date < as.Date("2022-03-31")) %>%
  select(-geoid)


# USD-CAD exchange from St. Louis Fed
# devtools::install_github("onnokleen/alfred")
library(alfred)
exch<-get_alfred_series(series_id ="DEXCAUS"
                        , observation_start = "2020-04-01"
                        , observation_end = "2022-03-31") %>%
  select(-realtime_period) %>%
  group_by(date) %>%
  summarize(CADtoUSD = mean(DEXCAUS, na.rm = TRUE)
            , USDtoCAD = 1/CADtoUSD)


usethis::use_data(nel_vid, overwrite = TRUE)
usethis::use_data(exch, overwrite = TRUE)
