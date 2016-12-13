# import modules needed
import numpy as np


def bullSpread(S0, K1, K2, r, Time, sigma, M, type="call"):

    # compute constants
    dt = Time / M
    v = np.exp(- r * Time)
    u = np.exp(sigma * np.sqrt(dt))
    d = 1 / u
    p = (np.exp(r * dt) - d) / (u - d)

    # initialize asset prices from high to low at maturity (after M periods)
    S = np.zeros([M + 1])
    S[0] = S0 * (u ** M)
    S[1:] = S[0] * np.cumprod(np.repeat(d / u, M))

    if type == "calls":
        lon = np.maximum(S - K1, 0)
        short = np.maximum(S - K2, 0)
    else:
        lon = np.maximum(K1 - S, 0)
        short = np.maximum(K2 - S, 0)

    # step back through the tree
    for iter in range(M):
        idx1 = range(M - iter)
        idx2 = range(1, M - iter + 1)
        lon = p * lon[idx1] + (1 - p) * lon[idx2]
        short = p * short[idx1] + (1 - p) * short[idx2]

    lon = lon * v
    short = short * v
    return [lon[0], short[0], lon[0] - short[0]]


def bearSpread(S0, K1, K2, r, Time, sigma, M, type="call"):
    return bullSpread(S0, K2, K1, r, Time, sigma, M, type)
