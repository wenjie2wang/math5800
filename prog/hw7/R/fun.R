### option price or current value of options
## for bull spread
bullSpread <- function(S0, K1, K2, r, Time, sigma, M,
                       type = c("calls", "puts")) {

    ## match the type
    type <- match.arg(type, c("calls", "puts"))

    ## compute constants
    dt <- Time / M
    v <- exp(- r * Time)
    u  <- exp(sigma * sqrt(dt))
    d <- 1 / u
    p  <- (exp(r * dt) - d) / (u - d)

    ## initialize asset prices from high to low at maturity (after M periods)
    S <- cumprod(c(S0 * u ^ M, rep(d / u, M)))

    ## initialise option values at maturity (after M periods)
    if (type == "calls") {
        ## for long a call
        long <- pmax(S - K1, 0)
        ## for short a call
        short <- pmax(S - K2, 0)
    } else {
        ## for long a put
        long <- pmax(K1 - S, 0)
        ## for short a put
        short <- pmax(K2 - S, 0)
    }

    ## step back through the tree
    for (i in seq_len(M)) {
        idx1 <- seq_len(M - i + 1)
        idx2 <- idx1 + 1L
        long <- p * long[idx1] + (1 - p) * long[idx2]
        short <- p * short[idx1] + (1 - p) * short[idx2]
    }
    long <- long * v
    short <- short * v
    setNames(c(long, short, long - short),
             c(paste(c("long", "short"), type), "diff"))
}


## for bear spread
bearSpread <- function(S0, K1, K2, r, Time, sigma, M,
                       type = c("calls", "puts")) {
    bullSpread(S0, K2, K1, r, Time, sigma, M, type = type)
}
