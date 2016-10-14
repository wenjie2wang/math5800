### load module we write
import capm

### import other modules needed, install them if cannot found
import csv
import platform
import numpy
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm


### load data ==================================================================
## just for different slash style under Windows system
if platform.system() == "Windows":
    datPath = "..\data\CAPMuniverse.csv"
else:
    datPath = "../data/CAPMuniverse.csv"

## read data from csv file
with open(datPath, newline='') as csvfile:
    csvData = csv.reader(csvfile)
    datList = []
    for row in csvData:
        datList.append(row)

## get the colnames in the first row and remove it
colNames = datList.pop(0)

## convert list to matrix
data = numpy.array(datList, dtype = "float")

## number of rows and columns
m = len(datList)
n = len(colNames)

## y is the return of an individual stock for YAHOO
y = data[: , colNames.index("YHOO")] - data[: , colNames.index("CASH")]
y = y.reshape((m, 1))           # reshape to column vecter

## X is the return of the market
X = data[: , colNames.index("MARKET")] - data[: , colNames.index("CASH")]

### gradient descent ===========================================================
## add a column of 1 to X so it becomes [x0, x1]
X = numpy.column_stack([numpy.ones(m), X])
maxrun = int(1e6)               # maximum number of iterations
step = 0.1
theta = numpy.zeros((2, 1))     # parameters for x0 and x1, respectively

## call function optimizeCost
optimOut = capm.optimizeCost(X, y, theta, step, maxrun)
theta = optimOut[0]
cost_range = optimOut[1]

## predicted y or the hypothesis
pred = numpy.dot(X, theta)


### plot the data and results ==================================================
## plot y against X
plt.figure(figsize=(3, 3))
scatter, = plt.plot(X[: , 1], y, "rx", markersize = 1)
plt.ylabel('Individual Security')
plt.xlabel('S&P500')

## now plot the regression line
regLine, = plt.plot(X[: , 1], pred, '.')
plt.legend([scatter, regLine], ['Training data', 'Predicted regression line'])
plt.show()

## plot the cost vs the number of iterations
plt.figure()
plt.plot(cost_range)
plt.ylabel('Cost');
plt.xlabel('Number of interations')
plt.show()

## cost function vs thetas
th0 = numpy.linspace(theta[0] - 10, theta[0] + 10, 100)
th1 = numpy.linspace(theta[1] - 10, theta[1] + 10, 100)
cost = numpy.zeros((len(th0), len(th1)))
for i in range(len(th0)):
    for j in range(len(th1)):
        theta_ij = numpy.vstack([th0[i], th1[j]])
        cost[i, j] = capm.computeCost(X, y, theta_ij)

## plot it out
th0, th1 = numpy.meshgrid(th0, th1)
fig = plt.figure()
ax = fig.gca(projection='3d')
surf = ax.plot_surface(th0, th1, cost, cmap = cm.coolwarm, rstride = 1,
                       cstride = 1, linewidth = 0, antialiased = False)
plt.xlabel(r'$\theta_0$')
plt.ylabel(r'$\theta_1$')
plt.show()
