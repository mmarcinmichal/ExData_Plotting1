#
# Script to create plot2, i.e. four different plots from 2007-02-01 to 2007-02-02
#

#
# Clear workspace
#
rm(list = ls())

#
# Set language to En
#
Sys.setlocale(category = "LC_ALL", locale = "english")

#
# URL to zipped dataset
#
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#
# Download file
#
download.file(url, "./tmp.zip")

#
# Unzip archive
#
unzip("./tmp.zip")

#
# Remove archive
#
file.remove("./tmp.zip")

#
# Read data
#
fileName <- "household_power_consumption.txt"

dataDf <- read.csv(fileName, sep = ";", stringsAsFactors = F, na.strings = "?", 
                   header = T, quote = "", colClasses = c("character", "character", "numeric",
                                                          "numeric", "numeric", "numeric",
                                                          "numeric", "numeric", "numeric"))

dataDf$Date <- as.Date(dataDf$Date, "%d/%m/%Y")

# Check dim, data and data format:
# - Required number of Instances: 2075259
# - Required number of Attributes: 9
dim(dataDf)

head(dataDf)
str(dataDf)

#
# Create two subsets, i.e. 2007-02-01, and 2007-02-02 
#
firstDf <- subset(dataDf, Date == "2007-02-01")
secondDf <- subset(dataDf, Date == "2007-02-02")

bindedDf <- rbind(firstDf, secondDf)

x <- paste(bindedDf$Date, bindedDf$Time)
x <- strptime(x, "%Y-%m-%d %H:%M:%S")

#
# Create and save plot2
#
ylimMin <- min(c(bindedDf$Sub_metering_1, bindedDf$Sub_metering_2, bindedDf$Sub_metering_3))
ylimMax <- max(c(bindedDf$Sub_metering_1, bindedDf$Sub_metering_2, bindedDf$Sub_metering_3))

png("./figure/plot4.png", width = 480, height = 480)

par(mfrow=c(2,2))
# First plot
plot(x, bindedDf$Global_active_power,  xlab = "", ylab = "Global active power (kilowatts)", type = "l")

# Second plot
plot(x, bindedDf$Voltage,  xlab = "datetime", ylab = "Voltage", type = "l")

# Third plot
plot(x, bindedDf$Sub_metering_1,  xlab = "", ylab = "Energy sub metering", type = "l", col = "black", ylim = c(ylimMin, ylimMax))
par(new = T)
plot(x, bindedDf$Sub_metering_2,  xlab = "", ylab = "", type = "l", col = "red", ylim = c(ylimMin, ylimMax))
par(new = T)
plot(x, bindedDf$Sub_metering_3,  xlab = "", ylab = "", type = "l", col = "blue", ylim = c(ylimMin, ylimMax))

legend(x = "topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=c(1,1,1), cex=0.8)

# Fourth plot
plot(x, bindedDf$Global_reactive_power,  xlab = "datetime", type = "l")

dev.off()
