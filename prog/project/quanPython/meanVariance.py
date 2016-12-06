import numpy as np
import scipy


def initialize(context):

    context.stocks = [sid(24),     # Apple Inc.
                      sid(16841),  # Amazon.com Inc.
                      sid(46631),  # Alphabet Inc. (Google's parent company)
                      sid(42950)]  # facebook Inc

    context.n = 0
    context.s = np.zeros_like(context.stocks)
    context.x0 = np.zeros_like(context.stocks)
    context.x1 = 1.0 * np.ones_like(context.stocks) / len(context.stocks)

    context.eps = 0.05

    ## allocate weights of assets two hours after the market opens
    schedule_function(allocate, date_rules.every_day(),
                      time_rules.market_open(minutes = 60))

    schedule_function(trade, date_rules.week_start(days_offset = 1),
                      time_rules.market_open(minutes = 60))

    schedule_function(record_leverage, date_rules.every_day())


def record_leverage(context, data):
    record(leverage = context.account.leverage)


def allocate(context, data):
    prices = data.history(context.stocks, 'price', 5 * 390, '1m')
    ret = prices.pct_change()[1 : ].as_matrix(context.stocks)
    ret_mean = prices.pct_change().mean()

    bnds = []
    limits = [0, 1]

    for stock in context.stocks:
        bnds.append(limits)

    bnds = tuple(tuple(x) for x in bnds)

    cons = ({'type': 'eq', 'fun': lambda x:  np.sum(x) - 1.0},
            {'type': 'ineq',
             'fun': lambda x:  np.dot(x, ret_mean) - context.eps})

    res = scipy.optimize.minimize(variance, context.x1, args = ret,
                                  jac = jac_variance, method = 'SLSQP',
                                  constraints = cons, bounds = bnds)

    if res.success:
        allocation = res.x
        allocation[allocation < 0] = 0
        denom = np.sum(allocation)
        if denom > 0:
            allocation = allocation / denom
    else:
        allocation = np.copy(context.x0)

    context.n += 1
    context.s += allocation


def trade(context, data):
    if context.n > 0:
        allocation = context.s / context.n
    else:
        return

    context.n = 0
    context.s = np.zeros_like(context.stocks)
    context.x0 = allocation

    if get_open_orders():
        return

    for i, stock in enumerate(context.stocks):
        order_target_percent(stock, allocation[i])

    record(AAPL = allocation[0])
    record(AMZN = allocation[1])
    record(GOOG = allocation[2])
    record(FB   = allocation[3])


def variance(x, *args):
    p = np.squeeze(np.asarray(args))
    Acov = np.cov(p.T)
    return np.dot(x, np.dot(Acov, x))


def jac_variance(x, *args):
    p = np.squeeze(np.asarray(args))
    Acov = np.cov(p.T)
    return 2 * np.dot(Acov, x)
