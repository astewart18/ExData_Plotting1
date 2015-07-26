# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

library(dplyr)

file<-"summarySCC_PM25.rds"

if (!file.exists(file)){
        stop(paste("Cannot find",file,"in local directory"))
} else {
        if(!exists("NEI")) {
                message("Reading in the data. This could take some time...")
                NEI <- readRDS(file)
        } else { 
                message("Data already read in for previous plot.")
                ## If data needs to be refreshed, rm(NEI) and run the script again
        }        
        x <- NEI %>% group_by(year) %>% summarise(PM2.5=sum(Emissions))
        
        # Following is optional, but makes the chart look a little nicer with the right 
        # years on the x axis
        x$year<-as.factor(x$year)
        x$PM2.5<-x$PM2.5/1000000
        
        png(filename="plot1.png")
        plot(x, main="Emissions in millions of tons - USA")
        dev.off()
}

