### collection of functions used in script "insurance.R"


## function that computes cost function
computeCost <- function(theta, input_num, hidden_num, label_num, X, y, lambda) {
    ## set up matrix Theta1 and Theta2
    Theta1 <- matrix(head(theta, hidden_num * (1 + input_num)),
                     nrow = hidden_num)
    Theta2 <- matrix(tail(theta, label_num * (1 + hidden_num)),
                     nrow = label_num)
    m <- nrow(X)

    ## convert the labels: 1 to 10, 2 to 01
    iMat <- diag(label_num) # renamed to "iMat" since "I" is a function in R
    Y <- iMat[y, ]

    A1 <- cbind(1, X)                   # A1: m by (n + 1)
    Z2 <- tcrossprod(A1, Theta1)        # Z2: m by hidden_num
    A2 <- cbind(1, sigmoid(Z2))         # A2: m by (hidden_num + 1)
    Z3 <- tcrossprod(A2, Theta2)        # Z3: m by number of output nodes
    A3 <- H <- sigmoid(Z3)              # A3 and H: m by number of output nodes

    ## feed-forward & cost function
    J = sum(- Y * log(H) - (1 - Y) * log(1 - H)) / m

    ## regularization
    reg <- lambda / (2 * m) * (sum(Theta1[, - 1L] ^ 2) + sum(Theta2[, -1L] ^ 2))

    ## cost function with regularization
    J = J + reg

    ## back-propagation & big deltas
    delta3 <- A3 - Y
    delta2 <- delta3 %*% Theta2 * gradient(Z2)
    delta2 <- delta2[, - 1L]

    ## accumulate gradients
    BigDelta1 <- crossprod(delta2, A1)
    BigDelta2 <- crossprod(delta3, A2)

    ## regularized gradient
    Theta1_grad <- BigDelta1 / m + lambda / m * cbind(0, Theta1[, - 1L])
    Theta2_grad <- BigDelta2 / m + lambda / m * cbind(0, Theta2[, - 1L])

    ## construct vector theta from Theta1 and Theta2 for return
    attr(J, "gradient") <- c(Theta1_grad, Theta2_grad)
    J
}


## function that computes gradient of cost function
gradient <- function(z) {
    ## cbind(1, sigmoid(z)) * cbind(1, 1 - sigmoid(z))
    cbind(1, sigmoid(z) * (1 - sigmoid(z)))
}


## function that normalizes the design matrix X
normalize <- function(X) {
    m <- nrow(X)
    ## n <- ncol(X)  # not used in this function
    maxVal <- apply(X, 2, max)
    minVal <- apply(X, 2, min)
    (X - rep(minVal, each = m)) / rep(maxVal - minVal, each = m)
}


## function that computes prediction
## renamed to pred since predict is a generic function in R
pred <- function(Theta1, Theta2, X) {
    m <- nrow(X)
    h1 <- sigmoid(tcrossprod(cbind(1, X), Theta1))
    h2 <- sigmoid(tcrossprod(cbind(1, h1), Theta2))
    apply(h2, 1, which.max)
}


## function computing response
sigmoid <- function(z) 1 / (1 + exp(- z))
