# How have emissions from motor vehicle sources changed from 1999-2008 in
# Baltimore City?
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
        SCC <- readRDS("Source_Classification_Code.rds")
        
        # Need to filter the SSC codes to find only those related to motor
        # vehicles The definition is a little hazy, and in real world I would
        # ask questions... Answer I have decided to assume is inspired from a
        # post by Community TA Al Warren I am just going to look for "vehicles"
        # in SCC.Level.Two. Of course, it could be more complex (there are other
        # ways to select, eg take SCC.Level.One Internal Combstion Engines), but
        # this is the assumption that I will go with for this example.
        scc.indices <- grep("*vehicles*", SCC$SCC.Level.Two, ignore.case=T)
        scc.vehicular <- as.character(SCC$SCC[scc.indices])
        
        # Discard all readings that do not meet the criteria 
        x <- NEI[NEI$SCC %in% scc.vehicular,]
                         
        x <- x  %>% filter(fips == "24510") %>% group_by(year) %>% summarise(PM2.5=sum(Emissions))
        
        # Following is optional, but makes the chart look a little nicer with 
        # the right years on the x axis
        x$year<-as.factor(x$year)
        x$PM2.5<-x$PM2.5 # No need to scale
        
        png(filename="plot5.png")
        qplot(year,PM2.5,data=x,main="Motor vehicle related Emissions in tons in Baltimore City")
        dev.off()
}
