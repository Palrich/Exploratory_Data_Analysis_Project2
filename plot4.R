## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Using the ggplot2 package
library(ggplot2)

## Merge our data so that it is possible to filter out keyword: "coal" to determine change from coal combustion-related sources
pmDataMerge <- merge(pmData, SCC, by="SCC")
filterCoal  <- grepl("coal", pmDataMerge$Short.Name, ignore.case = TRUE)
coalSubset <- pmDataMerge[filterCoal, ]

## Aggregate to find the total amount of coal emissions per year
coalTotal <- aggregate(Emissions ~ year, coalSubset, sum)

## Plotting the data
png("plot4.png", width=640)
coalPlot <- ggplot(coalTotal, aes(year, Emissions))
coalPlot <- coalPlot + geom_line(size = 1, color = "blue") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions (Tons)")) +
        ggtitle('Total Coal Source Emissions From 1999-2008')
print(coalPlot)
dev.off()