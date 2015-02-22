library(dplyr)
filename <- "uci_dataset.zip"
# if file does not exists then download it
if(!file.exists(filename)) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile=filename ,mode="wb", method="curl")
  dateDownloaded <- date()
  unzip(filename)  
}

#load the files. 
direc <- "./UCI HAR Dataset"
trainDir <- paste(direc,"train", sep="/")
testDir <- paste(direc,"test", sep = "/")
# training files
x_train <- read.table(paste(trainDir,"X_train.txt", sep="/"), strip.white=TRUE)
y_train <- read.table(paste(trainDir,"y_train.txt", sep="/"),strip.white=TRUE)
sub_train <- read.table(paste(trainDir,"subject_train.txt", sep="/"),strip.white=TRUE,stringsAsFactors=FALSE)

#testing files
x_test <- read.table(paste(testDir,"X_test.txt", sep="/"), strip.white=TRUE)
y_test <- read.table(paste(testDir,"y_test.txt", sep="/"),strip.white=TRUE)
sub_test <- read.table(paste(testDir,"subject_test.txt", sep="/"),strip.white=TRUE,stringsAsFactors=FALSE)

#load the column names
features <- read.table(paste(direc,"features.txt", sep="/"),stringsAsFactors=FALSE)
features[,2] <- gsub('-mean', 'Mean', features[,2])
features[,2] <- gsub('-std', 'Std', features[,2])
features[,2] <- gsub('[-()]', '', features[,2])
col_names <- c(features[,2],"ActivityNumber","Subject")


#load the activity names  ,"ActivityNumber","Subject" ,y_train, sub_train
activity <- read.table(paste(direc,"activity_labels.txt", sep="/"),stringsAsFactors=FALSE)
activity_name <- c(activity[,2])

# merge the training and testing ds
merged_ds <- rbind(cbind(x_train,y_train,sub_train) , cbind(x_test,y_test,sub_test))

# put the names in the merged ds.
names(merged_ds) <- col_names

# select and merge the mean and std
mean_ds <- merged_ds[,grepl("Mean", colnames(merged_ds), fixed=TRUE)]
std_ds <- merged_ds[,grepl("Std", colnames(merged_ds), fixed=TRUE)]
ActivityNumber <- merged_ds$ActivityNumber
Subject <- merged_ds$Subject
reqd_ds <- cbind(mean_ds,std_ds,ActivityNumber,Subject)

# add a column for activity name, derived from activity number.
reqd_ds <- mutate(reqd_ds, activityName = activity_name[ActivityNumber] )

# remove the activityNumber from the dataset.
reqd_ds <- select(reqd_ds,-ActivityNumber)

tidy <- aggregate(reqd_ds, by=list(reqd_ds$activityName,reqd_ds$Subject), mean)
# remove the last 2 columns, ActivityName and Subject does not make sense for it.  
tidy[,ncol(tidy)] = NULL
tidy[,ncol(tidy)] = NULL

write.table(tidy, "tidy.txt", row.names=FALSE)
