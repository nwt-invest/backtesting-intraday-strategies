# R Source Code for Backtesting intraday strategies 

R is a free software environment for statistical computing and graphics. https://www.r-project.org

The function is **qrm.backtest()** with the following inputs: 

**(1)** days is the lookback; 

**(2)** d.r is used for computing risk, both as the length of the moving standard deviation tr (computed internally over d.r-day moving windows) as well as the lookback for computing the risk model (and, if applicable, a statistical industry classification) – see below;

**(3)** d.addv is used as the lookback for the average daily dollar volume addv, which is computed internally; 

**(4)** n.addv is the number of top tickers by addv used as the trading universe, which is recomputed every d.r days; 

**(5)** inv.lvl is the total investment level (long plus short, and the strategy is dollar-neutral); 

**(6)** bnds controls the position bounds (which are the same in this strategy as the trading bounds), i.e., the dollar holdings Hi for each stock are bounded via (Bi are the bnds elements,which can be uniform)

**|Hi| ≤ Bi Ai (548)**

where i = 1, . . . , N labels the stocks in the trading universe, and Ai are the corresponding elements of addv; 

**(7)** incl.cost is a Boolean for including linear trading costs, which are modeled as follows.248 For the stock labeled by i, let Ei be its expected return, and wi be its weight in the portfolio. The source code below determines wi via (mean-variance) optimization (with bounds). For the stock labeled by i, let the linear trading cost per dollar traded be τi. 

Including such costs in portfolio optimization amounts to replacing the expected return of the portfolio

(https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)
