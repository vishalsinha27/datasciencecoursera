library(dplyr)
filename <- "exdata-data-NEI_data.zip"
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl, destfile="exdata-data-NEI_data.zip", method="curl", mode="wb")
  dateDownloaded <- date()
  unzip("exdata-data-NEI_data.zip")
}

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds") 

# select all the rows which has coal in short.name
selected_scc <- filter( SCC, grepl("motor", SCC$Short.Name, ignore.case = TRUE))

# Now select all the rows from NEI that matches with SCC code in SCC dataset
filtered_NEI <- filter(NEI, (NEI$SCC %in% selected_scc$SCC & fips=="24510"))

# select year and Emissions from NEI data set, group by on year and then sum it on Emissions
year_emissions <- summarize(group_by(select(filtered_NEI, year,Emissions),year),sum(Emissions))

#make the plot in png file
png(file="plot5.png")
plot(year_emissions$year, year_emissions$"sum(Emissions)",xaxt="n", type="o" , xlab="Year" , ylab="Total Emissions PM 2.5")
#set appropriate x axis
axis(1, at=year_emissions$year)
title(main = "Total Emissions per Year for Motor Vehicle",col.main="blue")
dev.off()
