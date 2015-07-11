# Get the zip file

zipfile<-"./household_power_consumption.zip"

if (!file.exists(zipfile)){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",destfile=zipfile)
}
toprow <- read.table(unz(zipfile, "household_power_consumption.txt"), sep=";", header=TRUE, skip=0, nrows=1)
data <- read.table(unz(zipfile, "household_power_consumption.txt"), sep=";", header=FALSE, skip=66637, nrows=2879)
names(data)<-names(toprow)

data$Time<-strptime(paste(data$Date,data$Time),"%d/%m/%Y %H:%M:%S")
data$Date<-strptime(data$Date,"%d/%m/%Y")

png(filename="plot3.png")
with(data,{
        plot(Time,Sub_metering_1,type="n",xlab="",ylab="Energy sub metering")
        lines(Time,Sub_metering_1,col="black")
        lines(Time,Sub_metering_2,col="red")
        lines(Time,Sub_metering_3,col="blue")
        legend("topright", lty=1, col = c("black","red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()