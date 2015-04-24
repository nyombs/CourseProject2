##Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008?
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
