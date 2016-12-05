computeCost <- function(X, y, theta){
  m <- length(y)
  cost <- 0
  h <- X %*% theta
  diff <- h - y
  cost <- t(diff) %*% diff / (2 * m)
  return(cost)
}











