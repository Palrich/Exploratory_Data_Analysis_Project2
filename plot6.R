## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Using the ggplot2 package
library(ggplot2)
library(RColorBrewer)

cols <- brewer.pal(4, "Spectral")

## Filter for keyword "vehicle" in SCC dataset
filterMotorVehicle <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)

## Find all rows of SCC codes in SCC that correspond to our filter 
vehicleSource <- SCC[filterMotorVehicle, ]$SCC

## Find similar codes from vehicleSource inside of our main dataset, pmData, and subset pmData based off of that
mergeSCC <- pmData[pmData$SCC %in% vehicleSource, ]

## Subset by fip for Baltimore City motor emissions
baltimoreMotorEmissions <- mergeSCC[mergeSCC$fips=="24510", ]
baltimoreMotorEmissions$city <- "Baltimore"

## Subset by fip for Los Angeles County motor emissions
LosAngelesMotorEmissions <- mergeSCC[mergeSCC$fips=="06037", ]
LosAngelesMotorEmissions$city <- "Los Angeles"

## Row bind Baltimore and Los Angeles emission data
comparisonMotorEmissions <- rbind(baltimoreMotorEmissions, LosAngelesMotorEmissions)

## Plot the data
png("plot6.png",width = 640)
comparisonPlot <- ggplot(comparisonMotorEmissions, aes(x = factor(year), y = Emissions, fill = city)) +
        geom_bar(aes(fill = factor(year)), stat = "identity") +
        facet_grid(. ~ city) +
        scale_fill_manual(values = cols) +
        guides(fill = FALSE) +
        labs(x = "Year", y = expression("PM"[2.5]*" Emissions (Tons)")) + 
        labs(title = expression("PM"[2.5]*" Emissions of Motor Vehicles, Baltimore and Los Angeles 1999-2008"))
print(comparisonPlot)
dev.off()