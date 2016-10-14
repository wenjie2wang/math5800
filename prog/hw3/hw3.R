#!/usr/bin/Rscript --vanilla


### attach the function written
source("googleApi.R")


### sample inputs
i = 300
p = "15d"
f = "d,o,c,h,l,v"


### read symbols from Excel file with the help of the package xlsx

## first install xlsx if it is not installed
if (! require(xlsx, quietly = TRUE)) {
    install.packages("xlsx", repos = "https://cloud.r-project.org/",
                     dependencies = TRUE)
    ## if failed, run "R CMD javareconf" as root in terminal and try again
}
symbols <- xlsx::read.xlsx("symbols.xls", 1L)[, "symbols"]

## call function closePrice to extract close price for each symbol
out <- lapply(symbols, closePrice, i = i, p = p, f = f)
dat <- data.frame(do.call("cbind", out))
colnames(dat) <- symbols


### write list out to an Excel file
outName <- "closePrice.xls"
xlsx::write.xlsx(dat, file = outName, row.names = FALSE)
