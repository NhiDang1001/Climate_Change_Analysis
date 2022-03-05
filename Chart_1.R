library(ggplot2)
library(plotly)
library(dplyr)
library(scales)
library(tidyr)
library(tidyverse)
library("mapproj")
library("maps")
library("rbokeh")
library("shiny")


climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

# Choose a few countries
top_countries <- c("Vietnam", "China", "Malaysia", "United States")

# Filter the dataframe for only those countries
top_climate <- climate_data %>%filter(year >= 2000 & year <= 2020) %>%  filter(country %in% top_countries)

# Make an interacive scatterplot of oil co2 per capita
climate_plot <- ggplot(data = top_climate) +
  geom_line(aes(x = year, y = coal_co2_per_capita, color = country))+
  labs(title = 'Coal Co2 Per Capita Across Countries 2000-2020', y= 'Oil Co2 Per Capita', x = 'Year')
ggplotly(climate_plot)


#Which country has the highest cumulative oil CO2 within the last 50 years?
high_country <- climate_data %>%
  filter(year >= 1970 & year <= 2020) %>%
  group_by(country) %>%
  summarize(amount_gas_co2 = sum(gas_co2_per_capita, na.rm = T)) %>% filter(amount_gas_co2 == max(amount_gas_co2)) %>%
  pull(country)

#Top 5 countries and its iso_code with lowest amount of co2 per capita:

climate_data <- climate_data %>% mutate(location = paste(country,'-', iso_code))

low_country <- climate_data %>% group_by(location) %>% 
  summarize(amount_co2 =sum(co2_per_capita, na.rm = T)) %>% arrange(desc(amount_co2)) %>% slice(1:5) %>% pull(location)


#Location (country abd its iso_code) that is the lowest net exporter (lowest negative trade_co2_share)
lowest_location <- climate_data %>% group_by(location) %>% filter(trade_co2_share < 0) %>% 
  summarize(trade_share = sum(trade_co2_share, na.rm = T)) %>% filter(trade_share == min(trade_share)) %>% 
  pull(location)
  

#Location (country abd its iso_code) that is the highest net importer (highest positive trade_co2_share)
highest_location <- climate_data %>% group_by(location) %>% filter(trade_co2_share > 0) %>% 
  summarize(trade_share = sum(trade_co2_share, na.rm = T)) %>% filter(trade_share == min(trade_share)) %>% 
  pull(location)

#Compare co2 per capita between US and Vietnam

co2_per_year <- climate_data %>%
  filter(year >= 1970 & year <= 2020) %>%
  group_by(year) %>%
  summarize(Vietnam = sum(co2_per_capita, na.rm = T),
            United_States = sum(co2_per_capita, na.rm = T))

trend_data <- pivot_longer(co2_per_year, 2:3, names_to = "Country", values_to = "total_co2_per_capita")

compare <- ggplot(data = trend_data) +
  geom_col(mapping= aes(x=year, y = total_co2_per_capita, fill = Country), position = "dodge") +
  labs(title = 'Total CO2 per capita Vietnam vs US from 2010 to 2020', x='Year', y='Total CO2 Per Capita') 
ggplotly(compare)

hello1 <- climate_data %>% group_by(country)
hello2 <- climate_data %>% group_by(year)
hello <- climate_data %>% filter(country %in% hello1) %>% filter (year %in% hello2)
