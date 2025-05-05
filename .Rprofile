ceil <- ceiling

yhour <- \(dt) hour(dt) + (yday(dt) - 1) * 24
mhour <- \(dt) hour(dt) + (day(dt) - 1) * 24
whour <- \(dt) hour(dt) + (wday(dt) - 1) * 24

softmax <- \(x) exp(x) / sum(exp(x))

discount_years <- \(rate, num_years, delay = 0) {
  exponents <- seq(from = -delay, by = -1, length.out = num_years)

  sum((1 + rate)^exponents)
}

#' Calculate the net present value of an asset with constant annual
#' net cash flows. Assumes annual discounting (with an optional delay
#' or shift). Divide by number of years for annualised NPV.
npv <- \(net_cash_flows, rate, num_years, delay = 0) {
  discounted_years <- discount_years(rate, num_years, delay)

  net_cash_flows * discounted_years
}

month.len <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

options(
  continue = "+ » ",
  lubridate.week.start = 1,
  mc.cores = parallel::detectCores(),
  menu.graphics = FALSE,
  prompt = "𝐑 » ",
  readr.show_col_types = FALSE
)

