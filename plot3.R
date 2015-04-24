##read files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
# Get the total sum of all PM25-PRI pollutants between 1999-2008
baltimoreData <- subset(NEI, NEI$fips == "24510")
##open png device
png(file="plot3.png", width=960, height = 480)

##plot
qplot(year, Emissions, data=baltimoreData, facets=.~type, binwidth =10, color = type, method = "lm", geom = c("point", "smooth"), main = "Baltimore City: Emissions trend from 1999 to 2008",  ylab = "Emissions (tons)")

##close png device
dev.off()
