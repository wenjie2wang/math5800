sigmoid <- function(x){
    sigm <- 1 / (1 + exp(-x))
    return(sigm)
}
