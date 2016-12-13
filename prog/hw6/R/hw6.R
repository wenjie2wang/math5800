library(linprog)

## data set up
dat <- read.csv("../data/InOutputs.csv", header = FALSE)
dat <- as.matrix(dat)
I <- dat[, 1 : 3]
O <- dat[, 4 : 5]
m <- nrow(I)
n1 <- ncol(I)
n2 <- ncol(O)

### question 1. ================================================================
f <- cbind(I, matrix(0, m, n2))
lb <- matrix(0, n1 + n2, 1)
x <- matrix(0, m, n1 + n2)
beq <- 1
b <- rbind(beq, matrix(0, m, 1), lb)
cdMat <- cbind(matrix(0, m, n1), O) - cbind(I, matrix(0, m, n2))
dimnames(b) <- dimnames(cdMat) <- NULL

for (i in 1 : m) {
  Aeq <- c(matrix(0, 1, n1), O[i, ])
  A <- rbind(Aeq, cdMat, - diag(1, n1 + n2))
  z <- solveLP(f[i, ], b, A, maximum = FALSE,
               const.dir = c("==", rep("<=", m + n1 + n2)), lpSolve = TRUE)
  x[i, ] <- z$solution
}

result <- x * cbind(I, O)
rowSums(result[, 1 : 3])
rowSums(result[, 4 : 5])


### question 2. ================================================================
f <- cbind(I, -O)
x <- matrix(0, m, n1 + n2)
dimnames(b) <- NULL

for (i in 1:m) {
  Aeq <- c(I[i, ], matrix(0, 1, n2))
  A <- rbind(Aeq, cdMat, - diag(1, n1 + n2))
  z <- solveLP(f[i, ], b, A, maximum = FALSE,
              const.dir = c("==", rep("<=", m + n1 + n2)), lpSolve = TRUE)
  x[i, ] <- z$solution
}

result <- x * cbind(I, O)
rowSums(result[, 1 : 3])
rowSums(result[, 4 : 5])
