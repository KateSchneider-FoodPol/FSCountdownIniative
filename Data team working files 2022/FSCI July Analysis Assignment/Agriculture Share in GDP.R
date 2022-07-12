#Share of agriculture in GDP 

setwd ("~/Downloads")
agshareGDP_data <- read.csv("agshareGDP.csv",sep = "," ,header = TRUE)
View(agshareGDP_data)

#Check why there is the missing value in the wb_region
library(tidyverse)
library(janitor)
tabyl(agshareGDP_data$wb_region) #create the frequency of how many wb regions are in the dataset
agshareGDP_data$wb_region[agshareGDP_data$wb_region == ""] <- NA #transforming any missing value in wb_region (which is blank in the dataset) into "NA"
agshareGDP_data %>% filter(is.na(wb_region)) #print any value that I want, which is NA here

#Create a new dataset without wb_region = NA with the name "pesticides_data_byregion" 
agshareGDP_data_byregion <- subset(agshareGDP_data, agshareGDP_data$wb_region != "NA")
View(agshareGDP_data_byregion)

#Create line graphs over time by region (line for each region with the average value)
library(ggplot2)
ggplot(agshareGDP_data_byregion, aes(x = year, y = aginGDP, color = wb_region)) + 
  stat_summary(geom = "line", fun.y = mean) + labs(x = "Year", y = "Share of agriculture in GDP") + 
  ggtitle("Share of agriculture in GDP (% GDP)") + 
  scale_x_discrete(name ="Year",limits=c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020))

#Create new dataset only with select column for 2019 only
agshareGDP_data2019 <- subset(agshareGDP_data,select = c(country, year,aginGDP))
agshareGDP_data2019 <- agshareGDP_data2019 [which(agshareGDP_data2019$year=="2019"),]
View(agshareGDP_data2019)

#Create a world map that makes a connection between country (without the code so it will be "NAME") and the column country_name 
library(rworldmap)
agshareGDP_map <- joinCountryData2Map(agshareGDP_data2019, joinCode = "NAME", nameJoinColumn = "country")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(agshareGDP_map, nameColumnToPlot="aginGDP" , mapTitle = "Share of agriculture in GDP, 2019", colourPalette = c("#e0f3db","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#0868ac","#084081"), oceanCol = "gray", missingCountryCol = 'white') 

