## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Using the ggplot2 package
library(ggplot2)

## Filter for keyword "vehicle" in SCC dataset
filterMotorVehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)

## Find all rows of SCC codes in SCC that correspond to our filter 
vehicleSource <- SCC[filterMotorVehicle, ]$SCC

## Find similar codes from vehicleSource inside of our main dataset, pmData, and subset pmData based off of that
mergeSCC <- pmData[pmData$SCC %in% vehicleSource, ]

## Subset for by fip for Baltimore City motor emissions
baltimoreMotorEmissions <- mergeSCC[mergeSCC$fips=="24510", ]

## Get motor emission totals
baltimoreMotorTotal <- aggregate(Emissions ~ year, baltimoreMotorEmissions, sum)

## Plotting the data
png("plot5.png", width = 640)
motorPlot <- ggplot(baltimoreMotorTotal, aes(year, Emissions)) +
        geom_line(size = 1, color = "red") +
        labs(x = "Year", y = expression("Total PM"[2.5]*" Emissions (Tons)")) + 
        labs(title = expression("PM"[2.5]*" Total Baltimore City Motor Vehicle Emissions 1999-2008"))
print(motorPlot)
dev.off()
