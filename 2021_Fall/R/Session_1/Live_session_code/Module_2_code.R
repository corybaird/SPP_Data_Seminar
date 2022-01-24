# 1. Download data using libraries
# 1.1 WDI library
# 1.1.A Install packages and import library

# Step 1: install
install.packages('WDI')

# Step 2: load functions
library(WDI)

# Easiest way to confirm a package worked is to run it many times
# If you see library(WDI) printed in the console in blue then it worked!
library(WDI)
library(WDI)
library(WDI)


# Commonly used packages
#dplyr-- manipulating
#gpplot2-- graphing



# 1.1.1 WDI search function

search_df = WDIsearch(string = "gender", 
          field = "name") 

search_df

# 1.1.2 Download data¶
wdi_df = WDI(indicator = "5.51.01.07.gender", 
             country= c('AF'), 
             start=2008)


# 2. Download from websites
## 2.1 Zip data

#Step 1
install.packages('downloader')
install.packages('foreign')
install.packages('dplyr')

#Step 2
library(foreign) #Imports dta files
library(downloader) #Downloads files from the internet

# 2.1.1. Download zip¶

#URL 
#url = 'http://www.ennvih-mxfls.org/english/assets/hh02dta_bc.zip'

url = "http://www.ennvih-mxfls.org/english/assets/hh02dta_bc.zip"
#File name
file_name = "mxfls.zip"

# "Downloader" library--function: download.file()
download.file(url, file_name)

#2.1.2 Show files in zip folder¶
unzip("mxfls.zip", list = TRUE)

## 2.1.3 Unzip
unzip("mxfls.zip")


# 2.1.4 Import data¶
df = read.dta("hh02dta_bc/c_ls.dta")


# 2.2 Directly from url

url = 'https://www.macrohistory.net/app/download/9834512569/JSTdatasetR5.xlsx?t=1623599312'
download.file(url, 'Macro.xlsx')


## Install readxl library
install.packages('readxl')
library(readxl)
df_macro = read_excel('Macro.xlsx', sheet=2) #Reads second sheet


## 2.3 Download from github
# Remember you have to have the raw data link

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/excess-deaths/deaths.csv'
df_covid = read.csv(url)

df_covid


# 3. Scraping

# Step 1
install.packages('rvest')
# Step 2
library(rvest)

# 3.1.1 Download webpage -- XML format¶
url =  "https://en.wikipedia.org/wiki/List_of_current_United_States_governors"

file = read_html(url)

file

# 3.1.2 Extract tables¶
tables = html_nodes(file, "table")


# 3.1.3
table1 = html_table(tables[2], fill=TRUE)

table1


