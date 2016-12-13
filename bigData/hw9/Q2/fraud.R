library(mvtnorm)
data <- read.csv('fraud.csv', header = FALSE)
m <- nrow(data)
Xdata <- data[,1:2]
ydata <- data[,3]


train_pc = 0.6
set.seed(1212)
train_ind = c(sample(which(ydata == 1L), floor(train_pc * sum(ydata == 1L))),
              sample(which(ydata == 0L), floor(train_pc * sum(ydata == 0L))))
XTrain <- Xdata[train_ind, ]
yTrain <- ydata[train_ind]
X <- Xdata[- train_ind, ]
y <- ydata[- train_ind]
## estimate mu and sigma2
mu <- colMeans(X)
sigma <- diag(cov(X)) * (m - 1) / m
## density of examples in X
p <- dmvnorm(X, mean = mu, sigma = diag(sigma), log = FALSE)
## now estimate epsilon using the training set
pval <- dmvnorm(XTrain, mean = mu, sigma = diag(sigma), log = FALSE)
F1 <- NULL
epsval <- NULL
stepsize <- (max(pval) - min(pval)) / 1000
for (epsilon in seq(from = min(pval), to = max(pval), by = stepsize)){
  pred <- as.integer(pval < epsilon)
  tp <- sum((pred == 1) & (yTrain == 1))
  fp <- sum((pred == 1) & (yTrain == 0))
  fn <- sum((pred == 0) & (yTrain == 1))
  F1 <- c(F1, 2*tp/(2*tp+fp+fn))
  epsval <- c(epsval, epsilon)
}

ind <- which(F1 == max(F1))
epsilon = epsval[ind]


pdf("fraudPlots.pdf", width = 7, height = 5)
## Plot F1 vs epsilon
plot(epsval, F1, xlab = 'epsilon', ylab = 'F1 score', main = 'F1 vs epsilon',
     pch=20, cex = 0.1, col = "blue")
lines(epsval, F1, col = "blue")

## Accuracy
rate <- sum((y==1)==(p==1))/length(y)
print(paste0('Accuracy: ', rate*100))


## outliers' positions
outliers <- which(p < epsilon)
## Plot the normal examples and outliers
plot(X[, 1], X[, 2], pch = 16, col = 'black', xlab = "X1", ylab = 'X2',
     main = 'Outliers and normal examples', cex = 0.2)
points(X[outliers, 1],X[outliers, 2], pch = 4, col = 'red',
       xlab = '', ylab = '', cex = 0.5)
dev.off()
