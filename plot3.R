## Using the package ggplot2 and RColorBrewer
require(ggplot2, RColorBrewer, quietly = TRUE)
library(ggplot2)
library(RColorBrewer)

cols <- brewer.pal(4, "Set1")

## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subsetting the data for fips == 24510, the code for Baltimore City
baltimore <- subset(pmData, fips == 24510)

## Getting total emission by pollutant type for Baltimore City
baltimoreCityEmissionPollutionTotals <- aggregate(Emissions ~ year + type, baltimore, sum)

## Plotting the graph
png("plot3.png", width = 640)
bptPlot <- ggplot(baltimoreCityEmissionPollutionTotals, aes(year, Emissions, color = type))
bptPlot <- bptPlot + 
        geom_line(size = 1) + 
        scale_color_hue(l = 30) +
        scale_color_manual(values = cols, 
                           name = "Type",
                           labels=c("Non-Road", "Nonpoint", "On-Road", "Point")) +
        xlab("Year") + 
        ylab(expression("Total PM"[2.5] * " Emissions (Tons)")) +
        ggtitle(expression("Total Emissions Of PM"[2.5] * " in Baltimore City From 1999-2008"))
print(bptPlot)
dev.off()

