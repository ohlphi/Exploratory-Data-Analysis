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


#Use grep to filter out which SCC refer to coal and put them in SCC.ID:
SCC.coal <- grep("coal", SCC$EI.Sector, ignore.case = TRUE)
SCC.coal <- SCC[SCC.coal, ]
SCC.ID <- as.character(SCC.coal$SCC)
NEI.coal <- NEI[NEI$SCC %in% SCC.ID, ]

#Group by year and summarize using dplyr:
NEI.coal <- NEI.coal %>%
  group_by(year) %>%
  summarise(emissions = sum(Emissions))

#Save the plot to "plo4.png"
png("plot4.png", width = 480, height = 480)
ggplot(NEI.coal, aes(year, emissions/1000)) + 
  geom_point(color = "red", pch = 19) + 
  geom_line(color = "red", lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ " - coal combustion-related sources (ktons)")) + 
  ggtitle("Total emissions of coal combustion-related\nsources in the US 1999-2008") +
  theme(plot.title = element_text(face = "bold", vjust = 1, lineheight = 1))
dev.off()
