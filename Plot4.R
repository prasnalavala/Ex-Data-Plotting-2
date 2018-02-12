# EDA - Week 4 Project 2
# The overall goal of this assignment is to explore the National Emissions 
# Inventory database and see what it says about fine particulate matter pollution
# in the USA over the 10-year period 1999-2008. Each part will address one question.

# Question 4
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999-2008?


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

#Now we look for only the observations that have "coal" listed somewhere in the Short.Name variable and then sum emissions by year. We then pass this to a new dataframe called coal
coal <- filter(mergedNEI,grepl('coal', Short.Name, ignore.case = TRUE)) %>%
        group_by(year) %>%
        summarize(coal_emissions = sum(Emissions))
coal
# Then, using ggplot2 plotting system we plot total emissions in the US from coal combustion-related sources by year by type
c <- ggplot(coal,aes(year,coal_emissions))
c+geom_point(size=2, col = "magenta")+geom_line(col="blue")+labs(x="Year",y="Coal Emissions")+ggtitle("Emissions in the US from coal combustion-related sources By Year")+ylim(300000,650000)

# We save the plot into a PNG file in our project folder
dev.copy(png, file = "./Project/Plot4.png", height = 480, width = 480)
dev.off()
