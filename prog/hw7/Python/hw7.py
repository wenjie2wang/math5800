#!/usr/bin/python3


# import modules needed
import fun


S0 = 60
K1 = 55
K2 = 65
Time = 2
r = 0.1
sigma = 0.4
M = 4


# Question 1. bull spread
# call options
q1call = fun.bullSpread(S0, K1, K2, r, Time, sigma, M, "calls")
print("long call:%2.2f, short call: %2.2f, price: %2.2f" % tuple(q1call))

# put options
q1put = fun.bullSpread(S0, K1, K2, r, Time, sigma, M, "puts")
print("long call:%2.2f, short call: %2.2f, price: %2.2f" % tuple(q1put))

# Question 2. bear spread
# call options
q2call = fun.bearSpread(S0, K1, K2, r, Time, sigma, M, "calls")
print("long call:%2.2f, short call: %2.2f, price: %2.2f" % tuple(q2call))

# puts options
q2put = fun.bearSpread(S0, K1, K2, r, Time, sigma, M, "puts")
print("long call:%2.2f, short call: %2.2f, price: %2.2f" % tuple(q2put))
