#!/usr/bin/Rscript


source("loancfgFun.R")
## read data from csv files
## note that only the first 100 observations are read
Y <- read.table("../data/loanrating.csv", header = TRUE, sep = ",", nrows = 100)
loanDat <- read.table("../data/loan.csv", header = TRUE, sep = ",", nrows = 100)

## select the numeric part and text part
Y <- as.matrix(Y)
num <- loanDat[, sapply(seq_along(loanDat), function(a) {
    class(loanDat[, a])
}) %in% c("integer", "numeric")]

## binary outcome of whether Y == 0
R <- as.integer(Y != 0)
dim(R) <- dim(Y)

n_lenders <- ncol(Y)
n_loans <- nrow(Y)
n_features <- 10

## initilization
set.seed(1216)                          # random number seed
X <- matrix(runif(n_loans * n_features), n_loans, n_features)
Theta <- matrix(runif(n_lenders * n_features), n_lenders, n_features)
init_param <- c(X, Theta)

## optimization
lambda <- 10
maxrun <- 1e4                           # maximum number of iterations
step <- 1e-3
res <- optimizeCost(init_param, Y, R, n_lenders, n_loans, n_features, lambda,
                    step, maxrun)
param <- res$param
cost_range <- res$cost_range

## extract X and Theta from param vector
X <- matrix(head(param, n_loans * n_features), n_loans, n_features)
Theta <- matrix(tail(param, n_lenders * n_features), n_lenders, n_features)
pred <- tcrossprod(X, Theta)

top_n <- 3
for (j in seq_len(n_lenders)) {
    idx <- order(pred[, j], decreasing = TRUE)
    rating <- pred[idx, j]
    message(sprintf("Top %d recommendations for lender %d:\n", top_n, j))
    for (i in seq_len(top_n)) {
        message(sprintf(paste("Predicted rating %.1f for loan of",
                              "%.1f for %s with %s purpose at %.1f",
                              "percent interest\n"),
                        rating[i], num[idx[i], 1], loanDat[idx[i], 2],
                        gsub(loanDat[idx[i], 7], "_", " "), num[idx[i], 2]))
    }
}
