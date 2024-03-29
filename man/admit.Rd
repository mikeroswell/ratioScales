% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{admit}
\alias{admit}
\title{Opportunity Insights data from Chetty et al. 2023 Selective Colleges
published 24 July 2023 by the NYT upshot}
\format{
Data frame with 1946 observations of 57 variables:
\itemize{
\item \strong{super_opeid} Integer, institutional ID
\item \strong{name} Character, name of college or group
\item \strong{par_income_bin} Numeric, parent income percentile bin
\item \strong{par_income_bin} Character, bin range for parental income
\item \strong{attend} Numeric, test-score-weighted attendance rate
\item \strong{stderr_attend} Numeric, standard error of attendance rate
\item \strong{attend_level} Numeric, denominator for attend rate
\item \strong{attend_sat} Numeric, attendance rate for specific test score band based
on school tier
\item \strong{stderr_attend_sat} Numeric, standard error of attend_sat
\item \strong{attend_level_sat} Numeric, relative attendance rate for specific test
score band based on school tier
\item \strong{rel_apply} 	Numeric, relative fraction of all standardized test takers
who send test scores to a given college
\item \strong{stderr_rel_apply} Numeric, standard error of rel_apply
\item \strong{rel_attend}	Numeric, fraction of students attending that college among
all test-takers within a parent income bin, as a proportion of the mean
attendance rate across all parent income bins for each college
\item \strong{rel_att_cond_app} Numeric, ratio of rel_attend to rel_apply
\item \strong{rel_apply_sat} Numeric, relative application rate for school-tier
\item \strong{rel_attend_sat} Numeric, relative attendance rate at school-tier test
band
\item \strong{stderr_rel_attend_sat} Numeric, standard error of rel_attend_sat
\item \strong{rel_att_cond_app_sat} Numerica, relative attendance rate for school-
tier test band
\item \strong{attend_instate} Numeric, test-score weighted attendance rate for in-
state students matriculating from public high schools	stderr_attend_instate
\item \strong{attend_level_instate} Numeric, denominator for attend_instate
\item \strong{attend_instate_sat} Numeric, test-score specific attendance rate for
in-state students matriculating from public-schools
\item \strong{stderr_attend_instate_sat} Numeric, standard error of
attend_instate_sat
\item \strong{attend_level_instate_sat} Numeric, denominator for attend_instate_sat
\item \strong{attend_oostate} Numeric, test-score weighted attendance rate for out-
of-state students matriculating from public schools
\item \strong{stderr_attend_oostate} Numeric, standard error in attend_oostate
\item \strong{attend_level_oostate}	Numeric, denominator for attend_instate
\item \strong{attend_oostate_sat} 	Numeric, relative out-of-state attendance rate at
school-tier test band
\item \strong{stderr_attend_oostate_sat} Numeric, standard error in
attend_oostate_sat
\item \strong{attend_level_oostate_sat}
\item \strong{rel_apply_instate}
\item \strong{stderr_rel_apply_instate}
\item \strong{rel_attend_instate}
\item \strong{stderr_rel_attend_instate}
\item \strong{rel_att_cond_app_instate}
\item \strong{rel_apply_oostate}
\item \strong{stderr_rel_apply_oostate}
\item \strong{rel_attend_oostate}
\item \strong{stderr_rel_attend_oostate}
\item \strong{rel_att_cond_app_oostate}
\item \strong{rel_apply_instate_sat}
\item \strong{stderr_rel_apply_instate_sat}
\item \strong{rel_attend_instate_sat}
\item \strong{stderr_rel_attend_instate_sat}
\item \strong{rel_att_cond_app_instate_sat}
\item \strong{rel_apply_oostate_sat}
\item \strong{stderr_rel_apply_oostate_sat}
\item \strong{rel_attend_oostate_sat}
\item \strong{stderr_rel_attend_oostate_sat}
\item \strong{rel_att_cond_app_oostate_sat}
\item \strong{public}
\item \strong{flagship}
\item \strong{tier}
\item \strong{tier_name}
\item \strong{test_band_tier}
}
}
\source{
Data from Opportunity Insights \url{https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Data.csv}
}
\usage{
admit
}
\description{
A dataset containing college admissions rates for different socio-economic
groups. Further information at \href{https://opportunityinsights.org/wp-content/uploads/2023/07/CollegeAdmissions_Codebook.pdf}{Opportunity Insights}
}
\keyword{datasets}
