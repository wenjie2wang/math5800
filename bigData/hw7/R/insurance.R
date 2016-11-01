#!/usr/bin/Rscript


## attach package for solving quadratic programming
library(quadprog)

## attach functions we write
source("functions.R")

## set up data path for possibly different OS
datPath <- paste("..", "data", "insurance.csv", sep = .Platform$file.sep)
dat <- read.csv(datPath)            # "dat" used since `data` is a function in R
y <- ifelse(dat[, 31L] == "Yes", 2L, 1L)
X <- as.matrix(dat[, sapply(dat[1:10, ], class) %in% c("integer", "numeric")])
X <- normalize(X)                       # min-max normalization
m <- nrow(X)
n <- ncol(X)
beta <- 0.95

## prepare training and test set
set.seed(123)                    # random seed is important for reproducibility

## stratified sampling with 2 strata
train_pc <- 0.7
train_ind <- c(sample(which(y == 1L), floor(train_pc * sum(y == 1L))),
               sample(which(y == 2L), floor(train_pc * sum(y == 2L))))
TrainSize <- length(train_ind)
yTrain <- y[train_ind]
yTest <- y[- train_ind]
XTrain <- X[train_ind, ]
XTest <- X[- train_ind, ]


## new representation of the training and test dataset
tmpList <- pca(XTrain, beta)
XTrain <- tmpList$pca
XTest <- XTest %*% tmpList$w


## Gaussian Kernel
sigma <- 0.1
K <- kernel(XTrain, XTrain, sigma, 0)

## Inequality that individual alpha >= 0
A <- diag(TrainSize)                # different with MATLAB code due to solve.QP
b <- rep(0, TrainSize)

## Equality that sum(alpha_i * y_i) = 0
Aeq <- yTrain
beq <- 0

## Change from min to max optimization by multiplying with - 1
## Regularization term to force H positive definite
H <- diag(as.vector(yTrain)) %*% K %*% diag(as.vector(yTrain)) +
    1e-10 * diag(TrainSize)
f <- - rep(1, TrainSize)

## call function solve.QP
res <- solve.QP(Dmat = H, dvec = f, Amat = cbind(Aeq, A),
                bvec = c(beq, b), meq = 1L)

## correct prediction rate of training set
indx <- which(res$solution >= .Machine$double.eps)
bb <- colMeans(yTrain[indx] - K[indx, ] %*% (res$solution * yTrain))

## correct prediction rate on test set
pred = sign(((1 + kernel(XTest, XTrain, sigma, 0)) ^ 2) %*%
            (res$solution * yTrain) + bb);
message(sprintf("\nTest Set Accuracy: %f\n",
                mean(as.integer(pred) == yTest) * 100))

## correct prediction rate on training set
pred = sign(((1 + kernel(XTrain, XTrain, sigma, 0)) ^ 2) %*%
            (res$solution * yTrain) + bb);
message(sprintf("\nTrain Set Accuracy: %f\n",
                mean(as.integer(pred) == yTrain) * 100))
