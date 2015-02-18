library(dplyr)
library(ggplot2)

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


#Subset based on Baltimore (fips = "24510), group by type and year, and summarize using dplyr:
baltimore <- subset(NEI, fips == "24510")
baltimore <- baltimore %>%
  group_by(type, year) %>%
  summarize(emissions = sum(Emissions))

#Save the plot to "plo3.png"
png("plot3.png", width = 480, height = 480)
ggplot(baltimore, aes(year, emissions)) + 
  geom_point(aes(color = type), pch = 19) + 
  geom_line(aes(color = type), lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ "based on source (tons)")) + 
  ggtitle("Total emissions based on type - Baltimore City 1999-2008") +
  theme(plot.title = element_text(face = "bold")) + 
  scale_color_discrete(name = "Type of source")
dev.off()

