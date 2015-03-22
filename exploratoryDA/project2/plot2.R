library(dplyr)
filename <- "exdata-data-NEI_data.zip"
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile="exdata-data-NEI_data.zip", method="curl", mode="wb")
  dateDownloaded <- date()
  unzip("exdata-data-NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
#filter the data set for Baltimore City
baltimore_data <- filter(NEI,fips == "24510")
# select year and Emissions from NEI data set, group by on year and then sum it on Emissions
year_emissions <- summarize(group_by(select(baltimore_data, year,Emissions),year),sum(Emissions))
#make the plot in png file
png(file="plot2.png")
plot(year_emissions$year, year_emissions$"sum(Emissions)",xaxt="n", xlab="Year" , ylab="Total Emissions PM 2.5")
#set appropriate x axis
axis(1, at=year_emissions$year)
title(main = "Total PM 2.5 Emissions per Year for Baltimore",col.main="blue")
dev.off()
