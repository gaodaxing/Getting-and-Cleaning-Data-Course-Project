library(qdap)
library(dplyr)

X_train<-read.table("UCI HAR Dataset/train/X_train.txt") #read X_train data
y_train<-read.table("UCI HAR Dataset/train/y_train.txt") #read y_train data
sub_train<-read.table("UCI HAR Dataset/train/subject_train.txt") #read subject_train data
X_test<-read.table("UCI HAR Dataset/test/X_test.txt") #read X_test data
y_test<-read.table("UCI HAR Dataset/test/y_test.txt") #read y_test data
sub_test<-read.table("UCI HAR Dataset/test/subject_test.txt") #read subject_test data

activity_label<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

Train<-cbind(sub_train,y_train,X_train) #put training set subject,activity,and data together
Test<-cbind(sub_test,y_test,X_test) #put test set subject,activity,and data together
total<-rbind(Train,Test) #Merges the training and the test sets to create one data set

colname<-as.character(features[[2]]) 
colnames(total)<-c("Subject","Activity",colname) #label the data set with descriptive variable names.
total$Activity<-mgsub(activity_label[[1]],activity_label[[2]],total$Activity) #Use descriptive activity names to name the activities in the data set

total_data<-total[,c("Subject","Activity",grep("mean\\(\\)|std\\(\\)",colnames(total),value=TRUE))] #Extracts only the measurements on the mean and standard deviation for each measurement.
colnames(total_data)<-mgsub(c("Acc","Gyro","Mag","BodyBody"),c("Accelerometer","Gyroscope","Magnitude","Body"),colnames(total_data)) #make the descriptive variable names easier to read
colnames(total_data)<-gsub("\\(|\\)","",colnames(total_data))

alldata<-group_by(total_data,Subject,Activity)
tidy_data<-summarize_each(alldata,funs(mean)) #creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(tidy_data,"tidydata.txt",row.name = FALSE)


