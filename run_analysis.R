## Getting Data
zipFileName <- "./UCI_HAR_Dataset.zip";
if(!file.exists(zipFileName))
{
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
  download.file(fileUrl,destfile=zipFileName,method="curl");
}
if(!file.exists("UCI HAR Dataset"))
{
  unzip(zipFileName);
}else
{
  setwd("./UCI HAR Dataset/");
}

## Reading features.txt
featureTable <- read.table("features.txt")

## Reading in Train Data files
xTrain <- read.table("./train/X_train.txt")
yTrain <- read.table("./train/y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")

colnames(xTrain) <- featureTable[, 2]
names(yTrain) <- "ActivityId"
names(subjectTrain) <- "SubjectID"

trainDataSet <- cbind(xTrain,yTrain,subjectTrain)

## Reading in Test Data files
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")
subjectTest <- read.table("./test/subject_test.txt")

colnames(xTest) <- featureTable[, 2]
names(yTest) <- "ActivityId"
names(subjectTest) <- "SubjectID"

testDataSet <- cbind(xTest,yTest,subjectTest)

## 1. Merges the training and the test sets to create one data set
completeDataSet <- rbind(trainDataSet,testDataSet)

## 2. Extract only the measurements on the mean and standard deviation for each measurement
selectIndex <- grep("-(mean|std)\\(\\)", colnames(completeDataSet))
completeDataSet <- completeDataSet[,c(selectIndex,562,563)]

## 3. Use descriptive activity names to name the activities in the data set
activityTable <- read.table("activity_labels.txt",stringsAsFactors = F)
completeDataSet[,"ActivityId"] <- sapply(completeDataSet[,"ActivityId"],function(x) return(activityTable[x,2]))

## 4. Appropriately labels the data set with descriptive variable names. 
colnames(completeDataSet)[67:68] <- c("Activity","Subject")
1
## 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
finalTidySet <- ddply(.data = completeDataSet,c("Activity","Subject"),colwise(mean))
write.table(finalTidySet,"tidy_data.txt",row.names=F,sep = ",");
## Reset working directory.
setwd("../")