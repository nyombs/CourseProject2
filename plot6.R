##Plot6 
##How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City vs. LA? 

##read files, this is where we need the SCC
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


##Stage 1: get the right data====================
##from SCC, find the motor vehicles related sources. Get their SCC code used in NEI - we'll use those to subset NEI.
##The best bet is column EI.Sector 
##find the unique fuel type SCC column 4, and from there extract the ones with motor vehicles
##there are 59 unique EI.Sector, from which 4 with Mobile - On-Road (assumption: Mobile - Non-Road equipment is NOT a motor VEHICLE)
##Mobile - On-Road Gasoline Light Duty Vehicles     
##Mobile - On-Road Gasoline Heavy Duty Vehicles
##Mobile - On-Road Diesel Light Duty Vehicles
##Mobile - On-Road Diesel Heavy Duty Vehicles

##move the dataframe into a matrix, for easier manipulation (at least for me )
matrixSCC<-as.matrix(SCC)

##subset it to only the rows where EI.Sector (column 4) has one of the motor vehicles
motorVehicles<-subset(matrixSCC, matrixSCC[, 4] == "Mobile - On-Road Gasoline Light Duty Vehicles" | matrixSCC[, 4] == "Mobile - On-Road Gasoline Heavy Duty Vehicles" | matrixSCC[, 4] == "Mobile - On-Road Diesel Light Duty Vehicles" | matrixSCC[, 4] == "Mobile - On-Road Diesel Heavy Duty Vehicles")

##get the SCC field from matrixSCC, as this is going to be the key to subset NEI
codesForNEI<-motorVehicles[, 1]

##now subset NEI by these codes
motorVehiclesNEI<-subset(NEI, as.character(NEI$SCC) %in% codesForNEI)

##subset for Baltimore
mvBalt<-subset(motorVehiclesNEI, motorVehiclesNEI$fips == "24510")

##subsetting by years, to use in some calculations
y99<-subset(mvBalt, mvBalt$year == "1999")
y02<-subset(mvBalt, mvBalt$year == "2002")
y05<-subset(mvBalt, mvBalt$year == "2005")
y08<-subset(mvBalt, mvBalt$year == "2008")

##data for the first plot, that will show the average emissions by year
mmData<-data.frame(year = c("1999", "2002", "2005", "2008"), 
                   means = c(mean(y99$Emissions), mean(y02$Emissions), mean(y05$Emissions), mean(y08$Emissions)),
                   medians = c(median(y99$Emissions), median(y02$Emissions), median(y05$Emissions), median(y08$Emissions)))

##new data frame that gets the SCC codes, their Source Type and the Emissions in one place <- for the 3rd plot
dSCC<-data.frame(code = motorVehicles[, 1], SourceType = motorVehicles[, 4])
dmvNEI <-data.frame(code = mvBalt$SCC, Emissions = mvBalt$Emissions, year = mvBalt$year)
dataForPlot<-merge(dSCC, dmvNEI, by = "code")

##subset for LA
mvBaltLA<-subset(motorVehiclesNEI, motorVehiclesNEI$fips == "06037")

##subsetting by years, to use in some calculations
y99LA<-subset(mvBaltLA, mvBaltLA$year == "1999")
y02LA<-subset(mvBaltLA, mvBaltLA$year == "2002")
y05LA<-subset(mvBaltLA, mvBaltLA$year == "2005")
y08LA<-subset(mvBaltLA, mvBaltLA$year == "2008")

##data for the first plot, that will show the average emissions by year
mmDataLA<-data.frame(year = c("1999", "2002", "2005", "2008"), 
                   means = c(mean(y99LA$Emissions), mean(y02LA$Emissions), mean(y05LA$Emissions), mean(y08LA$Emissions)),
                   medians = c(median(y99LA$Emissions), median(y02LA$Emissions), median(y05LA$Emissions), median(y08LA$Emissions)))

##new data frame that gets the SCC codes, their Source Type and the Emissions in one place <- for the 3rd plot
dSCC<-data.frame(code = motorVehicles[, 1], SourceType = motorVehicles[, 4])
dmvNEI <-data.frame(code = mvBalt$SCC, Emissions = mvBalt$Emissions, year = mvBalt$year)
dmvNEILA <-data.frame(code = mvBaltLA$SCC, Emissions = mvBaltLA$Emissions, year = mvBaltLA$year)
dataForPlot<-merge(dSCC, dmvNEI, by = "code")
dataForPlotLA<-merge(dSCC, dmvNEILA, by = "code")


#rename the long SourceTypeValues
# Fuel Comb - Electric Generation - Coal => Electric Generation
# Fuel Comb - Industrial Boilers, ICEs - Coal => Industrial Boilers, ICEs
# Fuel Comb - Comm/Institutional - Coal => Comm/Institutional
dataForPlot$SourceType <- gsub("^(Mobile - On-Road )", "", dataForPlot$SourceType, perl = TRUE)
dataForPlotLA$SourceType <- gsub("^(Mobile - On-Road )", "", dataForPlotLA$SourceType, perl = TRUE)

###plot it =============================
##i'll do 2 plots:  
##one that show the mean per year to underline the trends
##one that shows the details of changes by types of emissions sources


##open the png device
png(file = "plot5.png", width=960, height = 960)

##averages plot
plot1 = ggplot(mmData, aes(year, means)) + labs(title = "Average of emissions Baltimore")+geom_point(aes(color = year, size = 10))+labs(y = "Average value of emissions")+geom_line(aes(group=1))

##overall emissions plot
plot2 = ggplot(mmDataLA, aes(year, means)) + labs(title = "Average of emissions LA")+geom_point(aes(color = year, size = 10))+labs(y = "Average value of emissions")+geom_line(aes(group=1))


##emissions split by groups of Source Types
plot3 = qplot(year, Emissions, data = dataForPlot, facets=.~SourceType, color = year, main = "Changes of emissions, by type of emission source (Baltimore)", method="lm", geom = c("point", "smooth"))

plot4 = qplot(year, Emissions, data = dataForPlotLA, facets=.~SourceType, color = year, main = "Changes of emissions, by type of emission source (LA)", method="lm", geom = c("point", "smooth"))

grid.arrange(plot1, plot2, plot3, plot4, ncol=1, main = "Emissions generated by motor vehicle in Baltimore vs. LA")

##close png device
dev.off()
