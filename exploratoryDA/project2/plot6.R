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

# Now select all the rows from NEI that matches with SCC code in SCC dataset for Baltimore
filtered_NEI_balti <- filter(NEI, (NEI$SCC %in% selected_scc$SCC & fips=="24510"))

# Now select all the rows from NEI that matches with SCC code in SCC dataset for LA
filtered_NEI_la <- filter(NEI, (NEI$SCC %in% selected_scc$SCC & fips=="06037"))

# select year and Emissions from NEI data set, group by on year and then sum it on Emissions for Baltimore
year_emissions_balti <- summarize(group_by(select(filtered_NEI_balti, year,Emissions),year),sum(Emissions))

# select year and Emissions from NEI data set, group by on year and then sum it on Emissions for KA
year_emissions_la <- summarize(group_by(select(filtered_NEI_la, year,Emissions),year),sum(Emissions))

#make the plot in png file
png(file="plot6.png")
plot(year_emissions_balti$year, year_emissions_balti$"sum(Emissions)",xaxt="n", type="o" , xlab="Year" , ylab="Total Emission PM 2.5", col="blue")

par(new=TRUE)
#plot the LA data and don't plot the axes
plot(year_emissions_la$year, year_emissions_la$"sum(Emissions)",axes=FALSE, type="o" , col="red", xlab="", ylab="")

#set appropriate x axis
axis(1, at=year_emissions$year)
title(main = "Comparison of Total Emissions for LA & Baltimore")
legend("topleft", col=c("red", "blue"), legend=c("LA", "Baltimore"),lwd = 3, bty="n")
dev.off()
