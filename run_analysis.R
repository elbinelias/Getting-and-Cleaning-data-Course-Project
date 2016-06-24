##Download file
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="runanalysis.zip")

##unzip the files 
unzip("runanalysis.zip")

##read the data files
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")

xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")


##Read features and activities list
features <- read.table("UCI HAR Dataset/features.txt")
featureslist <- features[,2]
##4. Appropriately labels the data set with descriptive variable names. The tidy dataset is created below
featureslist <- gsub("[()]","",featureslist)
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

##Add column names
colnames(xtest) <- featureslist
colnames(xtrain) <- featureslist
colnames(subjecttest) <- "subjectid"
colnames(subjecttrain) <- "subjectid"
colnames(activitiestest) <- "activityID"
colnames(activitiestrain) <- "activityID"
colnames(activities) <- c("activityID","ActivityName")

##Combine data
test <- cbind(subjecttest,activitiestest,xtest)
train <- cbind(subjecttrain,activitiestrain,xtrain)

#1. Merges the training and the test sets to create one data set.
combineddata <- rbind(test,train)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.
selectiondata <- combineddata[,grep ("*.mean*.|*.std*.",colnames(combineddata))]

#3. Uses descriptive activity names to name the activities in the data set
newdata <- merge(combineddata,activities,by="activityID",all=TRUE)
#optional - newdata <- newdata[,c(1:2,ncol(newdata),3:ncol(newdata)-1)] ##move last column to 3rd
#optional - newdata <- newdata[,c(2,1,3:ncol(newdata))] ##move second column to first

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
newmeltdata <- melt(newdata,id=c("activityID","subjectid","ActivityName"))
meandata <- dcast(newmeltdata,activityID + subjectid + ActivityName ~ variable, mean)
