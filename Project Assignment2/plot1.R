library(dplyr)

#Download, extract the files and then remove the zipfile:
if(!file.exists("Source_Classification_Code.rds") & !file.exists("summarySCC_PM25.rds")) {
  if(!file.exists("exdata-data-NEI_data.zip")) {
    temp <- tempfile()
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileUrl, temp) #method = "curl"
    unzip(temp)
    unlink(temp)
  } else {
    unzip(temp)
    unlink(temp)
  }
  
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Group by year and summarize the total emissions using dplyr:
pm25 <- NEI %>%
  group_by(year) %>%
  summarize(emissions = sum(Emissions))

#Save the plot to "plot1.png"
png("plot1.png", height = 480, width = 700)
plot(pm25$year, pm25$emissions/1000, 
     xlab = "Year", 
     ylab = "Emissions of PM"[2.5] ~ " (ktons)", pch = 19, col = "blue",
     main = expression("Total emissions of PM"[2.5] ~ "in the US 1999-2008"))
lines(pm25$year, pm25$emissions/1000, col = "blue")
dev.off()
