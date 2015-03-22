library(dplyr)
library(ggplot2)
filename <- "exdata-data-NEI_data.zip"
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile="exdata-data-NEI_data.zip", method="curl", mode="wb")
  dateDownloaded <- date()
  unzip("exdata-data-NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
baltimore_data <- filter(NEI,fips == "24510")

finaldata <- summarize(group_by(select(baltimore_data, year,Emissions,type),year,type),sum(Emissions))
finaldata$Pollutant_Type <- finaldata$type
plot3 <- qplot(finaldata$year, finaldata$"sum(Emissions)", data = finaldata, group = Pollutant_Type, 
      color = Pollutant_Type, 
      geom = c("point", "line"), ylab = expression("Total Emissions, PM"[2.5]), 
      xlab = "Year", main = "Total Emissions in U.S. by Type of Pollutant")

ggsave("plot3.png",plot3)