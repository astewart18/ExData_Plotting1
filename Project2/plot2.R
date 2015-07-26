# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.
library(data.table)
library(dplyr)

file<-"summarySCC_PM25.rds"

if (!file.exists(file)){
        stop(paste("Cannot find",file,"in local directory"))
}
if(is.null(NEI)) {
        message("Reading in the data. This could take some time...")
        NEI <-readRDS(file)
} else { 
        message("Data already read in for previous plot.")
        ## If data needs to be refreshed, rm(NEI) and run the script again
}        
x <- NEI %>% filter(fips == "24510") %>% group_by(year) %>% summarise(PM2.5=sum(Emissions))

# Following is optional, but makes the chart look a little nicer with the right 
# years on the x axis
x$year<-as.factor(x$year)
x$PM2.5<-x$PM2.5/1000

png(filename="plot2.png")
plot(x, main="Emissions for Baltimore City", ylab="PM2.5 ('000 tons)")
dev.off()
# SCC <- readRDS("Source_Classification_Code.rds")
