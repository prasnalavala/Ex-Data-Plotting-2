# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999-2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008.

# First we create a new folder for the project and download the files and unzip them in the project folder.

if (!file.exists("./Project")){
        dir.create("./Project")
}
zipfileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(zipfileURL,destfile = "./Project/NEI_data.zip")

if (!file.exists("./Project/NEI_data")) {
        unzip("./Project/NEI_data.zip", exdir="./Project")
}

# Then we read them into R and look at them to see what kind of information they contain.
# The PM2.5 file (NEI) is very large and takes a little time to read in.
library(dplyr)
library(ggplot2)
NEI <- readRDS("./Project/summarySCC_PM25.rds")
SCC <- readRDS("./Project/Source_Classification_Code.rds")
summary(NEI)
dim(NEI)
head(NEI, nrow = 5)
summary(SCC)
dim(SCC)
head(SCC, nrow = 5)

# After the data is read into R, we will sum total emissions by year in the US. 
totalemissions <- NEI %>%
        group_by(year) %>%
        summarize(total_emissions = sum(Emissions))
totalemissions

# Then, using base plotting system we plot total emissions by year in the US 
with(totalemissions, {plot(year, total_emissions, pch=19, col="blue", main = "Total Emissions By Year")
        lines(year, total_emissions)})
# Answer - Yes, the total emissions in the United States have declined from 1999-2008

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot1.png", height = 480, width = 480)
dev.off()
