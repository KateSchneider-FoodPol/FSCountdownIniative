#Total pesticides per unit of land (kg/ha) 
setwd ("~/Downloads")
pesticides_data <- read.csv("pesticides.csv",sep = "," ,header = TRUE)
View(pesticides_data)

#Check why there is the missing value in the wb_region
library(tidyverse)
library(janitor)
pesticides_data %>% filter(is.na(wb_region)) #print any value that I want, which is NA here
tabyl(pesticides_data$wb_region) #create the frequency of how many wb regions are in the dataset
pesticides_data$wb_region[pesticides_data$wb_region == ""] <- NA #transforming any missing value in wb_region (which is blank in pesticides data) into "NA"

#Create a new dataset without wb_region = NA with the name "pesticides_data_byregion" 
pesticides_data_byregion <- subset(pesticides_data, pesticides_data$wb_region != "NA")
View(pesticides_data_byregion)

#Create line graphs over time by region (line for each region with the average value)
library(ggplot2)
ggplot(pesticides_data_byregion, aes(x = year, y = pesticides, color = wb_region)) + 
  stat_summary(geom = "line", fun.y = mean) + labs(x = "Year", y = "Pesticides") + 
  ggtitle("Total pesticides per unit of land (kg/ha)") + 
  scale_x_discrete(name ="Year",limits=c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019))

#Create new dataset only with select column for the map of 2019 data only with the name "pesticides_data2019" 
pesticides_data2019 <- subset(pesticides_data,select = c(country, year,pesticides))
pesticides_data2019 <- pesticides_data2019 [which(pesticides_data2019$year=="2019"),]
View(pesticides_data2019)

#Create a world map that makes a connection between country (without the code so it will be "NAME") and the column country_name 
library(rworldmap)
pesticides_map <- joinCountryData2Map(pesticides_data2019, joinCode = "NAME", nameJoinColumn = "country")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(pesticides_map, nameColumnToPlot="pesticides" , mapTitle = "Total pesticides per unit of land (kg/ha), 2019", colourPalette = c("#e0f3db","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#0868ac","#084081"), oceanCol = "gray", missingCountryCol = 'white') 



