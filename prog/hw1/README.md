# Authors:

- Wenjie Wang and Hao Li

# Files

- **symbols.xls**: sample symbols input.

- **hw1.m**: script that first calls function `adjClose` to extract adjusted
  closing price for the given symbols read from *symbols.xls* over a specified
  time period; then saves the output to Excel file *adjClose.xls*.

- **adjClose.m**: function extracting adjusted closing price for the given
  symbols read from *symbols.xls* over a specified time period.

- **adjClose.xls**: sample output.

# Usage

- Call `hw1` in MATLAB under current working directory;
  or call `matlab -nodesktop -nodisplay -r 'hw1; quit;'` in bash terminal.
