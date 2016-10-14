# Authors

- Wenjie Wang (for Python scripts) and Hao Li (for R scripts)


# Files

## data/

- **bankruptcy.csv**: sample input csv file.


## python/

- **bankruptcy.py**: python script that calls functions we write in
  **bankruptcyFun.py** to fit logistics regression model on sample data. The
  training set is 60% data points randomly selected from the sample raw
  data. The remaining set serves as test set. The first model uses the linear
  combination of the predictors; The second one takes polymonial terms of each
  predictor under restrict of total order and imposes L2-norm penalty of their
  coefficients to cost funtion.  The prediction rates are calculated based on
  test set and printed out.

- **bankruptcyFun.py**: function that helps construct cost function of logistics
  regression model, normalize each predictor, construct polynomial terms of
  predictors under restriction of total order, generate grid of multi dimension,
  and compute the response of logistics model.


## R/

- **bankruptcy.R**: In the R code, we fit a logistic regression for a data set
  using two approaches. One is fitted without consideration of interaction terms
  and second order terms; the other is fitted with interaction terms and second
  order terms and with Lagrange restriction on the dimensions. The predictor
  matrix is normalized to reduce the possible correlation between them. In R,
  the cost function is minimized using optim function with BFGS method.

- **computeCost.R**: function that computes cost function.

- **grad.R**: function that computes gradient of the cost function.

- **mapping.R**: function that does mapping for covariates to higher dimension.

- **selectk.R**: function that generates grid for given vector.

- **sigmoid.R**: function that computes the response of logistics model.


# Usage

## python scripts

- Call `python3 bankruptcy.py` (or `./bankruptcy.py`) in terminal under current
  working directory.  Make sure the modules needed are installed and note that
  all scripts are written for python 3.

## R scripts

- Call `R CMD BATCH --vanilla bankruptcy.R` in terminal under current working
  directory.  Make sure the packages needed are installed.
