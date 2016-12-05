# Authors

- Wenjie Wang (for R scripts) and Hao Li (for Python scripts)


# About

Our R and Python code, following the given MATLAB code, does the following
things:

+ Problem: Using X as predictor matrix to predict the insurance status.

+ Method: Neural network, which is an approach of training a multi-layered
  neural network such that it can learn the appropriate internal representations
  to allow it to learn any arbitrary mapping of input to output.

+ Algorithm:

    1.	Forward propagation: using a training pattern's input through the neural
        network to generate the propagation's output activations.
    2.	Backward propagation: using the forward propagation's output activations
        through the neural network to generate the deltas (the difference between
        the targeted and actual output values) of all output and hidden neurons.
    3.	The cost function includes all deltas plus Lagrange restrictions.


# Files


## data/

- **insurance.csv**: sample input csv file


## python/

- **insurance.py**: Main function importing external modules and setting up data
  and initial values. The results are checked with the help of Python module
  **rpy2**. For the same initial matrix Theta1 and Theta2, the R script is able
  to produce exactly same value of initial function, gradient function, and
  prediction results.

- **supplement.py**: supplement functions including normalize function, sigmoid
  function and cost function etc.


## R/

- **insurance.R**: R script to do the hard work. The results are checked with
  the help of R package **R.matlab**. For the same initial matrix Theta1 and
  Theta2, the R script is able to produce exactly same value of initial
  function, gradient function, and prediction results.

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
