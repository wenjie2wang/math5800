source('sigmoid.R')
computeCost <- function(theta, X, y, lambda = 0){
    m <- length(y)
    theta <- matrix(theta, ncol(X), 1)
    z <- X %*% theta
    h <- sigmoid(z)
    cost <- (1 / m) * sum(- y * log(h) - (1 - y) * log(1 - h)) +
        (lambda / (2 * m)) * sum(theta[2:length(theta)]^2)
    return(cost)
}
