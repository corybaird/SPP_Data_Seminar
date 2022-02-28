install.packages(c("httr", "jsonlite", "lubridate",'dplyr'))
library(httr)
library(jsonlite)
library(lubridate)
library(dplyr)

# API examples
# 1. https://api.unhcr.org/docs/index.html#tag-Query (Today's example)
# 2. http://api.epdb.eu/#key


# 1. API basics
# API: Application Programming Interface
## Allows you to access data directly from a website
## Sometimes requires an API key which you have to register for

# API: UNHCR
# URL: https://api.unhcr.org/docs/index.html#tag-Query

## 1.1 GET function: from httr library
# This "gets" our data
url = 'http://api.unhcr.org/rsq/v1/categories'
r = GET(url = url)
r

### 1.1.1 Check status
# Status code of 200 indicates it worked
r$status_code

## 1.2 Convert data:
### 1.2.1 Show type of data
r$headers$`content-type`

### 1.2.2 Show content of our data
r$content
typeof(r$content)

### 1.2.3 Convert: unicode -> JSON
data_json = rawToChar(r$content)

### 1.2.4 Convert: JSON -> list
data = fromJSON(data_json)
typeof(data)

### 1.2.5 Convert: List -> dplyr dataframe
data = data %>% 
  as_tibble()

data %>% 
  head(4)


# 2. Download API information
## 2.A Function
unhcr = function(url){
  r = GET(url)
  data_json = rawToChar(r$content)
  data = fromJSON(data_json)
  data = data %>% as_tibble()
  return (data)
}

## 2.1 GET/years
#https://api.unhcr.org/docs/index.html#_ga=2.52075757.595735619.1644892776-343795404.1644892776
url = 'http://api.unhcr.org/rsq/v1/years'
unhcr(url)

## 2.2 GET /years/demographics
url = 'http://api.unhcr.org/rsq/v1/years/demographics'
unhcr(url)

# 2.3 GET /asylums
unhcr('http://api.unhcr.org/rsq/v1/asylums')

# 2.4 
df_sub = unhcr('http://api.unhcr.org/rsq/v1/origins/submissions')
#unhcr('http://api.unhcr.org/rsq/v1/origins/departures')
#unhcr('http://api.unhcr.org/rsq/v1/origins/demographics')

# 3. Download API data
unhcr_download = function(url){
  r = GET(url)
  if (r$status_code == 200){
    data_json = rawToChar(r$content)
    data = fromJSON(data_json)
    data = data$results %>% as_tibble()
    return (data)
  }else{
    print('Failed to download data')
  }
}

## 3.1 Download total year
url = 'http://api.unhcr.org/rsq/v1/submissions?year=2018'
unhcr_download(url)

url = 'http://api.unhcr.org/rsq/v1/submissions?year=2017%2C2018'
unhcr_download(url)


## 3.2 Download year and origin
### 3.2.1 Search country code names
df_sub %>% 
  select(code)

## 3.2.2 Specifiy country origin
url = 'http://api.unhcr.org/rsq/v1/submissions?year=2016%2C2017&origin=AFG%2CSYR'
df = unhcr_download(url)
df
