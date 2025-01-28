library(testthat)
library(SurvMetrics)
Sys.setenv("OMP_THREAD_LIMIT" = 1)
test_check("SurvMetrics")
