selectk <- function(v, k) {
    matList <- rep(list(v), k)
    res <- expand.grid(matList)
    res[, seq(k, 1, - 1)]
}
