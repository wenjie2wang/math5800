#!/usr/bin/python3
# Python 3.5.2 (default, Jun 28 2016, 08:46:01)
# [GCC 6.1.1 20160602] on linux


### import modules depended on
import numpy

### function that optimizes cost by gradient descent
def optimizeCost(X, y, theta, step, maxrun):
    ## number of observations
    m = len(y)
    cost_range = numpy.zeros((maxrun, 1))

    for iter in range(maxrun):
        h = numpy.dot(X, theta)
        grad = 1 / m * numpy.dot((h - y).transpose(), X)
        theta = theta - step * grad.transpose()
        diff = h - y
        cost_range[iter] = 1 / 2 / m * numpy.dot(diff.transpose(), diff)
    out = [theta, cost_range]
    return out


### function that computes cost
def computeCost(X, y, theta):
    m = len(y)
    ## cost = 0                    # it is not needed
    h = numpy.dot(X, theta)
    diff = h - y
    cost = 1 / 2 / m * numpy.dot(diff.transpose(), diff)
    return cost
