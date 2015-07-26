# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips ==
# "06037"). Which city has seen greater changes over time in motor vehicle
# emissions?
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
        # Filter out all fips except Baltimore and LA County                 
        x <- x  %>% filter(fips == "24510" | fips == "06037") %>% group_by(year,fips) %>% summarise(PM2.5=sum(Emissions))
        
        # Following is optional, but makes the chart look a little nicer with 
        # the right years on the x axis
        x$year<-as.factor(x$year)
        x$PM2.5<-x$PM2.5 # No need to scale
        # Could translate the fips values to descriptive names
        # but this is course specifically indicates not too much effort
        # should go into labelling etc... so fips code should do
        png(filename="plot6.png")
        qplot(year,PM2.5,data=x,col=fips,main="Motor vehicle related Emissions in tons")
        dev.off()
}
