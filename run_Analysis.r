####################################################################################
### Getting and Cleaning Data project from Coursera (030)
### 
### Purpose - create R Script called runAnalysis.r that does the following steps on the data from
### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable
#    for each activity and each subject. 
#
###################################################################################
#
# Part 1 - Merge the training and the test data sets to create one data set
# Concatenate the data tables by rows
# ? see read.me for exploratory analysis
#
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
#
# Set names to variables
#
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2
#
# Merge columns to get the data frame Data for all data
#
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)
#
# Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
#
# This creates a subset of Features by measurements on the mean and standard deviation
# Looks at Names of Features for "mean()" or "std()" 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
#
# This creates a subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
#
# Part 3 - Uses descriptive activity names to name the activities in the data set
#
# Reads descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
#
# Part 4 - Appropriately labels the data set with descriptive variable names
#
# Variables activity and subject and names of the activities have been labelled
# using descriptive names.
# Now Names of Features will be labelled using descriptive variable names.
#
# List of variables being renamed:
# f (prefix) is replaced by frequency
# t (prefix) is replaced by time
# Acc is replaced by Accelerometer
# Gyro is replaced by Gyroscope
# Mag is replaced by Magnitude
# BodyBody is replaced by Body
#
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
#
# Part 5 - From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and subject.
#
library(plyr);
# Create new table with the mean (average) of each subject & activity variables
# based on the data from Part 4.
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
# Creating and exporting the data set 
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
