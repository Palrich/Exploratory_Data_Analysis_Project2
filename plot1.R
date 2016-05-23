## Reading the data (make sure you are in the directory where the RDS files have been extracted)
pmData <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Totaling the data for emissions across the years variable in the data
EmissionSumsYear <- with(pmData, tapply(Emissions, year, sum))

## Plotting the total emission
png("plot1.png")
with(pmData, plot(names(EmissionSumsYear), EmissionSumsYear, xlab = "Year",
     ylab = expression("Total PM"[2.5] * " Emissions (Tons)"),
     main = expression("Total PM"[2.5] * " Emissions From 1999-2008"), pch = 19))

## Regression Line
regLine <- lm(EmissionSumsYear ~ as.numeric(names(EmissionSumsYear)), pmData)
abline(regLine)

dev.off()
