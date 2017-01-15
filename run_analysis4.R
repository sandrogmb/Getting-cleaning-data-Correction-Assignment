library(reshape2)

# logging function
log <- function(...) {
    cat("[", format(Sys.time(), "%d-%m-%Y %H:%M:%S") , "] ", ..., "\n", sep = "")
}

# cleans and creates temp data folder and downloads data
downloadData <- function(destDir="./data"){
    # setwd("coursera-data-science/Getting_and_Cleaning_Data/gettingCleaningDataAssignment/")
    dataDir <- destDir
    zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    
    log("cleaning and creating data directory ", dataDir)
    if (file.exists(dataDir)){
        unlink(dataDir, recursive=TRUE)
    }
    dir.create(dataDir, showWarnings = TRUE)
    
    log("downloading data from ", zipURL)
    zipData <- paste(dataDir, "/dataset.zip", sep = "")
    download.file(zipURL, zipData , method="curl")
    
    log("unzipping data from ", zipData)
    unzip(zipData, exdir = dataDir) 
    
    dataDir <- paste(dataDir, "/", list.files(dataDir, pattern = ".*[^zip]$" ), sep = "")
    log("unziped data to ", dataDir)
    
    return(dataDir)
}


# gets and prettifies activities labels
getActivities <- function(dir = "./"){
    activitiesFile <- paste(dir, "/activity_labels.txt", sep = "")
    log("getting activitiy labels from ", activitiesFile)
    
    activities <- read.table(activitiesFile, col.names=c("id", "label"))
    activities$label <- gsub("_", "", tolower(as.character(activities$label)))
    
    return(activities)
}


# gets, filters and prettifies features labels
getFeatures<- function(dir = "./"){
    featuresFile <- paste(dir, "/features.txt", sep = "")
    log("getting filtering and prettifying features labels from ", featuresFile)
    
    features <- read.table(featuresFile, col.names=c("id", "label"))
    # filter features
    featuresSub <- features[grepl(".*mean.*|.*std.*", features$label),]
    
    # prettify features labels
    featuresSub$label = gsub('(-?)mean\\(\\)(-?)', 'Mean', featuresSub$label)
    featuresSub$label = gsub('(-?)meanFreq\\(\\)(-?)', 'MeanFreq', featuresSub$label)
    featuresSub$label = gsub('(-?)std\\(\\)(-?)', 'Std', featuresSub$label)
    
    return(featuresSub)
}

# reads data files
getData <- function(baseDir = ".", dataDir = "", features = data.frame()){
    featuresFile <- paste(baseDir, "/", dataDir, "/X_" , dataDir, ".txt", sep = "")
    log("reading " , featuresFile)
    data <- read.table(featuresFile)[features$id]
    
    activitiesFile <- paste(baseDir, "/", dataDir, "/y_" , dataDir, ".txt", sep = "")
    log("reading " , activitiesFile)
    activities <- read.table(activitiesFile)
    
    subjectFile <- paste(baseDir, "/", dataDir, "/subject_" , dataDir, ".txt", sep = "")
    log("reading " , subjectFile)
    subjects <- read.table(subjectFile)
    
    data <- cbind(subjects, activities, data)
}


# writes data to output file
writeData <- function(dir = ".", data = data.frame()){
    outputFile <- paste(dir, "/output.csv", sep = "")
    log("writing output to ", outputFile)
    write.table(data, outputFile, row.names = FALSE, quote = FALSE)
}


# main function that gets, merges and cleans data
runAnalysis <- function(destDir="./data") {
    
    dataDir <- downloadData(destDir)
    # dataDir <- "./data/UCI HAR Dataset"

    features <- getFeatures(dataDir)

    testData <- getData(dataDir, "test", features)
    trainData <- getData(dataDir, "train", features)

    log("merging data")
    mergedData <- rbind(trainData, testData)
    colnames(mergedData) <- c("subject", "activity", features$label)
    
    activities <- getActivities(dataDir)
    
    log("cleaning data")
    mergedData$activity <- factor(mergedData$activity, levels = activities$id, labels = activities$label)
    mergedData$subject <- as.factor(mergedData$subject)
    
    meltedData <- melt(mergedData, id = c("subject", "activity"))
    castData <- dcast(meltedData, subject + activity ~ variable, mean)

    writeData(destDir, castData)
    
}

# runs main function
runAnalysis()
