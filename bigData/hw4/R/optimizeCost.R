optimizeCost <- function(X, y, theta, step, maxrun) {
  m <- length(y)
  cost_range <- rep(0, maxrun)
  for (i in 1:maxrun) {
    h <- X %*% theta
    grad <- t(h - y) %*% X / m
    theta <- theta - step * t(grad)
    diff <- h - y
    cost_range[i] <- t(diff) %*% diff / (2 * m)
  }
  return(list(theta, cost_range))
}