## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == 24510) from 1999 to 2008?
##read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Get the total sum of all PM25-PRI pollutants between 1999-2008
baltimoreData <- subset(NEI, NEI$fips == "24510")
total <- aggregate(NEI[which(baltimoreData$year >= 1999 & baltimoreData$year <= 2008 & baltimoreData$Pollutant == "PM25-PRI"),]$Emissions, by = list(Year = baltimoreData$year , Pollutant = baltimoreData$Pollutant), sum)
# rename column
names(total)[3] <- "Emission"
total$Emission <- total$Emission/1000 #converting in Kilo tons
#open the png device
png(file = "plot2.png",  width=960, height = 480)
##plot it
plot(total$Year, as.numeric(total$Emission),  xlab = "year", ylab = "Total Emissions (Tons)", main = "Total PM2.5 emission from Baltimore (fips = 24510)", type = "l", col = "red")

##close png device
dev.off()