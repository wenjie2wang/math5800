source('selectk.R')
mapping <- function(X, degree){
    m <- nrow(X)
    n <- ncol(X)
    power <- selectk(0:degree, n)
    ind <- (rowSums(power) <= degree)
    power <- power[ind, ]
    p <- nrow(power)
    Xmap <- matrix(0, m, p)
    for (i in 1:p){
        aterm <- rep(1, m)
        for (j in 1:n){
            aterm <- aterm * X[, j]^power[i, j]
        }
        Xmap[, i]  <- aterm
    }
    return(Xmap)
}
