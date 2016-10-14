#!/usr/bin/python3
# Python 3.5.2 (default, Jun 28 2016, 08:46:01)
# [GCC 6.1.1 20160602] on linux

# load module grabbing Google finance API data
import googleApi
# load modules for Excel files
import xlrd
import xlwt

# inputs
i = 300
p = "15d"
f = "d,o,c,h,l,v"

# read a number of symbols from Excel file
sheet = xlrd.open_workbook("symbols.xls").sheet_by_index(0)
symbols = [sheet.cell(idx, 0).value for idx in range(sheet.nrows)][1:]

# call function googleApi.closePrice to extract close price for each symbol
nSym = len(symbols)
out = [googleApi.closePrice(symbols[ss], i, p, f) for ss in range(nSym)]
nObs = len(out[0])

# write list out to an Excel file
outName = "closePrice.xls"
outBook = xlwt.Workbook(encoding="utf-8")
sheet = outBook.add_sheet("Sheet 1")
for i, subList in enumerate(out):
    sheet.write(0, i, symbols[i])
    for j, res in enumerate(subList):
        sheet.write(j + 1, i, res)
outBook.save(outName)
