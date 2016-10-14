closePrice <- function(q = "YHOO", i = 300, p = "15d", f = "d,c,o,h,l,v") {

    ## q = stock symbol, e.g., "YHOO" (YAHOO!)
    ## i = interval, e.g., 300 (seconds)
    ## p = number of period, e.g., "15d" (15 days)
    ## f = parameters, e.g., "d,o,c,h,l,v" (day, open, close, high, low, volume)

    ## url for the data
    baseUrl <- "http://www.google.com/finance/getprices?"
    url <- paste0(baseUrl, "q=", q, "&", "i=", i, "&", "p=", p, "&", "f=", f)

    ## get the colnames of the data
    header <- as.character(read.table(url, nrows = 7L)[5L, ])
    colNames <- unlist(strsplit(substring(header, first = 9L), ","))

    ## grab the real data
    dat <- read.table(url, skip = 7L, col.names = colNames, sep = ",")

    ## return close price
    dat$CLOSE
}
