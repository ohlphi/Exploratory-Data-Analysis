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

#Subset based on Baltimore (fips = "24510), group by year and summarize using dplyr:
baltimore <- subset(NEI, fips == "24510")
baltimore <- baltimore %>%
  group_by(year) %>%
  summarize(emissions = sum(Emissions))

#Save the plot to "plot2.png"
png("plot2.png", width = 480, height = 480)
plot(baltimore$year, baltimore$emissions, 
     xlab = "Year", 
     ylab = "Baltimore City emissions - all sources (tons)", pch = 19,
     main = expression("Total emissions of PM"[2.5] ~ "in Baltimore City 1999-2008"))
lines(baltimore$year, baltimore$emissions)
dev.off()
