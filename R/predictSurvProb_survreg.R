# obj = fit_survreg
# newdata = test_data
#
# #the interesting times of training set
# time_days = sort(unique(as.vector(obj$y[obj$y[,2] == 1])))
predictSurvProb.survreg <- function(obj, newdata, time_days) {
  lp <- predict(obj, newdata = newdata, type = "link") # vector
  B <- obj$scale # fixed value
  dist <- obj$dist
  surv_fun <- function(lp_i) {
    if (dist %in% c("weibull", "exponential")) {
      exp(-exp((log(time_days) - lp_i) / B))
    } else if (dist == "lognormal") {
      1 - pnorm((log(time_days) - lp_i) / B, mean = 0, sd = 1)
    } else if (dist == "gaussian") {
      1 - pnorm((time_days - lp_i) / B, mean = 0, sd = 1)
    } else if (dist == "logistic") {
      1 / (1 + exp((time_days - lp_i) / B))
    } else if (dist == "loglogistic") {
      1 / (1 + exp((log(time_days) - lp_i) / B))
    } else {
      stop("This distribution is not supported")
    }
  }
  # sp <- if(length(lp)==1) surv_fun(lp) else t(sapply(lp, surv_fun))
  sp <- t(sapply(lp, surv_fun))
}
