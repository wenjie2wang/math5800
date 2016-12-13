#!/usr/bin/Rscript


source("km.R")
## read data from csv file
dat <- read.table("../data/sp500_short_period.csv", sep = ",", header = TRUE)

## get the movement direction of each stock
movement <- matrix(as.integer(tail(dat, - 1L) - head(dat, - 1L) > 0),
                   nrow = ncol(dat), ncol = nrow(dat) - 1L, byrow = TRUE)
m <- nrow(movement)
n <- ncol(movement)

K <- 10                                 # 10 sectors
max_iters <- 1000

## set random seed
set.seed(1216)

## k-means
res <- km(movement, K, max_iters)
idx <- res$idx
centroids <- res$centroids

## output the results
for (i in seq_len(K)) {
    message(sprintf("Stocks in group %d moving up together:", i))
    cat("\n", paste(colnames(dat)[idx == i], sep = ", "), "\n\n\n")
}


