### collection of customized functions used in loadcfg.R


## cost function
costFunction <- function(param, Y, r, n_lenders, n_loans, n_features, lambda) {
    ## extract X and Theta from param vector
    X <- matrix(head(param, n_loans * n_features), n_loans, n_features)
    Theta <- matrix(tail(param, n_lenders * n_features), n_lenders, n_features)

    ## cost
    predictions <- tcrossprod(X, Theta)
    errors <- (predictions - Y) * r
    J <- sum(errors ^ 2) / 2

    ## gradients
    X_grad <- errors %*% Theta
    Theta_grad <- crossprod(errors, X)

    ## regularized cost function to penalize overfitting
    reg_X <- lambda * sum(X ^ 2) / 2
    reg_Theta <- lambda * sum(Theta ^ 2) / 2
    J <- J + reg_Theta + reg_X

    ## add regularization terms to gradients
    X_grad <- X_grad + lambda * X
    Theta_grad <- Theta_grad + lambda * Theta
    grad <- c(X_grad, Theta_grad)

    ## return
    list(J = J, grad = grad)
}


## function that optimizes cost function
optimizeCost <- function(param, Y, r, n_lenders, n_loans, n_features, lambda,
                         step, maxrun) {
    cost_range <- rep(0, maxrun)

    for (iter in seq_len(maxrun)) {
        res <- costFunction(param, Y, r, n_lenders, n_loans, n_features, lambda)
        ## gradient descent for both X and Theta
        param <- param - step * res$grad
        cost_range[iter] = res$J
    }
    ## return
    list(param = param, cost_range = cost_range)
}
