# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 2
# Have total emissions from PM2.5 decreased in Baltimore City, Maryland (fips = 24510)
# from 1999 - 2008? Use the base plotting system to make a plot answering this question


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

# After the data is read into R, we will pass the dataframe thru filter function (available thru dplyr package)
# and sum emissions only for Baltimore City
Baltimoreemissions <- filter(NEI, fips == "24510") %>%
        group_by(year) %>%
        summarize(BC_emissions = sum(Emissions))
Baltimoreemissions

# Then, using base plotting system we plot total emissions by year in Baltimore City
with(Baltimoreemissions, barplot(height = BC_emissions, names.arg = year, col="darkolivegreen4", main = "Baltimore City Emissions By Year",xlab = "Years",ylab = "Baltimore Emissions"))
# Answer - Yes, the total emissions in Baltimore City, Maryland have declined from 1999-2008

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot2.png", height = 480, width = 480)
dev.off()
