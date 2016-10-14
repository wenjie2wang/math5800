#!/usr/bin/Rscript


## attach functions we write
source("functions.R")

## setting up
input_num <- 21
hidden_num <- 100
label_num <- 2
train_pc <- 0.66

## set up data path for possibly different OS
datPath <- paste("..", "data", "insurance.csv", sep = .Platform$file.sep)
dat <- read.csv(datPath)            # "dat" used since `data` is a function in R
y <- ifelse(dat[, 31L] == "Yes", 2L, 1L)
X <- as.matrix(dat[, sapply(dat[1:10, ], class) %in% c("integer", "numeric")])
X <- normalize(X)                       # min-max normalization
m <- nrow(X)
n <- ncol(X)

## prepare training and test set
set.seed(1216)                    # random seed is important for reproducibility
train_ind <- c(sample(which(y == 1L), floor(train_pc * sum(y == 1L))),
               sample(which(y == 2L), floor(train_pc * sum(y == 2L))))
yTrain <- y[train_ind]
yTest <- y[- train_ind]
XTrain <- X[train_ind, ]
XTest <- X[- train_ind, ]

## define parameters and initial values
lambda <- 0.05
epsilon <- 0.1

## random number between - epsilon and epsilon
Theta1 <- matrix(runif(hidden_num * (1 + input_num),
                       min = - epsilon, max = epsilon), nrow = hidden_num)
Theta2 <- matrix(runif(label_num * (1 + hidden_num),
                       min = - epsilon, max = epsilon), nrow = label_num)
theta <- c(Theta1, Theta2)

## define simple wrapper function computing cost function
costFunction <- function(p) computeCost(p, input_num, hidden_num, label_num,
                                        XTrain, yTrain, lambda)

## optimization by function stats::nlm
## set iterlim = 500 to get similar results from MATLAB
res <- nlm(costFunction, theta, print.level = 0, iterlim = 50)

## update matrix Theta1 and Theta2 with estimated theta from optimization
Theta1 <- matrix(head(res$estimate, hidden_num * (1 + input_num)),
                 nrow = hidden_num)
Theta2 <- matrix(tail(res$estimate, label_num * (1 + hidden_num)),
                 nrow = label_num)

## correct prediction rate of training set
predTrain <- pred(Theta1, Theta2, XTrain)
message(sprintf("\nTrain Set Accuracy: %f\n",
                mean(as.integer(predTrain) == yTrain) * 100))

## correct prediction rate of test set
predTest <- pred(Theta1, Theta2, XTest)
message(sprintf("\nTest Set Accuracy: %f\n",
                mean(as.integer(predTest) == yTest) * 100))
