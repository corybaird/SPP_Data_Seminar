
install.packages(c('stringr', 'leaflet','dplyr'))
library(stringr)

library(dplyr)

# Side note: lists
# R: lists
my_list = c('stringr', 'leaflet','dplyr')
# Python lists:
# my_list = ['stringr', 'leaflet','dplyr']


install.packages('ggplot2')
library(ggplot2)


url = 'https://raw.githubusercontent.com/corybaird/PLCY_Code_2020_winter/5b3de6227410c37e56db6bdf35f5693c769bd980/Code_sessions/Session_1/gapminder.csv'
df = read.csv(url)

df %>% 
  head(5)

df %>% 
  filter(country == 'Afghanistan') %>% 
  ggplot(aes(x = year, y=lifeExp)) + geom_point()
  

url = 'https://raw.githubusercontent.com/corybaird/PLCY_610_public/master/Reference_materials/Tutorials_R_Stata_Python/R/W3_ggplot/global_covid.csv'
df = read.csv(url)
head(df,3)


df %>%
  filter(confirm>10000) %>% 
  ggplot(aes(x=name, y=confirm)) + geom_bar(stat="identity",fill='blue')

## 2.3 Line charts

url = 'https://raw.githubusercontent.com/corybaird/PLCY_610_public/master/Reference_materials/Tutorials_R_Stata_Python/R/W3_ggplot/Covid_TS_global.csv'
df = read.csv(url)
df %>% head(2)

df %>% 
  str()

df$date = as.Date(df$date)

df %>% 
  mutate(
    date_new = as.Date(df$date)
  ) %>% 
  str()

# Mutate: Create or edit column
df = df %>% 
  mutate(
    date = as.Date(df$date)
  )

japan = df %>% filter(country=='Japan')
head(japan,2)

japan %>% 
  ggplot(aes(x=date, y=confirmed)) + geom_line(alpha=0.5)

# Example of when character is the x axis
japan %>% 
  mutate(
    date = as.character(date)
  ) %>% 
  ggplot(aes(x=date, y=confirmed)) + geom_line(alpha=0.5)

df %>% 
  select(country) %>% 
  unique()

df %>% 
  filter(country=='Italy'| country=="US" | country=='Vietnam') %>% 
  ggplot(aes(x=date, y=confirmed)) + geom_line(aes(color = country))

install.packages('gridExtra')
library(gridExtra)

df_us_italy = df %>% 
  filter(confirmed>1000)  %>%  
  filter(country=='Italy'| country=="US")

plot1 =  df_us_italy %>% 
  ggplot(aes(x=date, y=confirmed)) + geom_line(aes(color=country))
  

plot2 = df %>% filter(deaths>100) %>%filter(country=='Italy'| country=="US") %>% 
  ggplot(aes(x=date, y=deaths)) + geom_line(aes(color=country))

grid.arrange(plot1, plot2, ncol=2)

# 3. Mapping
install.packages('leaflet')
library(leaflet)

# Lists
## Create list
provider_list = names(providers) #Shows first 5 in provider list

# Subset list
provider_list[c(5:10)]

# Filter list
filter = str_detect(provider_list, "France")
provider_list[filter]

# Filter list function
filter_function = function(STRING_NAME){
  filter = str_detect(provider_list, STRING_NAME)
  res = provider_list[filter]
  return (res)
}
filter_function('Esri')


leaflet() %>%
  addProviderTiles("Esri.NatGeoWorldMap")


#Enter longitude and latitude
long = -76.948270
lat = 38.983640
# Create map
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addMarkers(lng = long, 
             lat = lat, 
             popup = 'SPP')

url = "https://assets.datacamp.com/production/repositories/1942/datasets/18a000cf70d2fe999c6a6f2b28a7dc9813730e74/ipeds.csv"
ipeds = read.csv(url)
ipeds %>% head(3)

map = leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addCircleMarkers(data=ipeds,
                   radius = 2,
                   color = "blue", 
                   popup=~name)



leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addCircleMarkers(
    data = ipeds, 
    radius = 2, 
    popup = ~paste0(name, "<br/>","<br/>", sector_label))

string_1 = 'Cory likes python'
string_2 = 'after his morning coffee'
paste(string_1, string_2)

pal <- colorFactor(palette = c("red", "blue", "#9b4a11"), 
                   levels = c("Public", "Private", "For-Profit"))

install.packages('leaflet.extras')
library(leaflet.extras)
library(htmltools)

# Create data frame called public with only public colleges
public <- ipeds %>% filter(sector_label == "Public")  
profit <- ipeds %>%filter(sector_label == "For-Profit")  
private <- ipeds %>% filter(sector_label == "Private")

m4 <- leaflet() %>% 
  #Adding three sep maps part 1
  addTiles(group = "OSM") %>% 
  addProviderTiles("CartoDB", group = "Carto") %>% 
  addProviderTiles("Esri", group = "Esri")

m4  = m4 %>% addCircleMarkers(data = public, radius = 2, label = ~htmlEscape(name),
                              color = ~pal(sector_label), group = "Public") %>% #Public
  
  addCircleMarkers(data = private, radius = 2, label = ~htmlEscape(name),
                   color = ~pal(sector_label), group = "Private")  %>% #Private
  
  addCircleMarkers(data = profit, radius = 2, label = ~htmlEscape(name),
                   color = ~pal(sector_label), group = "For-Profit")

