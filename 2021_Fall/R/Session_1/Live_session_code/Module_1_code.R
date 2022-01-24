
# A.1 How to use R-studio

# Upper left hand: Write code
# Lower left hand: Where the code outputs
# Upper right hand: variables and data 
# Lower right hand: Files



# A.2 Notes on installing packages
# Step 1
install.packages('LIBRARY') #Note this is an example: LIBRARY package does not exist
# Step 2
library(LIBRARY)



# 1. How to save data
## 1.1 Saving text (a.k.a. string objects)¶

# Save string
ANYTHING = 'New string'

# Save number
poverty_line = 100

# Save list
salary = c(100, 200, 400)


# 2. Import (save) excel data¶
# Function: read.csv("FILENAME.csv")

df = read.csv('vote.csv')


# 2.2 Read csv file in sub-folder¶

df_arrests = read.csv('Sub_folder/arrests.csv')


# 3. Basics of the dataframe¶
# 3.1 Display: first lines of the dataframe¶
head(df_arrests, 3)

head(df, 5)

# 3.2 Display: column names¶
names(df_arrests)
names(df)

# 3.3 Display: summary stats¶
summary(df_arrests)
summary(df)

# 4. Individual column manipulation¶

names(df)

df$income

df$vote

# Show mean
mean(df$vote)

# Show standard deviation
sd(df$income)








