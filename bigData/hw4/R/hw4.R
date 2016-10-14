#######################################################
#' clear workspace
rm(list = ls())
#######################################################
library(plot3D) # for plotting 3D data
#######################################################
#' source in self-defined functions
#' setwd("~/Documents/FinancialDataming/week4/R_version")
source('optimizeCost.R')
source('computeCost.R')
#######################################################
#' loading data
data <- read.csv('/Users/lihao/Documents/MATLAB/data/CAPMuniverse.csv', 
                 header = TRUE)
m <- nrow(data)
n <- ncol(data)
#' y is the return of an individual stock; X is the return of the market
y <- data$YHOO - data$CASH
X <- data$MARKET - data$CASH
#######################################################
#' add column of 1 to X so that consider intercept in covariate matrix
X <- matrix(c(rep(1, m), X), m, 2)
maxrun <- 1e6  # maximum number of iterations
step <- 0.1
theta <- matrix(c(0, 0), 2, 1) # initial value of theta
optimcost <- optimizeCost(X = X, y = y, theta = theta, 
                          step = step, maxrun = maxrun)
pred <- X %*% optimcost[[1]] # predicted y 
#######################################################
#' Plot the data and results
#' plot y against X;
pdf("plot_prediction.pdf",width=7,height=5)
plot(X[, 2], y, ylab = 'Individual Security', xlab = 'S&P500',
     pch = 16, cex = 0.3, col = 'red', axes = FALSE, frame.plot=TRUE,      
     xlim = c(-0.08, 0.08),
     ylim = c(-0.25, 0.25))
par(new = TRUE)
#' plot the regression line;
plot(X[, 2], pred, pch = 15, cex = 0.4, col = 'blue',
     xlab = '', ylab = '', axes = FALSE,
     xlim = c(-0.08, 0.08),
     ylim = c(-0.25, 0.25))
axis(side = 1, at = seq(-0.08, 0.08, 0.02))
axis(side = 2, at = seq(-0.25, 0.25, 0.05))
legend(0.052, 0.25, xjust=0, yjust=1,
       legend = c('Training data', 'Predicted regression line'),
       col = c("red", "blue"),
       pch = c(16, 15),
       cex = 0.5,
       border = "black")
dev.off()

#' plot the cost vs the number of iterations
pdf("plot_cost.pdf",width=7,height=5)
no.iter <- 1:maxrun
cost.iter <- optimcost[[2]]
format(cost.iter, scientific = TRUE)
plot(no.iter, cost.iter, xlab = "Number of iterations", ylab = "Cost",
     pch = 16, cex = 0.2, col = 'blue', yaxt = 'n', type = 'l',
     ylim = c(6.5e-4, 9.5e-4))
marks <- seq(6.5e-4, 9.5e-4, by = 0.5e-4)
axis(2, at = marks, labels = format(marks, scientific=TRUE))
dev.off()

#' cost function vs thetas
pdf("plot_theta.pdf",width=7,height=5)
th0 <- seq(optimcost[[1]][1, 1] - 10, optimcost[[1]][1, 1] + 10, 
           length.out = 100)
th1 <- seq(optimcost[[1]][2, 1] - 10, optimcost[[1]][2, 1] + 10, 
           length.out = 100)
cost <- matrix(0, nrow = length(th0), ncol = length(th1))
for (i in 1:length(th0)){
  for (j in 1:length(th1)){
    theta <- c(th0[i], th1[j])
    cost[i, j] <- computeCost(X = X, y = y, theta = theta)
  }
}
M <- mesh(th0, th1)
th0mat <- t(M$x)
th1mat <- t(M$y)
surf3D(th0mat, th1mat, cost, colvar = cost, colkey = FALSE, 
       theta = -50, phi = 15, bty = 'b2', border = "black",
       xlim = range(th0mat) * 1.2, ylim = range(th1mat) * 1.2, 
       zlim = range(cost) * 1.2, xlab = 'theta_0', ylab = 'theta_1',
       zlab = "cost", ticktype = "detailed",
       lighting = "sr")
dev.off()


