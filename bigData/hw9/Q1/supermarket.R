## attach external functions
source("Apriori.R")


## sample usage
dataset <- load_dataset()
(support_data <- apriori(dataset, 0.3))
(generateRules(support_data, 0.5))


## take the first 20 as a sample
market <- read.table("market.csv", header = FALSE, sep = ",", nrows = 20L)
sampleDat <- apply(market, 1, function(a) {
    tmp <- na.omit(a)
    attr(tmp, "na.action") <- attr(tmp, "class") <- NULL
    tmp
})
support_market <- apriori(sampleDat, 0.05)
out <- generateRules(support_market, 0.9)
outDat <- data.frame(rules = names(out), confidence = out)
write.table(outDat, file = "support_market.csv", sep = ",", row.names = FALSE)
