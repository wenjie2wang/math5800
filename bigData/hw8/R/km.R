## k-means clustering
km <- function(X, K, max_iters) {
    ## initialize values
    m <- nrow(X)
    n <- ncol(X)
    centroids <- matrix(runif(K * n), K, n)
    idx <- matrix(0, m, 1)
    old_idx <- matrix(0, m, 1)

    ## start looping
    for (j in seq_len(max_iters)) {
        change = FALSE
        for (i in seq_len(m)) {
            idx[i] <- which.min(rowSums(sweep(- centroids, 2,
                                              X[i, ], FUN = "+") ^ 2))
            if (idx[i] != old_idx[i] && (! change))
                change <- TRUE
        }
        for (i in seq_len(K)) {
            centroids[i, ] <- colMeans(X[idx == i, ])
        }

        ## if no more changing groups
        if (! change) break

        old_idx <- idx
    }
    list(idx = idx, centroids = centroids)
}
