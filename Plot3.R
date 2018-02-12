# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad)
# variable, which of these four sources have seen decreased in emissions from 1999-2008
# for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the
# ggplot2 plotting system to make a plot answer this question.


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

# After the data is read into R, we will subset emissions in Baltimore City. 
BCPM <- NEI[NEI$fips=="24510",]
BCPMSum <- aggregate(Emissions ~ year + type, BCPM,sum) # We sum up emissions grouped by year and type
BCPMSum # verify that the sum is calculated as expected

# Then, using ggplot2 plotting system we plot total emissions by year in Baltimore City by type 
g <- ggplot(BCPMSum,aes(year,Emissions, color=type))
g+geom_point(size=2)+geom_line()+labs(x="Year",y="Baltimore Emissions")+ggtitle("Total Emissions in Baltimore City for 1999-2008 by Type")

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot3.png", height = 480, width = 480)
dev.off()
