### collection of functions used in script "insurance.R"


## Gaussian kernel
kernel <- function(XTest, XTrain, sigma, type) {
    if (type == 0)
        return(tcrossprod(XTest, XTrain))
    ## else
    X1 <- rowSums(XTest ^ 2)
    X2 <- rowSums(XTrain ^ 2)
    K <- sweep(sweep(- 2 * tcrossprod(XTest, XTrain), 2, X2, `+`), 2, X1, `+`)
    exp(- K / 2 / sigma)
}


## function that normalizes the design matrix X
normalize <- function(X) {
    m <- nrow(X)
    ## n <- ncol(X)  # not used in this function
    maxVal <- apply(X, 2, max)
    minVal <- apply(X, 2, min)
    (X - rep(minVal, each = m)) / rep(maxVal - minVal, each = m)
}


## function that performs PCA
pca <- function(X, alpha) {
    n <- nrow(X)
    d <- ncol(X)
    covm <- cov(X)
    eigenList <- eigen(covm)            # spectral decomposition
    E <- eigenList$vectors              # correspond to sorted eigen values
    D <- eigenList$values               # already sorted descendingly
    if (alpha >= 1) {
        k <- alpha
    } else {
        k <- sum((cumsum(D) / sum(D)) <= alpha)
        if (k == 0)
            k <- 1
    }
    w <- E[, seq_len(k)]
    leng <- sqrt(colSums(w ^ 2))        # length is a function name; leng used
    w = w / tcrossprod(rep(1, d), leng)
    list(pca = X %*% w, w = w)
}
