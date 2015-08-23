###################################
#Assignment week 3
###################################

## Coursera Getting and Cleaning Data Course Project

#Project Data location 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#Step 1
#Create one R script called run_analysis.R that does the following: 

#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive variable names. 

#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.


##########################################################################################################

# Clean up workspace if needed
rm(list=ls())

#set working directory where contents of the class project files were unzipped to on my local drive
setwd("C:/JohnsHopkins/Class3_GettingandCleaningData/Week3_Subsetting_working_with_Data/Project_Week3");

# Read in the data from files rom the working directory set up for this project
mydata1<- read.table('./Test/X_test.txt')
mydata2<- read.table('./Test/Y_test.txt')
mydata3<- read.table('./Test/subject_test.txt')
#combine the datasets  part 1
test <- cbind(mydata1, mydata2, mydata3)

# Read in the data from files rom the working directory set up for this project
mydata4<- read.table('./Train/X_train.txt')
mydata5<- read.table('./Train/Y_train.txt')
mydata6<- read.table('./Train/subject_train.txt')
train <- cbind(mydata4, mydata5, mydata6)

#combine the datasets  part 2
dataSubject <- rbind(mydata3, mydata6)
dataActivity<- rbind(mydata2, mydata5)
dataFeatures<- rbind(mydata1, mydata4)

#Assess the files and review the structure and data content
str(mydata1)
str(mydata2)
str(mydata3)
str(mydata4)
str(mydata5)
str(mydata6)


names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
#Reference additinal dataset fromt he working directory
dataFeaturesNames <- read.table(file.path('./features.txt')
names(dataFeatures)<- dataFeaturesNames$V2

#Combine the two parts of aggregated datasets
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Assess the structure and contents of the combined datasets
str(Data) #10299 obs and 563 variables

#Extracts only the measurements on the mean and standard deviation for each measurement. 
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
selectedNames
Data<-subset(Data,select=selectedNames)
#Assess the structure and contents of the combined datasets
str(Data) #10299 obs and 68 variables

#activityLabels <- read.table(file.path("C:/JohnsHopkins/Class3_GettingandCleaningData/Week3_Subsetting_working_with_Data/Project_Week3/activity_labels.txt"),header = FALSE)
activityLabels <- read.table(file.path('./activity_labels.txt')

head(activityLabels)

#Clean up the names of the files
#Appropriately labels the data set with descriptive variable names. 
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("-std$","StdDev", names(Data))
names(Data)<-gsub("-mean","Mean", names(Data))
names(Data)<-gsub("([Gg]ravity)","Gravity", names(Data))

#Review the changes made to the names
names(Data)

#Aggregate by mean
library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
#Create an independent tidy data set with the average of each variable for each activity and each subject.
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

