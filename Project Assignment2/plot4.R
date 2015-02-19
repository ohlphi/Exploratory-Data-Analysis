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


#Use grep to filter out which SCC refer to coal and put them in SCC.ID:
SCC.coal <- grep("coal", SCC$EI.Sector, ignore.case = TRUE)
SCC.coal <- SCC[SCC.coal, ]
SCC.ID <- as.character(SCC.coal$SCC)
NEI.coal <- NEI[NEI$SCC %in% SCC.ID, ]

#Group by year and summarize using dplyr:
NEI.coal <- NEI.coal %>%
  group_by(year) %>%
  summarise(emissions = sum(Emissions))

p <- ggplot(NEI.coal, aes(year, emissions/1000)) + 
  geom_point(color = "red", pch = 19) + 
  geom_line(color = "red", lwd = 0.7) + 
  labs(x = "Year", y = expression("Emissions of PM"[2.5] ~ " (ktons)")) + 
  ggtitle("Total emissions of coal combustion-related\nsources in the US 1999-2008") +
  theme(plot.title = element_text(face = "bold", vjust = 1, lineheight = 1))

#Save the plot to "plot4.png"
png("plot4.png", height = 480, width = 700)
print(p)
dev.off()
