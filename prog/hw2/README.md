# Authors

- Wenjie Wang, Hao Li, and Catherine Payzant


# Files

- **symbols.xls**: sample symbols input.

- **hw2.py**: script that reads a column of symbols read from *symbols.xls*,
  calls function `googleApi.closePrice` to grab the close price forover a
  specified time period, and saves the output to Excel file *closePrice.xls*.

- **googleApi.py**: function extracting the close price for the given
  symbols read from *symbols.xls* over a specified time period.

- **closePrice.xls**: sample output.


# Usage

- call `python3 hw2.py` or `./hw2.py` in terminal under current working
  directory.  Note that all scripts are written for python 3.
