# Authors

- Wenjie Wang (for Python scripts) and Hao Li (for R scripts)


# Files

## data/

- **CAPMuniverse.csv**: sample input csv file.

## python/

- **hw4.py**: python script that calls functions in the module **capm** to fit
  the return YAHOO with the return of the market by CAPM model. Coefficients are
  estimated and the predicted returns are plotted against sample data in scatter
  plot. The plot of cost function versus the number of iterations, and thetas
  are generated.

- **capm.py**: function that applies gradient decent to compute coefficients of
  CAPM model and function that computes cost function given theta and sample
  data.

## R/

- **hw4.R**: R script that calls functions written in **optimizeCost.R** and
  **computeCost.R** to fit the return YAHOO with the return of the market by
  CAPM model. Coefficients are estimated and the predicted returns are plotted
  against sample data in scatter plot. The plot of cost function versus the
  number of iterations, and thetas are generated.

- **optimizeCost.R**: function that applies gradient decent to estimate
  coefficients of CAPM model.

- **computeCost.R**: function that computes cost function given theta and sample
  data.


# Usage

## python scripts

- Call `python3 hw4.py` (or `./hw4.py`) in terminal under current working
  directory.  Make sure the modules needed are installed and note that all
  scripts are written for python 3.

## R scripts

- Call `R CMD BATCH --vanilla hw4.R` in terminal under current working
  directory.  Make sure the packages needed are installed.
