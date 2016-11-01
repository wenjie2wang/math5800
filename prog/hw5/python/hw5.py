#!/usr/bin/python3


import numpy as np
import random
import cvxopt as opt
from cvxopt import matrix, solvers, blas
import matplotlib.pyplot as plt

# 1.a
######################################################
# create random returns
na = 20;  # number of assets
ns = 60;  # number of observations
random.seed(1209)
R = 0.005 + np.random.randn(na,ns)*0.015;

sigma = matrix(np.cov(R))
mu = np.matrix(np.array(np.mean(R,1)))
rf = 0.0001
mu2 = mu - rf

# set up matrices
P = sigma
q = matrix(np.zeros((na, 1)))
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(mu2)
b = matrix(1.0)

sol1 = solvers.qp(P, q, G, h, A, b)
# rescale variables to obtain weights
w1 = matrix(sol1['x']/sum(sol1['x']))
print(w1)
tanret = blas.dot(matrix(mu), w1)
tansd = np.sqrt(blas.dot(w1, sigma*w1))

# 1.b
######################################################
# Calculate mininum variance weights using quadratic programming
P = 2.0 * sigma
q = matrix(np.zeros((na, 1)))
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(np.ones((1,na)))
b = matrix(1.0)
sol2 = solvers.qp(P, q, G, h, A, b)
w2 = matrix(sol2['x'])
minret = blas.dot(matrix(mu), w2)
minsd = np.sqrt(blas.dot(w2, sigma*w2))

# Calculate efficient frontier weights using quadratic programming
N = 160
mus = [10**(8.0 * t/N) for t in range(50, N)]
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(np.ones((1,na)))
b = matrix(1.0)

# Calculate efficient frontier weights using quadratic programming
portfolios = [solvers.qp(m*sigma, -opt.matrix(mu.T), G, h, A, b)['x']
              for m in mus]
returns = [blas.dot(matrix(mu), x) for x in portfolios]
risks = [np.sqrt(blas.dot(x, sigma*x)) for x in portfolios]

# Calculate CML using tangency portfolio
slope = np.divide((tanret - rf), tansd)
cml = rf + np.array(risks) * slope

# plot
plt.ylabel('mean')
plt.xlabel('std')
line1, = plt.plot(risks, returns, 'b', label='efficient frontier')
line2, = plt.plot(minsd, minret, 'bo', label="minimum variance")
line3, = plt.plot(tansd, tanret, 'ro', label='tangency')
line4, = plt.plot(risks, cml, 'r--', label='CML')
plt.legend(handles=[line1, line2, line3, line4], loc = 2)
plt.show()

# 2.a
######################################################
lamba = 100.0
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(np.ones((1,na)))
b = matrix(1.0)

# Calculate trade-off weights using quadratic programming
sol3 = solvers.qp(lamba*P, -opt.matrix(mu.T), G, h, A, b)
w3 = matrix(sol3['x'])
traderet = blas.dot(matrix(mu), w3)
tradesd = np.sqrt(blas.dot(w3, sigma*w3))

# 2.b
######################################################
N = 160
mus = [10**(5.0 * t/N) for t in range(50, N)]
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(np.ones((1,na)))
b = matrix(1.0)

# Calculate efficient frontier weights using quadratic programming
portfolios = [solvers.qp(m*sigma, -opt.matrix(mu.T), G, h, A, b)['x']
              for m in mus]
returns = [blas.dot(matrix(mu), x) for x in portfolios]
risks = [np.sqrt(blas.dot(x, sigma*x)) for x in portfolios]

plt.ylabel('mean')
plt.xlabel('std')
line1, = plt.plot(tradesd, traderet, 'bo', label='Trade-off with $\lambda=100.0$')
line2, = plt.plot(risks, returns, 'b', label="efficient frontier")
plt.legend(handles=[line1, line2], loc = 2)
plt.show()

# 3.a
######################################################
wbm = w3
benchret = blas.dot(matrix(mu), w3)
benchsd = np.sqrt(blas.dot(w3, sigma*w3))
P = 2.0 * sigma
# Now compute covariance of individual returns and r'*wbm
rbm = np.dot(R.T, wbm)
# rbm is ns x 1 vector of portfolio returns by the benchmark portfolio (ns observations)
q = matrix(-(2.0/(ns-1)) * (np.dot(R - np.tile(np.mean(R, 1), (ns, 1)).T, \
           rbm - np.mean(rbm))))
wmin = np.random.rand(na, 1)
wmin = wmin / np.sum(wmin)
wmax = wmin + np.multiply((1 - wmin), np.random.rand(na, 1))
G = matrix(np.concatenate(( \
             -np.identity(na), \
             np.identity(na)), 0))

h = matrix(np.concatenate(( \
              -wmin, \
              wmax), 0))
A = matrix(np.ones((1,na)))
b = matrix(1.0)

sol4 = solvers.qp(P, q, G, h, A, b)
w4 = matrix(sol4['x'])
trackret = blas.dot(matrix(mu), w4)
tracksd = np.sqrt(blas.dot(w4, sigma*w4))

# 3.b
######################################################
N = 160
mus = [10**(5.0 * t/N) for t in range(50, N)]
G = matrix(-np.zeros((na,na)))
h = matrix(-np.zeros((na,1)))
A = matrix(np.ones((1,na)))
b = matrix(1.0)

# Calculate efficient frontier weights using quadratic programming
portfolios = [solvers.qp(m*sigma, -opt.matrix(mu.T), G, h, A, b)['x']
              for m in mus]
returns = [blas.dot(matrix(mu), x) for x in portfolios]
risks = [np.sqrt(blas.dot(x, sigma*x)) for x in portfolios]

plt.ylabel('mean')
plt.xlabel('std')
line1, = plt.plot(tracksd, trackret, 'go', label='tracking portfolio')
line2, = plt.plot(risks, returns, 'b', label="efficient frontier")
line3, = plt.plot(benchsd, benchret, 'ro', label="benchmark portolio")
plt.legend(handles=[line1, line2, line3], loc = 2)
plt.show()
