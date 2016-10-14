#!/usr/bin/python3
# Python 3.5.2 (default, Jun 28 2016, 08:46:01)
# [GCC 6.1.1 20160602] on linux


def closePrice(q, i, p, f):
    # q = stock symbol, e.g., "YHOO" (YAHOO!)
    # i = interval, e.g., 300 (seconds)
    # p = number of period, e.g., "15d" (15 days)
    # f = parameters, e.g., "d,o,c,h,l,v" (day, open, close, high, low, volume)
    # =========================================================================
    baseUrl = "http://www.google.com/finance/getprices?"
    url = baseUrl + "q=" + q + "&" + "i=" + str(i) + "&" + "p=" + p + "&" + \
        "f=" + f
    import urllib.request
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as response:
        data = response.read().decode("utf-8").split("\n")
    colNames = data[4][8:]
    # index of column closing price
    idx = colNames.split(",").index("CLOSE")
    # the number of row if header (7 lines) and last one empty row is removed
    nRow = len(data) - 8
    nCol = colNames.count(",") + 1
    if nCol > 1:
        # split each row into column by the delimiter ","
        dat = [float(data[i].split(",")[idx]) for i in range(7, nRow + 7)]
    else:
        dat = [float(data[i]) for i in range(7, nRow + 7)]
    return dat
