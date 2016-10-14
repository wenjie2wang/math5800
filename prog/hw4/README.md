# Authors

- Wenjie Wang, Hao Li, and Catherine Payzant


# Files

- **sampleBacktest.png**: sample output from Quantopian.

- **hw4.py**: Python script for Quantopian framework that preforms Fourier
  transformation on 20 days stock history price, eliminates a given percentage
  of high frequency noise, operating trading by the rules based on average of
  history price. See comments in the script for details.


# Quick Findings

- The algorithm did not perform well in the first seven months. After then, the
  algorithm had a really great performance and obtained more than 10,000%
  returns eventually.

- The stock price of SCTY dropped from 53.99 to about 23, which was more than
  one half of its original price from 08/01/2015 to 08/31/2016.

- A reasonable trading algorithm is able to gain profits even if the stock price
  is gradually going down overall.

- Although the algorithm had a huge negative returns in between, it eventually
  gained a really high positive returns.
