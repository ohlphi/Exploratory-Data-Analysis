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

#Use grep to filter out which SCC refer to motor vehicles and put them in SCC.ID:
SCC.motor <- grep("vehicles", SCC$EI.Sector, ignore.case = TRUE)
SCC.motor <- SCC[SCC.motor, ]
SCC.motor.ID <- as.character(SCC.motor$SCC)
NEI.motor <- NEI[NEI$SCC %in% SCC.motor.ID, ]

#Subset based on Baltimore (fips = "24510), group by year and summarize using dplyr:
NEI.motor <- subset(NEI.motor, fips == "24510")
NEI.motor <- NEI.motor %>%
  group_by(year) %>%
  summarise(emissions = sum(Emissions))

#Save the plot to "plo5.png"
png("plot5.png", width = 480, height = 480)
ggplot(NEI.motor, aes(year, emissions)) + 
  geom_point(color = "red", pch = 19) + 
  geom_line(color = "red", lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ " - motor vechicle related sources (tons)")) + 
  ggtitle("Total emissions of motor vechicle related\nsources in Baltimore City 1999-2008") +
  theme(plot.title = element_text(face = "bold", vjust = 1, lineheight = 1))
dev.off()