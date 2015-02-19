library(dplyr)

#Download, extract the files and then remove the zipfile:
##REMEMBER TO REMOVE "method='curl'" IF YOU'RE ON A WINDOWS!
if(!file.exists("Source_Classification_Code.rds") & !file.exists("summarySCC_PM25.rds")) {
  if(!file.exists("exdata-data-NEI_data.zip")) {
    temp <- tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileUrl, temp, method = "curl")
    unzip(temp)
    unlink(temp)
  } else {
    unzip(temp)
    unlink(temp)
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
png("plot2.png", height = 480, width = 700)
plot(baltimore$year, baltimore$emissions, 
     xlab = "Year", 
     ylab = "Emissions of PM"[2.5] ~ " (tons)", pch = 19, col = "blue",
     main = expression("Total emissions of PM"[2.5] ~ "in Baltimore City 1999-2008"))
lines(baltimore$year, baltimore$emissions, col = "blue")
dev.off()
