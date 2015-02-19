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

#Use grep to filter out which SCC refer to motor vehicles and put them in SCC.ID:
SCC.motor <- grep("vehicles", SCC$EI.Sector, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.motor.ID <- as.character(SCC.motor$SCC)
NEI.motor <- NEI[NEI$SCC %in% SCC.motor.ID, ]

#Subset based on Baltimore (fips = "24510) and LA County (fips = "06037"), 
#group by year and summarize using dplyr:
NEI.motor.city <- subset(NEI.motor, fips == "24510" | fips == "06037")
NEI.motor.city <- NEI.motor.city %>%
  group_by(fips, year) %>%
  summarise(emissions = sum(Emissions)) %>%
  mutate(county = ifelse(fips == "06037", "LA County", "Baltimore City"))

p <- ggplot(NEI.motor.city, aes(year, emissions)) + 
  geom_point(aes(color = county), pch = 19) + 
  geom_line(aes(color = county), lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ " (tons)")) + 
  ggtitle("Total emissions based on motor vehicles in Baltimore City\nvs. Los Angeles County 1999-2008") +
  theme(plot.title = element_text(face = "bold")) + 
  scale_color_discrete(name = "US County")

#Save the plot to "plot6.png"
png("plot6.png", height = 480, width = 700)
print(p)
dev.off()