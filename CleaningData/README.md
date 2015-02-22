## Getting and Cleaning Data. Course project - cleaning data description.

Step 1 Check if the data file is already downloaded. If not then download the file and unzip it. 

Step 2 Load the test and train files. 

Step 3 Load the activity files. Replace the mean and std with proper name.

Step 4 cbind the x, y and activity number files loaded in step 2

Step 5 rbind the test and train data.

Step 6 add the column names loaded in step 3

Step 7 select the columns which has mean or std in it using grep function.

Step 8 cbind the ActivityNumber and Subject to the dataset and generate merged_ds

Step 9 From the activity number use dplyr package mutate function to map the activity number to activity name

Step 10 Remove the activity number from data set merged_ds

Step 11 Use aggregate function to generate a tidy dataset. Use activity name and subject to do group_by. Pass mean as the function to get the mean.

Step 12 Write tidy data to filesystem. 

