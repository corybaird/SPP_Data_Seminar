

* Note
* 1-4 are closely related to the code used in Module 1 of the R sessions
***Session 1 link: https://github.com/corybaird/SPP_Data_Seminar/blob/main/R/Session_1/Module_1_Rstudio.ipynb

* 5 is closely related to the code used in Module 3 of the R sessions
***Session 3 link: https://github.com/corybaird/SPP_Data_Seminar/blob/main/R/Session_2/Module_3_Manipulation.ipynb


* 1. Logistics
*1.1. Show current working directory
pwd

** 1.2 Change directory
*cd DIRECTORY_NAME

** 1.3 Print string
display("hello")


** 2.1 Read csv file
** 2.1.1.1 Import csv
import delimited "vote.csv", clear


** 2.1.1.2 Import from github
import delimited "https://raw.githubusercontent.com/corybaird/SPP_Data_Seminar/main/R/Session_1/vote.csv", clear


* 3.1 Display: first lines of the dataframe¶
*** 3.1.1 Show first 5 rows of all cols
list in 1/5

*** 3.1.2 Show first 5 rows of all vote
list vote in 1/5


*3.2 Display: column names¶
describe


*3.3 Display: summary stats¶

** 3.3.1 Summarize all
summarize

** 3.3.2 Summarize only certain columns
summarize vote income

** 4. Mean calculation

mean(vote)

** 5 Filter: Row select

** 5.1 filter by vote
list income if vote == 1 

** 5.2 Summarize by vote
summarize age if vote == 0

** 5.3 Multiple conditions
** 5.3.1 And connditon
summarize age if vote == 0 & income>10

** 5.3.1 Or connditon
summarize age if income == 1 | income==2


* 6 Table

tab vote





