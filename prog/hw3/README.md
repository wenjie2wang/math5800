# Authors

- Wenjie Wang, Hao Li, and Catherine Payzant


# Files

- **symbols.xls**: sample symbols input.

- **googleApi.R**: R script provides function `closePrice` extracting the close
  price for one given symbol over the specified time period.

- **hw3.R**: R script that reads a column of symbols read from *symbols.xls*,
  calls function `closePrice` to grab the close price over the specified time
  period, and saves the output to Excel file *closePrice.xls*.

- **closePrice.xls**: sample output.


# Usage

- call `./hw3.R` or `R CMD BATCH --vanilla hw3.R` in terminal under current
  working directory.
