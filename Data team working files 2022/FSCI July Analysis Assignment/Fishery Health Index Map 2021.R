# Remove everything that might be in your R working space from previous analyses:
rm(list = ls())

# Set working directory and read the csv file of fish health data by separating header with "," 
setwd("~/Downloads")
fishhealth_data <- read.csv("fishhealth.csv",sep = ",",header = TRUE)
View(fishhealth_data)

#Create a world map that makes a connection between country (without the code so it will be "NAME") and the column country_name 
library(rworldmap)
fishhealth_map <- joinCountryData2Map(fishhealth_data, joinCode = "NAME", nameJoinColumn = "country")
par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
mapCountryData(fishhealth_map, nameColumnToPlot="fishhealth" , mapTitle = "Fishery Health Index, 2021", colourPalette = c("#e0f3db","#ccebc5","#a8ddb5","#7bccc4","#4eb3d3","#2b8cbe","#0868ac","#084081"), oceanCol = "gray", missingCountryCol = 'white') 