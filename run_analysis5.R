library(reshape2)

getwd()
if (!file.exists("/Users/Monroe1/Documents/R/DataCleaning")){
  dir.create("/Users/Monroe1/Documents/R/DataCleaning")
  setwd("/Users/Monroe1/Documents/R/DataCleaning")
}

##Download Data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "./GetData", method = "curl")
dateDownloaded <-date()
dateDownloaded

if (!file.exists("UCI HAR Dataset")) {unzip("GetData")}

#Activity Lables
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

#Lables to Tables
activityLabels[,2] <- as.character(activityLabels[,2])
features[,2] <- as.character(features[,2])

#Exract mean & standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#Merge Testing, Activities, & Subjects
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
tActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
tSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")


train <- cbind(tSubjects, tActivities, train)
test <- cbind(testSubjects, testActivities, test)
CombinedData <- rbind(train, test)

#Names
colnames(CombinedData) <- c("subject", "activity", featuresWanted.names)

CombinedData$activity <- factor(CombinedData$activity, 
                                levels = activityLabels[,1], 
                                labels = activityLabels[,2])

CombinedData$subject <- as.factor(CombinedData$subject)
CombinedData.melted <- melt(CombinedData, id = c("subject", "activity"))
CombinedData.mean <- dcast(CombinedData.melted, 
                           subject + activity ~ variable, mean)

write.table(CombinedData.mean, file = "tidydata.txt", 
            row.names = FALSE, quote = FALSE)




#Merge Data Attempt 1
# Activity_X <- rbind(X_test, X_train)
# Activity_Y <- rbind(y_test, y_train)
# Subject <- rbind(subject_test, subject_train)
# 
# names(Activity_X) <- c("subject")
# names(Activity_Y) <- c("activity")
# names(Subject) <- c("activity")
# names(features) <- c("features")
# names(activity_lables) <- ("activity")
# 
# dataCombine <- cbind(Activity_Y, Activity_X)
# 
# data <- cbind(features, dataCombine)
