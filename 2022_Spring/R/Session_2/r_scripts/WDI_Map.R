install.packages('WDI')
library(WDI)

# Import data
indicator_list =  c("NY.GDP.PCAP.KD", #GDP
                    "SP.POP.DPND" # Age dependency
                    )
df_wdi = WDI(
  country = "all",
  indicator = indicator_list,
  start = 1980,
  end = 2020,
  extra = TRUE
)

# Create 2020 data
df_wdi_2020 = df_wdi%>% filter(year == 2020)

# Rename
df_wdi_2020 = df_wdi_2020 %>% 
  rename('lng'='longitude',
         'lat' = 'latitude',
         'gdp' = 'NY.GDP.PCAP.KD')

# Change data type
df_wdi_2020 = df_wdi_2020 %>% 
  mutate(
    lng = as.integer(lng),
    lat = as.integer(lat),
  ) 

# Filter NA
df_wdi_2020 = 
  df_wdi_2020 %>% 
  filter(lng!='NA' & lat!='NA')


# Map
leaflet() %>% 
  addProviderTiles("CartoDB") %>% 
  addCircleMarkers(data=df_wdi_2020,
                   radius = 2, 
                   color = "red", 
                   lng = lng,
                   lat = lat,
                   popup=~gdp)





