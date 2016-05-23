## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subsetting the data for fips == 24510, the code for "Baltimore City"
baltimore <- subset(pmData, fips == 24510)

## Totaling the data for emissions in Baltimore City from 1999-2008
baltimoreCityTotals <- aggregate(Emissions ~ year, baltimore, sum)

## Plotting the total emission for Baltimore City from 1999-2008
png("plot2.png")
with(baltimoreCityTotals, plot(baltimoreCityTotals$year,
                               baltimoreCityTotals$Emissions,
                               xlab = "Year",
                               ylab = expression("Total PM"[2.5] * " Emissions (Tons)"),
                               main = expression("Total PM"[2.5] * " Emissions in Baltimore City From 1999-2008"),
                               pch = 19))

## Regression Line
regLine <- lm(baltimoreCityTotals$Emissions ~ baltimoreCityTotals$year, baltimoreCityTotals)
abline(regLine)

dev.off()