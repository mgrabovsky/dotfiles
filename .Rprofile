source(file.path(Sys.getenv("HOME"), ".Rprofile_common"))

#' Calculate the capital recovery factor (CRF) for a given duration
#' and discount rate.
crf <- \(rate, num_years, offset = 0) {
  stopifnot(
    rate >= 1,
    num_years >= 1
  )

  base_crf <- dplyr::if_else(
    rate == 1, 1 / num_years, (rate - 1) / (1 - rate^-num_years)
  )

  base_crf * (rate^offset)
}

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

#' Calculate Extended Internal Rate of Return (XIRR)
#'
#' Computes the annualized internal rate of return for a series of cash flows
#' occurring at irregular intervals. It mimics the behavior of the Excel XIRR function.
#'
#' @param dates A vector of strings or Date objects representing the transaction dates.
#' @param cash_flows A numeric vector representing the cash flows. Inflows (deposits)
#'   should be negative numbers, and outflows (withdrawals or current portfolio value)
#'   should be positive numbers.
#' @param guess A numeric scalar representing an initial guess for the rate of return.
#'   Defaults to 0.1 (10%).
#'
#' @return A numeric value representing the annualized rate of return (as a decimal).
#' @export
#'
#' @examples
#' dates <- as.Date(c("2025-01-01", "2025-05-01", "2025-12-01", "2026-07-01"))
#' flows <- c(-500, -400, -400, 1600)
#' xirr(dates, flows) # Returns approximately 0.2024
xirr <- function(dates, cash_flows, guess = 0.1) {
  # Validation checks
  if (length(dates) != length(cash_flows)) {
    stop("The number of dates must match the number of cash flows.")
  }
  if (sum(cash_flows) == 0) return(0)
  if (all(cash_flows >= 0) || all(cash_flows <= 0)) {
    stop("Cash flows must have both positive and negative values.")
  }

  # Ensure dates are in Date format and sorted
  dates <- as.Date(dates)
  ord <- order(dates)
  dates <- dates[ord]
  cash_flows <- cash_flows[ord]

  # Calculate time differences in years from the first date
  t <- as.numeric(dates - dates[1]) / 365

  # Define the Net Present Value (NPV) function to minimize
  npv_func <- function(r) {
    sum(cash_flows / (1 + r)^t)
  }

  # Try to find the root within a realistic boundary (-99% to 1000%)
  # If it fails, expand boundaries or default to uniroot's error handling
  result <- tryCatch({
    uniroot(npv_func, interval = c(-0.999, 10), extendInt = "yes", tol = 1e-8)
  }, error = function(e) {
    stop("XIRR failed to converge. Check if your inputs or dates are valid.")
  })

  return(result$root)
}

#' Generator for a simple 5-parameter hinge function with adjustable
#' knee hardness (parameter delta).
hinge <- \(x0 = 0, a = 0, b0 = 0, b1 = 1, delta = 1) {
  \(x) {
    a + b0 * (x - x0) + (b1 - b0) * delta * log(1 + exp((x - x0) / delta))
  }
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

Sys.setenv(
  TORCH_HOME = "/home/mgrabovsky/.torch"
)
