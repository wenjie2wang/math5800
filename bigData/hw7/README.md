# Authors

- Wenjie Wang and Hao Li


# About

This assignment is about using support vector machine to help classfy data. The primary 
QP optimization of w is transformed to the quadratic program of alpha, which is a more
familier optimization problem to us.

# Files

## data/

- **insurance.csv**: sample input csv file


## python/

- **insurance.py**: main function.

- **supplement.py**: Supplement functions including normalize, PCA and 
  kernel functions.

## R/

- **insurance.R**: R script to do the hard work. The results are checked with
  the help of R package **R.matlab**. For the same training set, the R script is
  able to produce exactly same results fed to the quadratic programming step.

- **functions.R**: Collection of function that used in **insurance.R**.

- **insurance.Rout**: Sample R output of **insurance.R**.


# Usage

## python scripts

- Call `python3 insurance.py` (or `./insurance.py`) in terminal under `/python`
  directory.  Make sure the modules needed are installed and note that all
  scripts are written for python 3.

## R scripts

- Call `R CMD BATCH --vanilla insurance.R` in terminal under `/R` directory.
  (Make sure the packages needed are installed.)
