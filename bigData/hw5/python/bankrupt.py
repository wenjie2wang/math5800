#!/usr/bin/python3
# Python 3.5.2 (default, Jun 28 2016, 08:46:01)
# [GCC 6.1.1 20160602] on linux


# load module we write
import bankruptFun as bfun

# import other modules needed, install them if cannot found
import csv
import platform
import numpy as np
import random
from scipy.optimize import minimize

# load data
# just for different slash style under Windows system
if platform.system() == "Windows":
    datPath = "..\data\bankruptcy.csv"
else:
    datPath = "../data/bankruptcy.csv"

# read data from csv file
with open(datPath, newline='') as csvfile:
    csvData = csv.reader(csvfile)
    datList = []
    for row in csvData:
        datList.append(row[1:])  # exclude the first char column, Firm

# get the colnames in the first row and remove it
colNames = datList.pop(0)

# convert list to matrix
data = np.array(datList, dtype="float")

# randomly select 60% data points as training set and ramianing for testing
random.seed(1216)               # set random seed
nRow = np.size(data, 0)
trainInd = random.sample(range(nRow), int(0.6 * nRow))
testInd = np.ones(nRow, np.bool)
testInd[trainInd] = 0

# set up design matrix, response, and initial guess for training data
X = data[trainInd, 0: 12]
X = bfun.normalize(X)           # standardize data column-wise
y = data[trainInd, 12]
m = np.size(X, 0)               # number of rows
n = np.size(X, 1)               # number of columns
X = np.concatenate((np.tile(1, (m, 1)), X), 1)  # add intercept
theta = np.zeros(n + 1)

# set up test set
testX = data[testInd, 0: 12]
testX = bfun.normalize(testX)
m = np.size(testX, 0)               # number of rows
testX = np.concatenate((np.tile(1, (m, 1)), testX), 1)  # add intercept
testY = data[testInd, 12]

# No regularization ==========================================================
# Optimization using scipy.optimize.minimize
res1 = minimize(bfun.computeCost, theta, args=(X, y, ),
                jac=bfun.cost_grad, options={"maxiter": 100})

# Accuracy with training set
pred = bfun.sigmoid(np.dot(testX, res1.x)) >= 0.5
print("Accuracy: %f\n" % (np.mean(pred == testY) * 100))


# Now use regularization =====================================================
# set up design matrix again without intercept as training set
X = data[trainInd, 0: 12]
X = bfun.normalize(X)           # standardize data column-wise
# Mapping to higher dimensional space
X2 = bfun.mapping(X, 2)         # rename to avoid overwrite more than onece
theta2 = np.zeros(np.size(X2, 1))

# set up test set
testX = data[testInd, 0: 12]
testX = bfun.normalize(testX)   # standardize data column-wise
# Mapping to higher dimensional space
testX2 = bfun.mapping(testX, 2)  # rename to avoid overwrite more than onece

# changed name to tuning since lambda is a reserved name for python
tuning = 0.01

# Optimization using fminunc
# Optimization using scipy.optimize.minimize
res2 = minimize(bfun.computeCost, theta2, args=(X2, y, tuning, ),
                jac=bfun.cost_grad, options={"maxiter": 50})

# Compute accuracy on our training set
pred2 = bfun.sigmoid(np.dot(testX2, res2.x)) >= 0.5
print("Accuracy: %f\n" % (np.mean(pred2 == testY) * 100))
