library(plyr);

path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

dataYTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataYTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dataXTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataXTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataY<- rbind(dataYTrain, dataYTest)
dataX<- rbind(dataXTrain, dataXTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)

names(dataSubject)<-c("subject")
names(dataY)<- c("activity")
dataFtNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataX)<- dataFtNames$V2

dataCombine <- cbind(dataSubject, dataY)
finalData <- cbind(dataX, dataCombine)

stdDataFtNames<-dataFtNames$V2[grep("mean\\(\\)|std\\(\\)", dataFtNames$V2)]
selectedNames<-c(as.character(stdDataFtNames), "subject", "activity" )
finalData<-subset(finalData,select=selectedNames)

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

names(finalData)<-gsub("^t", "Time", names(finalData))
names(finalData)<-gsub("^f", "Frequency", names(finalData))
names(finalData)<-gsub("Acc", "Accelerometer", names(finalData))
names(finalData)<-gsub("Gyro", "Gyroscope", names(finalData))
names(finalData)<-gsub("Mag", "Magnitude", names(finalData))
names(finalData)<-gsub("BodyBody", "Body", names(finalData))


Data2<-aggregate(. ~subject + activity, finalData, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "data/secondTidydata.txt",row.name=FALSE)
