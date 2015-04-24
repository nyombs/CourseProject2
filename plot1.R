##Plot1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, 
## make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
##read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Get the total sum of all PM25-PRI pollutants between 1999-2008
total <- aggregate(NEI[which(NEI$year >= 1999 & NEI$year <= 2008 & NEI$Pollutant == "PM25-PRI"),]$Emissions, by = list(Year = NEI$year , Pollutant = NEI$Pollutant ), sum)
# rename column
names(total)[3] <- "Emission"
total$Emission <- total$Emission/1000 #converting in Kilo tons
#open the png device
png(file = "plot1.png",  width=960, height = 480)
##plot it
plot(total$Year, as.numeric(total$Emission),  xlab = "year", ylab = "Total Emissions (Tons)", main = "Total PM2.5 emission from all sources", type = "l", col = "red")

##close png device
dev.off()