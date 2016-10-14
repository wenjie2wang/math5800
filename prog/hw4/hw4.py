import numpy as np
from scipy.fftpack import fft
from scipy.fftpack import ifft

# To run an algorithm in Quantopian, we need two functions:
# initialize and handle_data.

def initialize(context):

    # context.security = sid(24) # Apple stock
    # context.security = sid(2119)
    context.security = sid(43721) # SCTY

    # initilize the percentage to set coefficients of y to be zero
    context.theta = 0.5

    # set the default indicator for buy
    context.countdown = 0
    context.buy = 0

    # print out current cash 1 minutes after the market opens on every Monday
    schedule_function(
        print_cash,
        date_rules.week_start(),
        time_rules.market_open(minutes = 1)
    )

    # schedule helps set buy indicator to be zero at market open of everyday
    schedule_function(
        reset_countdown,
        date_rules.every_day(),
        time_rules.market_close()
    )

# function that prints out current cash
def print_cash(context, data):
    print("Current Cash:%f" % context.portfolio.cash)


# function that helps set buy indicator to be zero
def reset_countdown(context, data):
    context.countdown = 2


# The handle_data function is where the real work is done.  This function is run
# either every minute (in live trading and minutely backtesting mode) or every
# day (in daily backtesting mode).
def handle_data(context, data):

    # To make market decisions, we will need to know the stock's average price
    # for the last 20 days, the stock's current price, and the cash available in
    # our portfolio.
    N = 20
    prices = np.asarray(data.history(context.security, 'price', N, '1d'))
    y = fft(prices)

    # function that sets the coefficient of Y to zero if it is lower than the
    # percentage of the maximal coefficient
    # def cut2zero(y, theta):
    #     # note that y is a complex number as a result of fourier transformation
    #     cutoff = np.max(y) * context.theta
    #     # it does not make sense to compare complex numbers.
    #     # only real parts are compared in Python
    #     y[y < cutoff] = 0
    #     return y

    # function that sets certain precentage of middile coefficients to be zero.
    # which converted the original piece of code into a function
    # percentage can be specified by context.theta in initialize function
    def cut2zero(y, theta):
        wn = int(len(y) * theta / 2)
        y[wn:-wn] = 0
        return y

    # apply function cut2zero to y
    y = cut2zero(y, context.theta)

    # extract real part
    x1rec = ifft(y).real

    first15_rec = np.mean(x1rec[:15]) # the average of first 15 coefficients
    average_rec = np.mean(x1rec) # average of all N = 20 elements
    ratio = first15_rec / average_rec

    buy_threshold = 0.99 # Ratio threshold at which to buy
    close_threshold = 1  # Ratio threshold at which to close buy position

    current_price = data.current(context.security, "price")
    cash = context.portfolio.cash


    # Note that record function only plot the last value before market closes
    # However, the stock trading happens every minute. So a simple local buy
    # indicator inside the if condition chunk of buying or not will be
    # overwritten each minute. We are able to print out buy indicator every
    # minute.  However, record function will only plot its last value before
    # market closes.

    # The buy indicator we want to set here will be 1 if our algorithm buys any
    # amounts of shares anytime in one day!  Its value will be reset right after
    # market opens in the next day.

    # unfortunately, schedule_function does not help since the earliest time it
    # can set is 9:01 AM after the first run of the handle_data function; The
    # latest time it can set is 15:59 PM before the final run of the handle_data
    # function :( However, we come up with a workaround as follows:

    # reset buy indicator with the help of countdown variable
    # context.countdown = 2 at 15:59 PM everyday
    # context.countdown = 1 at market closes and market opens next day
    # context.countdown = 0 when the code is executed right after market opens
    if context.countdown > 0:
        context.countdown = context.countdown - 1
        if context.countdown == 0:
            context.buy = 0


    # If the 20-days average price is 1% above the first 15-days average price
    # and we have enough cash, then we will order. If the  is below
    # the average price, then we want to close our position to 0 shares.
    if ratio < buy_threshold and cash > current_price:
        # Need to know how many shares we can buy
        number_of_shares = int(cash / current_price)
        # set order indicator buy to be 1
        context.buy = 1
        # Place the buy order (positive means buy, negative means sell)
        order(context.security, + number_of_shares)
    elif ratio > close_threshold:
        # Sell all of our shares by setting the target position to zero
        order_target(context.security, 0)


    # Plot the stock's price, average20_rec, first15_rec, and order indicator,
    # buy50, which is 50 if buy = 1
    record(stock_price = data.current(context.security, "price"),
           average_rec = average_rec, first15_rec = first15_rec,
           buy50 = context.buy * 50)
