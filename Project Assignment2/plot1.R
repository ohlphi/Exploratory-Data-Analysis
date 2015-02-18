library(dplyr)

#Download and extract the zip file:
if(!file.exists("Source_Classification_Code.rds") & !file.exists("summarySCC_PM25.rds")) {
  if(!file.exists("exdata-data-NEI_data.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                  destfile = "exdata-data-NEI_data.zip") #,method = "curl")
    unzip("exdata-data-NEI_data.zip")
  } else {
    unzip("exdata-data-NEI_data.zip")
  }
    
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Group by year and summarize the total emissions using dplyr:
pm25 <- NEI %>%
  group_by(year) %>%
  summarize(emissions = sum(Emissions))

#Save the plot to "plot1.png"
png("plot1.png", width = 480, height = 480)
plot(pm25$year, pm25$emissions/1000, 
     xlab = "Year", 
     ylab = "Total emissions - all sources (ktons)", pch = 19,
     main = expression("Total emissions of PM"[2.5] ~ "in the US 1999-2008"))
lines(pm25$year, pm25$emissions/1000)
dev.off()
