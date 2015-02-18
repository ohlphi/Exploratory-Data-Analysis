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

#Create the plot and save it to "plot3.png":
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2), mar=c(4,4,2,1), oma=c(1,0,2,1))
with(consumptionFeb, {
  plot(dateTime, Global_active_power, 
       type= "l",xlab = "", ylab = "Global Active Power")
  plot(dateTime, Voltage,
       type="l", xlab = "datetime", ylab = "Voltage")
  plot(dateTime, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(dateTime, Sub_metering_2, type = "l", col = "red")
  lines(dateTime, Sub_metering_3, type = "l", col = "blue")
  legend("topright", col = c("black", "red", "blue"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
         lty = 1, lwd = 1, bty = "n")
  plot(dateTime, Global_reactive_power, type = "l", 
       xlab = "datetime", 
       ylab = "Global_reactive_power")
})
dev.off()
