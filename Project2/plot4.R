# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999-2008?
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
        
        # Need to filter the SSC codes to find only those related to coal combustion
        # The definition is a little hazy, and in real world I would ask questions...
        # Answer I have decided to assume is inspired from a post by Community TA Al Warren
        # I am just going to look for "coal" in the EI.Sector
        # Of course, it could be more complex (after all, lignite, anthracite and peat 
        # are types of coal, and maybe some of the SCC with coal do not involve combustion),
        # but this is the assumption that I will go with, please believe I could  
        scc.indices <- grep("*coal*", SCC$EI.Sector, ignore.case=T)
        scc.coal <- as.character(SCC$SCC[scc.indices])
        
        # Discard all readings that do not meet the criteria 
        x <- NEI[NEI$SCC %in% scc.coal,]
                         
        x <- x  %>% group_by(year) %>% summarise(PM2.5=sum(Emissions))
        
        # Following is optional, but makes the chart look a little nicer with 
        # the right years on the x axis
        x$year<-as.factor(x$year)
        x$PM2.5<-x$PM2.5 # No need to scale
        
        png(filename="plot4.png")
        qplot(year,PM2.5,data=x,main="Coal combustion related Emissions in tons across USA", geom="boxplot")
        dev.off()
}
