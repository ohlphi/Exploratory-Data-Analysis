#Read the data:
consumption <- read.table("household_power_consumption.txt", header=TRUE, 
                          sep = ";", na.strings = "?", stringsAsFactors = FALSE)

#Convert column Date to date, in order to subset: 
consumption$Date <- as.Date(consumption$Date, "%d/%m/%Y")
consumptionFeb <- subset(consumption, Date >= "2007-02-01" & Date <= "2007-02-02")
rm(consumption)

#Create a new column with both date and time:
dateTime <- paste(as.Date(consumptionFeb$Date), consumptionFeb$Time)
consumptionFeb$dateTime <- strptime(dateTime, "%Y-%m-%d %H:%M:%S")

#Create the plot and save it to "plot2.png":
png("plot2.png", width = 480, height = 480)
plot(consumptionFeb$dateTime, consumptionFeb$Global_active_power, 
     type="l",xlab="", ylab = "Global Active Power (kilowatts)")
dev.off()
