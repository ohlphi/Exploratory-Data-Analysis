library(dplyr)
library(ggplot2)

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


#Subset based on Baltimore (fips = "24510), group by type and year, and summarize using dplyr:
baltimore <- subset(NEI, fips == "24510")
baltimore <- baltimore %>%
  group_by(type, year) %>%
  summarize(emissions = sum(Emissions))

p <- ggplot(baltimore, aes(year, emissions)) + 
  geom_point(aes(color = type), pch = 19) + 
  geom_line(aes(color = type), lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ " (tons)")) + 
  ggtitle("Total emissions based on type - Baltimore City 1999-2008") +
  theme(plot.title = element_text(face = "bold")) + 
  scale_color_discrete(name = "Type of source")

#Save the plot to "plot3.png"
png("plot3.png", height = 480, width = 700)
print(p)
dev.off()

