# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 6
# Compare the emissions from motor vehicles in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California (fips=="06037").
# Which city has seen greater changes over time in motor vehicle emissions?


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

# After the data is read into R, we will merge the two datasets 
mergedNEI <- merge(x = NEI, y = SCC, by = "SCC", all.x=TRUE)  # by adding all.x, we make it into a left outer join

#Now we look for only the Baltimore and Los Angeles observations that have"onroad" or "nonroad" listed in the Data.Category variable and then sum emissions by year. We then pass this to a new dataframe called BCLAMotor
BCLAMotor <- filter(mergedNEI,fips %in% c("24510","06037"),Data.Category %in% c("Nonroad","Onroad")) %>%
        group_by(year,fips) %>%
        summarize(motor_emissions = sum(Emissions))

## For clearly understanding which fips code is for Baltimore and which one is for LA, we will reassign with the appropriate names
BCLAMotor$fips[BCLAMotor$fips=="24510"] <- "Baltimore, MD" 
BCLAMotor$fips[BCLAMotor$fips=="06037"] <- "Los Angeles, CA"
BCLAMotor
# Then, using ggplot2 plotting system we plot total emissions by year in Baltimore City by year
m <- ggplot(BCLAMotor,aes(year,motor_emissions))
m+geom_point(size=2, col = "red")+geom_line(col="blue")+labs(x="Year",y="Emissions from motor vehicle sources")+ggtitle("Emissions in Baltimore City and LA (Onroad and Nonroad) By Year")+facet_grid(.~fips)

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot6.png")
dev.off()
