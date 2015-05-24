## You should create one R script called run_analysis.R that does the following
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## 1. Merges the training and the test sets to create one data set.
	setwd("C:/Users/Pedro/Downloads/UCI HAR Dataset")
	trainData <- read.table("./train/X_train.txt")
	trainLabel <- read.table("./train/y_train.txt")
	trainSubject <- read.table("./train/subject_train.txt")
	testData <- read.table("./test/X_test.txt")
	testLabel <- read.table("./test/y_test.txt")
	testSubject <- read.table("./test/subject_test.txt")
	combinedData <- rbind(trainData, testData)
	combinedLabel <- rbind(trainLabel, testLabel)
	combinedSubject <- rbind(trainSubject, testSubject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
	features <- read.table('./features.txt')
	mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
	x.mean.sd <- combinedData[, mean.sd]

## 3. Uses descriptive activity names to name the activities in the data set
	names(x.mean.sd) <- features[mean.sd, 2]
	names(x.mean.sd) <- tolower(names(x.mean.sd)) 
	names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))
	activities <- read.table('./activity_labels.txt')
	activities[, 2] <- tolower(as.character(activities[, 2]))
	activities[, 2] <- gsub("_", "", activities[, 2])
	combinedLabel[, 1] = activities[combinedLabel[, 1], 2]
	colnames(combinedLabel) <- 'activity'
	colnames(combinedSubject) <- 'subject'

## 4. Appropriately labels the data set with descriptive variable names.
	combData <- cbind(combinedSubject, x.mean.sd, combinedLabel)
	write.table(combData, './combined.txt')

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	average <- aggregate(x=combData, by=list(activities=combData$activity, subj=combData$subject), FUN=mean)
	write.table(average, './average.txt',  row.name=FALSE)
