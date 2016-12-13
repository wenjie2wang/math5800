### attach functions we wrote
source("fun.R")

### sample inputs
S0 <- 60                                # initial stock price
K1 <- 55                                # smaller strike price
K2 <- 65                                # larger strike price
r <- 0.1                                # risk-free interest rateT
Time <- 2                               # expiration time
sigma <- 0.4                            # underlying volatility
M <- 4                                  # number of periods

### Question 1. bull spread
## call options
bullSpread(S0, K1, K2, r, Time, sigma, M, type = "calls")

## put options
bullSpread(S0, K1, K2, r, Time, sigma, M, type = "puts")

### Question 2. bear spread
## call options
bearSpread(S0, K1, K2, r, Time, sigma, M, type = "calls")

## puts options
bearSpread(S0, K1, K2, r, Time, sigma, M, type = "puts")
