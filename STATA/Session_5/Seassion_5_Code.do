sysuse uslifeexp.dta, clear
*Set as time series
tsset year

tabstat le_male le_female le_w, by(year)

* 1. Manipulating data

** 1.1 Basics

*** 1.1.1 Generating logs

gen ln_le_male = ln(le_male)

*** 1.1.2 First difference

gen fd_le_male = D.le_male

**** 1.1.1.1 First difference (Alternative method)

gen fd2_le_male= le_male[_n]-le_male[_n-1]

**** 1.1.1.2 First difference by country (row condition)

*By country (row variable)
*by country: gen fd_x1= x1[_n]-x1[_n-1]

**** 1.1.1.3 First difference logs

*by country: gen x1_ln_diff = ln(x1[_n])-ln(x1[_n-1])

**** 1.1.1.4 First difference absolute value

gen x1_le_male =  abs(le_male[_n]-le_male[_n-1])

** 1.2 Scale variables

*** 1.1.1 Scale variable by billions

gen  divideby10_le_male =  le_male/10

*** 1.1.2 Scale variables by other variables

gen male_female_ratio = le_male/le_female

** 1.3 Moving average

*** 1.2.1 Moving average 3-period

*Not an example shown with uploaded data set
*Use with panel data
*rangestat (mean) yr_avg3 = x1, interval(time -1 1)

*** 1.2.2 Moving average 3-period by country

*Not an example shown with uploaded data set
*Use with panel data
*rangestat (mean) yr_avg3 = x1, interval(time -1 1) by(country)

*** 1.2.3 Moving average by time

*Not an example shown with uploaded data set
*Use with panel data
*bysort time: egen x1_yearly_avg =mean(x1)

** 1.4 Generate dummies

*** 1.4.1 Dummy by country (row conditon)

gen long_life = 0
replace long_life = 1 if le_male>70

*** 1.4.2 Dummy by time (By time period)

gen stock_crash = 0
replace stock_crash = 1 if year==1987
replace stock_crash = 1 if year==1997

*** 1.4.2 Dummy by time (After time period)

gen after_eighty = 0
replace after_eighty =1 if year>1979

** 1.5 Creating lags

*One lag
gen lag_le = L.le
*Two lags
gen lag_le_2 = L1.le

* 2. Graphing

** 2.1 Scatter plot

twoway scatter le_male le_female

*** 2.1.1 Scatter plot with country labels

twoway scatter le_male le_female, mlabel(year)

*** 2.1.2 Scatter plot with regression line

twoway lfit  le_male le_female ||  scatter le_male le_female

** 2.2 Bar chart stacked

*twoway
twoway (tsline le_b, recast(bar)) (tsline le , recast(bar)), ytitle(y title) title(Cool title)

*** 2.3 Line chart

twoway (line le year)

*** 2.2.1 Line chart with two y-axis

twoway (line le year, lwidth(thick)) (line le_male year, yaxis(2))

** 2.4 Labeling & Saving

*** 2.4.1 Saving graph

twoway scatter le le_male
graph save Graph "`direct_graphs'_scatter", replace

