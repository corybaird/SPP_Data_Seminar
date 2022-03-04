
# A. Install packages
# Step 1
install.packages('downloader')
install.packages('dplyr')
install.packages('filesstrings')
install.packages('ggplot2')
install.packages('caret')
install.packages("Metrics")
install.packages('gbm')

# Step 2
library(downloader)
library(dplyr)
library(filesstrings)
library(ggplot2)
library(caret)
library(Metrics)
library(gbm)


# B. Download
## B.1 Download
url = 'https://github.com/corybaird/SPP_Data_Seminar/blob/main/2022_Spring/R/Session_3/Input/kiva_data.zip?raw=true'
download.file(url, 'kiva.zip')

## B.2 Unzip folder
unzip('kiva.zip')

## B.3 Get file names in list
files = unzip('kiva.zip', list = TRUE)$Name

# B.4 Create new folder
dir.create('Input')

# B.5 Move files into folder
move_files(files, "Input", overwrite=TRUE)

# 1. EDA: Exploratory data analysis
## 1.A Import data
df = read.csv('Input/kiva_loans.csv', sep =',')

## 1.1 Explore data
### 1.1.1 Data types
df %>% 
  str()
df %>% 
  glimpse()

### 1.1.2 Data summary
df %>% 
  summary()

### 1.1.3 NA values
#### 1.1.3.1 Show nas for each colum
df %>% 
  summarise(across(everything(), ~ sum(is.na(.))))

#### 1.1.1.3.2 Omit all na rows
df = df %>% 
  na.omit()

### 1.2 Explore countries and dates
#### 1.2.1 Dates
### 1.2.1.A Convert to datetime
df = df %>% 
  mutate(date= as.Date(disbursed_time))

df %>% 
  select(date) %>% 
  head(5)

#### 1.2.1.B Create year column

df = df %>% 
  mutate(year = format(date, '%Y'),
         month = format(date, '%m')) 

df %>% 
  select(date, year, month) %>% 
  slice(10:20)


# 1.2.1.1 Show years
df %>% 
  group_by(year) %>% 
  count()

# Graph
df %>% 
  group_by(year) %>% 
  count() %>% 
  ggplot(aes(x = year, y = n)) + geom_bar(stat = 'identity')

### 1.2.2 Countries
df %>% 
  group_by(year) %>% 
  count(country) %>% 
  ggplot(aes(fill=country, x=year, y=n))+ 
  geom_bar(stat="identity")


### 1.2.3 Loan amount
#### 1.2.3.1 Histogram
df %>% 
  group_by(year) %>% 
  summarise(loan_mean = mean(loan_amount)) %>% 
  ggplot(aes(x=year, y=loan_mean))+ 
  geom_bar(stat="identity")

#### 1.2.3.2 Histogram
df %>% 
  select(loan_amount) %>% 
  summary() 

df %>% ggplot(aes(x = loan_amount)) + 
  geom_histogram(bins =10, color="black", fill="white")

# 2. Manipulate
## 2.1 Remove countries
### 2.1.1 Create list of countries with fewer than 2000 observations
country_list = df %>% 
  count(country) %>% 
  arrange(n, ascending=FALSE) %>% 
  filter(n<50000 & n>15000) %>% 
  pull(country) %>% 
  list()
country_list = country_list[[1]]

#### 2.1.2 Remove using filter function
df = df %>% 
  filter(country %in% country_list)

### 2.1.3 Show remaining countries
df %>% 
  select(country) %>% 
  unique()

### 2.1.2 Remove large loans
df %>% 
  select(loan_amount) %>% 
  summary()

df = df %>% filter(loan_amount<=200)

## 2.2 Convert column data
df %>% 
  str()

df = df %>% 
  mutate(country = as.factor(country),
         activity = as.factor(activity),
         sector = as.factor(sector),
         borrower_genders = as.factor(borrower_genders)
         )

df %>% 
  str()

# 3. Linear regression
## 3.1 Inference

reg = lm(loan_amount ~ term_in_months + lender_count + activity, 
         data = df)
summary(reg)


## 3.2 Prediction
reg_train = train(loan_amount ~ term_in_months + lender_count + activity,
                  method = 'lm',
                  data = df)

### 3.2.1 Extract prediction
df = df %>% 
  mutate(predict_reg = predict(reg_train))

df %>% 
  select(loan_amount, predict_reg) %>% 
  head(10)

### 3.2.1.1 Plot prediction vs actual
df %>% 
  select(loan_amount, predict_reg) %>% 
  ggplot(aes(loan_amount, predict_reg)) + geom_point()


#### 3.2.2 Model evaluation
#### 3.2.2.1 RMSE

## By hand
rmse_hand = function(acutal, predicted){
  error = predicted - acutal
  rmse = sqrt(mean(error^2))
  return(rmse)
}
rmse_hand(df$loan_amount, df$predict_reg)

## function from metrics library
rmse(df$loan_amount, df$predict_reg)

#### 3.2.2.2 MAE
mae(df$loan_amount, df$predict_reg)

mae_hand = function(acutal, predicted){
  error = abs(predicted - acutal)
  mae = sum(error)/length(predicted)
  return(mae)
}
mae_hand(df$loan_amount, df$predict_reg)

# 4. ML Models
## 4.1 Decision trees
model_dt = train(
  loan_amount ~ term_in_months + lender_count + activity, 
  data=df,
  method = 'rpart'
  )


### 4.1.1 Model evaluation 
df = df %>% 
  mutate(predict_dt = predict(model_dt))

mae_hand(df$loan_amount, df$predict_dt)

model_dt
model_

## 4.2 Gradient boosting
### 4.2.A parallel computing
install.packages('doParallel')
library(doParallel)
cl <- makePSOCKcluster(8)
registerDoParallel(cl)

# Model
model_gbm = train(
  loan_amount ~ term_in_months + lender_count + activity, 
  data=df,
  method = 'gbm'
)

### 4.2.1 Model evaluation 
### 4.2.1.A Add to df
df = df %>% 
  mutate(predict_gbm = predict(model_gbm))

### 4.2.1.1 Results
model_gbm$results






