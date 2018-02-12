# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 5
# How have the emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?


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

#Now we look for only the Baltimore observations that have"onroad" or "nonroad" listed in the Data.Category variable and then sum emissions by year. We then pass this to a new dataframe called BCMotor
BCMotor <- filter(mergedNEI,fips =="24510",Data.Category %in% c("Nonroad","Onroad")) %>%
        group_by(year) %>%
        summarize(motor_emissions = sum(Emissions))
BCMotor
# Then, using ggplot2 plotting system we plot total emissions by year in Baltimore City by year
m <- ggplot(BCMotor,aes(year,motor_emissions))
m+geom_point(size=2, col = "red")+geom_line(col="darkgreen")+labs(x="Year",y="Emissions from motor vehicle sources")+ggtitle("Emissions in the Baltimore City (Onroad and Nonroad) By Year")

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot5.png")
dev.off()
