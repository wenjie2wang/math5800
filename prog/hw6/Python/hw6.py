#!/usr/bin/python3

import csv
import platform
import numpy as np
from scipy.optimize import linprog

# data set up
if platform.system() == "Windows":
    datPath = "..\data\InOutputs.csv"
else:
    datPath = "../data/InOutputs.csv"

with open(datPath, newline='') as csvfile:
    csvData = csv.reader(csvfile)
    datList = []
    for row in csvData:
        datList.append(row)

# convert list to matrix
data = np.array(datList)

# input and output matrix
I = np.array(data[:, 0:3])
I = I.astype(np.float)
O = np.array(data[:, 3:5])
O = O.astype(np.float)

m, n1 = I.shape
m, n2 = O.shape

# 1
######################################################
f = np.concatenate((I, np.zeros((m,n2))), axis=1)
lb = np.array([0]*(n1+n2))
x = []
A = np.concatenate((np.array([[0]*(n1)]*m),O),axis=1)- \
 np.concatenate((I,np.array([[0]*(n2)]*m)),axis=1)
b = np.array([0]*m)

for i in range(0,m):
    Aeq = np.array([np.concatenate((np.array([0]*n1), O[i,:]),axis=0)])
    beq = np.array([1])
    z=linprog(f[i,:], A_ub=A, b_ub=b, A_eq=Aeq, b_eq=beq, options={"disp": True})
    x.append(z.x)

x = np.array(x)
result = np.multiply(x, np.concatenate((I,O),axis=1))
result[:,3]+result[:,4]

# 2
######################################################
f = np.concatenate((I, -O), axis=1)
lb = np.array([0]*(n1+n2))
x = []
A = np.concatenate((np.array([[0]*(n1)]*m),O),axis=1)- \
 np.concatenate((I,np.array([[0]*(n2)]*m)),axis=1)
b = np.array([0]*m)

for i in range(0,m):
    Aeq = np.array([np.concatenate((I[i,:], np.array([0]*n2)),axis=0)])
    beq = np.array([1])
    z=linprog(f[i,:], A_ub=A, b_ub=b, A_eq=Aeq, b_eq=beq, options={"disp": True})
    x.append(z.x)

x = np.array(x)
result = np.multiply(x, np.concatenate((I, O), axis=1))
result[:, 3] + result[:, 4]
