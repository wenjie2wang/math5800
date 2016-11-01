#!/usr/bin/Rscript


### Assignment 5 ===============================================================
library(quadprog)            # attach package quadprog for quadratic programming


## Question 1. Tangency Portfolio ----------------------------------------------

## same setting from example code
na <- 20L                               # number of assets
ns <- 60L                               # number of observations
set.seed(1216)                          # important for reproducibility
retn <- matrix(rnorm(ns * na, mean = 0.005, sd = 0.015), nrow = ns)
mu <- colMeans(retn)                    # expected returns
rf <- 0.0001                            # riskfree rate (about 2.5% pa)
mu2 <- mu - rf                          # excess means
Q <- cov(retn)                          # covariance matrix

## obtain the optimized weights by quadratic programming
res_tan <- solve.QP(Dmat = Q, dvec = rep(0, na), Amat = matrix(mu2, ncol = 1),
                    bvec = 1, meq  = 1L)
(w_tan <- prop.table(res_tan$solution)) # rescale variables to obtain weights
(retn_tan <- crossprod(w_tan, mu))      # expected return
(se_tan <- as.vector(sqrt(crossprod(w_tan, Q %*% w_tan)))) # standard error
(sr <- crossprod(w_tan, mu2) / se_tan)  # compute sharpe ratio
stopifnot(all.equal(sum(w_tan), 1))     # check budget constraint
stopifnot(all(retn_tan >= rf))          # check return constraint

## minimal variance portfolio
res_min <- solve.QP(Dmat = 2 * Q, dvec = rep(0, na),
                    Amat = matrix(1, nrow = na, ncol = 1),
                    bvec = 1, meq = 1L)
(w_min <- res_min$solution)
(retn_min <- crossprod(w_min, mu))      # expected return
(se_min <- sqrt(
     var_min <- as.vector(crossprod(w_min, Q %*% w_min)))) # standard error
stopifnot(all.equal(sum(w_min), 1))
stopifnot(all.equal(var_min, res_min$value))

## construct efficient frontier from minimal variance and tangency portfolio
retnVec <- c(retn_min, retn_tan)
seVec <- c(se_min, se_tan)
varMat <- diag(seVec ^ 2)
varMat[1, 2] <- varMat[2, 1] <- as.vector(crossprod(w_min, Q %*% w_tan))
alpha <- seq(from = 1, to = - 1, by = - 0.1)
nAlpha <- length(alpha)
tmpMat <- cbind(alpha, 1 - alpha)
retn_eff <- tmpMat %*% retnVec
var_eff <- sapply(alpha, function(a) {
    crossprod(c(a, 1 - a), varMat %*% c(a, 1 - a))
})


## output to pdf file
pdf(file = "portfolios.pdf", width = 7, height = 5)

## plot the tangency and minimal variace portfolio, on efficient portfolio
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0)) # remove margin

plot(sqrt(var_eff), retn_eff, type = "l",
     xlab = expression(sigma[p]), ylab = expression(mu[p]))
points(seVec, retnVec, col = c("red", "blue"), pch = 20)
abline(b = (retn_tan - rf) / se_tan, a = rf, lty = 2, col = "gray", lwd = 1.5)
legend("topleft", col = c("black", "gray", "red", "blue"),
       pch = c(NA, NA, 20, 20), lty = c(1, 2, NA, NA), lwd = c(1, 1.5, NA, NA),
       legend = c("Efficient Frontier", "Captial Market Line (CML)",
                  "Minimal Variance Portfolio", "Tangency Portfolio"))


## Question 2. Trade-off portfolio ---------------------------------------------
tuning <- 1e3                           # set the risk-aversion coefficient
res_trade <- solve.QP(Dmat = tuning * Q, dvec = 2 * mu,
                      Amat = matrix(1, nrow = na, ncol = 1),
                      bvec = 1, meq = 1L)
(w_trade <- res_trade$solution)
(retn_trade <- crossprod(w_trade, mu))                # expected return
(se_trade <- sqrt(crossprod(w_trade, Q %*% w_trade))) # standard error
stopifnot(all.equal(sum(w_trade), 1))

## plot the portfolio on the efficient frontier
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0))
plot(sqrt(var_eff), retn_eff, type = "l",
     xlab = expression(sigma[p]), ylab = expression(mu[p]))
points(se_trade, retn_trade, col = "purple", pch = 20)
legend("topleft", col = c("black", "purple"), pch = c(NA, 20), lty = c(1, NA),
       lwd = c(1, NA), legend = c("Efficient Frontier", "Trade-off Portfolio"))



## Question 3. Tracking portfolio ----------------------------------------------
## set the resulting trade-off portfolio to be the benchmark portfolio
wsup <- 0.1                             # maximum holding size
winf <- 0                               # minimum holding size
Amat <- cbind(1, - diag(na), diag(na))
bvec <- c(1, rep(- wsup, na), rep(winf, na))
res_track <- solve.QP(Dmat = Q, dvec = crossprod(w_trade, Q),
                      Amat = Amat, bvec = bvec, meq = 1L)
(w_track <- res_track$solution)
(retn_track <- crossprod(w_track, mu))                # expected return
(se_track <- sqrt(crossprod(w_track, Q %*% w_track))) # standard error
stopifnot(all.equal(sum(w_track), 1))

## plot the portfolio on the efficient frontier
par(mar = c(2.5, 2.5, 0, 0), mgp = c(1.5, 0.5, 0))
plot(sqrt(var_eff), retn_eff, type = "l",
     xlab = expression(sigma[p]), ylab = expression(mu[p]))
points(se_trade, retn_trade, col = "purple", pch = 20)
points(se_track, retn_track, col = "green", pch = 20)
legend("topleft", col = c("black", "purple", "green"), pch = c(NA, 20, 20),
       lty = c(1, NA, NA), lwd = c(1, NA, NA),
       legend = c("Efficient Frontier", "Benchmark Portfolio",
                  "Tracking Portfolio"))

## output
dev.off()
