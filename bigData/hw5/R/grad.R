source('sigmoid.R')
grad <- function(theta, X, y, lambda = 0){
    m <- length(y)
    theta <- matrix(theta, ncol(X), 1)
    z <- X %*% theta
    h <- sigmoid(z)
    grad <- (1 / m) * t(h - y) %*% X
    + lambda * t(c(0, theta[2:length(theta)])) / m
    return(grad)
}
