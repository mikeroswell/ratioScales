# grab the data on US college admissions by income bracket
admit <- read.csv("https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Data.csv")

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
            , USDtoCAD = 1/CADtoUSD) %>%
  pivot_longer(cols = c("CADtoUSD", "USDtoCAD"), names_to= "direction", values_to = 'exRate') %>%
  group_by(direction) %>%
  mutate(exRate_scale = exRate/first(exRate)) %>%
  arrange(direction)

## Home sales in US
ushs <- read.csv("https://files.zillowstatic.com/research/public_csvs/zhvi/Metro_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_month.csv?t=1700060680")
head(ushs)



ushs <- ushs %>%
  tidyr::pivot_longer(names_to = "RecordDate"
                      , values_to = "TypicalHomeValue"
                      , cols = 6:291) %>%
  mutate(RecordDate = as.Date(gsub("\\.", "-", gsub("X", "", RecordDate))),
         RegionName = stringi::stri_trans_general(RegionName, "latin-ascii"))

str(ushs)

# Ocean acidification
#
# OA <- read.csv("https://www.ncei.noaa.gov/data/oceans/ncei/ocads/data/0283442/GLODAPv2.2023_Merged_Master_File.csv")
#
# OA_good <- OA %>% filter(G2temperature == 2)
#
#
#
# OA %>%
#   mutate(CollDate = as.Date(paste(G2year, G2month, G2day, sep ="-"))) %>%
#   ggplot(
#     aes(CollDate, G2temperature, color = G2latitude)) +
#   geom_point(size = 0.01, alpha = 0.2) +
#   scale_color_viridis_c() +
#   theme_classic()
#
#
# head(OA)
#
# OA %>% filter(G2)
usethis::use_data(vid, overwrite = TRUE)
usethis::use_data(nel_vid, overwrite = TRUE)
usethis::use_data(exch, overwrite = TRUE)
usethis::use_data(admit, overwrite = TRUE)
usethis::use_data(ushs, overwrite = TRUE)

