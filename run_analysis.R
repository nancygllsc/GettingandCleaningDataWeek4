#run_analysis.R
#test2
# Checking if folder already exists.
library(dplyr)
if(!file.exists("rawData.zip")){
    fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL,"rawData.zip", method = "curl")
}
# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
    unzip("rawData.zip") 
}
# 1. get data
#   1.1 get test data and create table 1 
test_Y_test<- read.table("UCI HAR Dataset/test/y_test.txt")
test_X_test<- read.table("UCI HAR Dataset/test/x_test.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
Participants_test_ID<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "ParticipantID")

#   1.1.2 get variable names
variables_names<- read.table("UCI HAR Dataset/features.txt", col.names = c("ID","functions"))
variablesNames <- c(variables_names$functions)

#   1.1.3 add variable names to table test_X 
setColNamesTest<-setNames(test_X_test,variablesNames)
#   1.1.4 create final test table 
TestDFfinal<- cbind(setColNamesTest,ActivityLabelID=test_Y_test$V1, ParticipantID=Participants_test_ID$ParticipantID)
# 1.2 get train data
#   1.2.1 train data set 
train_X_train<- read.table("UCI HAR Dataset/train/x_train.txt")
train_Y_train<- read.table("UCI HAR Dataset/train/Y_train.txt",col.names = "labels")
Participants_train_ID<- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "ParticipantID")
#   1.2.2 create and add variables name to train table.
TrainDFNamesTrain<- setNames(train_X_train,variablesNames)
#   1.2.3 create final train table
TrainDFFinal <- cbind(TrainDFNamesTrain,ActivityLabelID=train_Y_train$labels,ParticipantID=Participants_train_ID$ParticipantID) 
# 2. join train and test final tables 
TrainandTest_ExperimentData=rbind(TestDFfinal,TrainDFFinal)
#3. select columns containing the mean and standard deviation for each measurement. 
TidyTable_MeansandSD<-select(TrainandTest_ExperimentData,contains("mean")|contains("std")|contains("ID"))
#4. creates a second, independent tidy data set with the average of each variable for each activity and each subject
AvearagesTidyTable<-rbind.data.frame(apply(TidyTable_MeansandSD,2,mean))
Averages<- (setNames(AvearagesTidyTable,colnames(TidyTable_MeansandSD)))[1:86] #remove last two columns(activity ID and Participant ID)

####################
#notes - personal ideas:
#Calculate the mean for each column. 
apply(TrainandTest_ExperimentData,2,mean)
table<- rbind.data.frame(apply(TrainandTest_ExperimentData,2,mean))

#selects all columns except ID and ActivityID
head(TrainDFFinal%>% select(!(`tBodyAcc-mean()-X`:`angle(Z,gravityMean)`)))
write.table(data.frame())
