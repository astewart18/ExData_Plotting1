#Of the four types of sources indicated by the type (point, nonpoint, onroad,
#nonroad) variable, which of these four sources have seen decreases in emissions
#from 1999-2008 for Baltimore City? Which have seen increases in emissions from
#1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
library(dplyr)
library(ggplot2)

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
        
        x <- NEI %>% filter(fips == "24510") %>% group_by(year,type) %>% summarise(PM2.5=sum(Emissions))

        # Following is optional, but makes the chart look a little nicer with 
        # the right years on the x axis
        x$year<-as.factor(x$year)
        x$PM2.5<-x$PM2.5 # No need to scale
        
        png(filename="plot3.png")
        qplot(year,PM2.5,data=x,facets=type~.,main="Emissions in tons by type for Baltimore City")
        dev.off()
}
