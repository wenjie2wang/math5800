# import other modules needed, install them if cannot found
import csv
import platform
import numpy as np
import random
import math
from scipy.stats import multivariate_normal
import matplotlib.pyplot as plt


if platform.system() == "Windows":
    datPath = ".\fraud.csv"
else:
    datPath = "./fraud.csv"

# read data from csv file
with open(datPath, newline='') as csvfile:
    csvData = csv.reader(csvfile)
    datList = []
    for row in csvData:
        datList.append(row)

# convert list to matrix
data = np.array(datList)
data = data.astype(np.float)
Xdata = data[:, 0:2]
ydata = data[:, 2]

# Stratified sampling, 2 strata
train_pc = 0.6
random.seed(1209)
size1 = math.floor(train_pc*sum(ydata == 1.0))
size2 = math.floor(train_pc*sum(ydata == 0.0))
idxY1 = np.linspace(0, len(ydata) - 1, len(ydata), dtype="int")[ydata == 1.0]
idxY2 = np.linspace(0, len(ydata) - 1, len(ydata), dtype="int")[ydata == 0.0]
B1train = np.concatenate((np.random.choice(idxY1, size1, False),
                          (np.random.choice(idxY2, size2, False))), axis=0)
XTrain = Xdata[B1train, :]
yTrain = ydata[B1train]
# Now unknown unlabeled set (but actually we have the labels)
X = np.delete(Xdata, B1train, axis=0)
y = np.delete(ydata, B1train, axis=0)

# estimate mu and sigma2
mu = np.mean(X, axis = 0)
sigma = np.cov(X, rowvar = 0, bias = 1)
# density of examples in X
p = multivariate_normal.pdf(X, mean = mu, cov = sigma)
# now estimate epsilon using the training set
pval = multivariate_normal.pdf(XTrain, mean = mu, cov = sigma)

stepsize = (max(pval) - min(pval)) / 1000
F1 = np.array([])
epsval = np.array([])
for epsilon in np.arange(min(pval), (max(pval)+stepsize), stepsize):
    pred = (pval < epsilon)
    pred = pred.astype(int)
    tp = sum(((pred == 1) & (yTrain == 1)).astype(int))
    fp = sum(((pred == 1) & (yTrain == 0)).astype(int))
    fn = sum(((pred == 0) & (yTrain == 1)).astype(int))
    F1 = np.concatenate((F1, np.array([2.0*tp/(2.0*tp+fp+fn)])))
    epsval = np.concatenate((epsval, np.array([epsilon])))

ind = np.argmax(F1)
epsilon = epsval[ind]

# plot F1 versus epsilon
plt.ylabel('F1 score')
plt.xlabel('epsilon')
plt.plot(epsval, F1, lw = 0.5)
plt.title('F1 vs epsilon')
plt.show()


# Accuracy
rate = sum(((y == 1) == (p == 1)).astype(int)) / np.size(y)
print('Accuracy: %f\n' % (rate*100))

# outliers' positions
outliers = np.where(p < epsilon)
# Plot the normal examples and outliers
plt.plot(X[:, 0], X[:, 1], '.', c = 'black', markersize = 0.5)
plt.plot(X[outliers, 0], X[outliers, 1], 'rx')
plt.ylabel('X1')
plt.xlabel('X2')
plt.title('Outliers and normal examples')
plt.show()
