# Load needed libraries
library(reshape2)

# Check if dataset is ready. If not download and unzip
if (!dir.exists("./data/UCI HAR Dataset/")){
    if (!dir.exists("./data")) dir.create("./data")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    if (!dir.exists("./data/dataset.zip")) {
        cat("Downloading dataset...")
        download.file(fileUrl,destfile = "./data/dataset.zip",method = "curl",quiet = T)
    }
    cat("\nUnzipping dataset...")
    unzip(zipfile = "./data/dataset.zip",exdir = "./data")
}

cat("\nDataset is ready.")

# Fetch features
cat("\nFetching features...")
features <- read.table(file = "./data/UCI HAR Dataset/features.txt",col.names = c("featureId","featureName"),check.names = F)

# Select only features related to mean and std
featuresSel <- grep("[Mm]ean|[Ss]td",features$featureName)

# Fetch activities
cat("\nFetching activities...")
activities <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt",col.names = c("activityId","activityName"))

# Fetch train set
cat("\nFetching train set...")
X_train <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt",col.names = features$featureName)[,featuresSel]
names(X_train) <- features$featureName[featuresSel]
y_train <- read.table(file = "./data/UCI HAR Dataset/train/y_train.txt",col.names = c("activityId"))
subject_train <- read.table(file = "./data/UCI HAR Dataset/train/subject_train.txt",col.names = c("subjectId"))
train <- cbind(subject_train,y_train,X_train)

# Fetch test set
cat("\nFetching test set...")
X_test <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt",col.names = features$featureName)[,featuresSel]
names(X_test) <- features$featureName[featuresSel]
y_test <- read.table(file = "./data/UCI HAR Dataset/test/y_test.txt",col.names = c("activityId"))
subject_test <- read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt",col.names = c("subjectId"))
test <- cbind(subject_test,y_test,X_test)

# Merge the train and the test set
cat("\nMerging test and train sets...")
merged <- rbind(test,train)

# Replace activityId with activityName
merged <- merge(merged,activities,"activityId")
merged <- merged[,!names(merged) %in% c("activityId")]

# Melt the dataset using subjectId and activityName as id.vars
molten <- melt(merged,id.vars = c("subjectId","activityName"))

# Cast the molten dataset using "mean" to aggregate: our output dataframe
out_df <- dcast(molten,subjectId + activityName ~ ...,mean)

# Write the output to a file
cat("\nWriting output data.frame...")
if (!dir.exists("./output")) dir.create("./output")
write.table(out_df,"./output/summary_df.txt",row.names = F)
if (file.exists("./output/summary_df.txt")) cat("\nOutput written to:\n  ./output/summary_df.txt")
