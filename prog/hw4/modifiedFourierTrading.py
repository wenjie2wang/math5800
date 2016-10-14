import numpy
from scipy.fftpack import fft
from scipy.fftpack import ifft

# For this example, we're going to write a simple momentum script.  When the
# stock goes up quickly, we're going to buy; when it goes down we're going to
# sell.  Hopefully we'll ride the waves.

# To run an algorithm in Quantopian, you need two functions: initialize and
# handle_data.

def initialize(context):

    # The initialize function sets any data or variables that you'll use in your
    # algorithm. For instance, you'll want to define the security (or
    # securities) you want to backtest.  You'll also want to define any
    # parameters or values you're going to use later. It's only called once at
    # the beginning of your algorithm.

    #context.security = sid(24) # Apple stock
    #context.security=sid(2119)
    context.security = sid(43721) # SCTY

# The handle_data function is where the real work is done.  This function is run
# either every minute (in live trading and minutely backtesting mode) or every
# day (in daily backtesting mode).
def handle_data(context, data):

    # To make market decisions, we will need to know the stock's average price
    # for the last 20 days, the stock's current price, and the cash available in
    # our portfolio.
    N = 20
    prices = numpy.asarray(history(N, '1d', 'price'))

    # Turn off high frequencies
    wn = 5
    y = fft(numpy.transpose(prices)[0])
    y[wn:-wn] = 0

    x1rec = ifft(y).real

    current_rec = numpy.mean(x1rec[:15])
    average_rec = numpy.mean(x1rec) # average of N elements
    ratio = current_rec/average_rec

    buy_threshold = 0.99 # Ratio threshold at which to buy
    close_threshold = 1.0  # Ratio threshold at which to close buy position

    current_price = data[context.security].price
    cash = context.portfolio.cash

    # Here is the meat of our algorithm. If the current price is 1% above the
    # 5-day average price and we have enough cash, then we will order. If the
    # current price is below the average price, then we want to close our
    # position to 0 shares.

    # print current_rec,average_rec
    if ratio < buy_threshold and cash > current_price:

        # Need to know how many shares we can buy
        number_of_shares = int(cash/current_price)

        # Place the buy order (positive means buy, negative means sell)
        order(context.security, +number_of_shares)

    elif ratio > close_threshold:

        # Sell all of our shares by setting the target position to zero
        order_target(context.security, 0)

    # Plot the stock's price
    record(stock_price=data[context.security].price)
