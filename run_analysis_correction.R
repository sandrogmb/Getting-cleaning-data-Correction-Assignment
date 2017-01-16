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
    
   # al controllo il file merged è corretto perché:
#   > tally(group_by(merged, subjectId, activityName))
#Source: local data frame [180 x 3]
#Groups: subjectId [?]

#   subjectId       activityName     n
#       <int>             <fctr> <int>
#1          1             LAYING    50
#2          1            SITTING    47
#3          1           STANDING    53
#4          1            WALKING    95
#5          1 WALKING_DOWNSTAIRS    49
#6          1   WALKING_UPSTAIRS    53
#7          2             LAYING    48
#8          2            SITTING    46
#9          2           STANDING    54
#10         2            WALKING    59
# ... with 170 more rows
#> controllo<-tally(group_by(merged, subjectId, activityName))
#Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	180 obs. of  3 variables:
    

# Replace activityId with activityName
    #fondo insieme i due dataframe merged e activities in base ai valori di activityId: cioè ogni volta che trovo 
    #un determinato indice di una certa attività, aggiungo a merged il nome dell'attività che corrisponde a quell'indice
merged <- merge(merged,activities,"activityId")
    
    #con la riga seguente mantengo in merged solo quelle colonne che hanno un nome diverso da quello contenuto nel vettore c
    #cioè elimino la colonna con il nome activityId
merged <- merged[,!names(merged) %in% c("activityId")]

# Melt the dataset using subjectId and activityName as id.vars
    #in questo esempio si vede quale sia la potenza della funzione melt() 
    #se ho un dataframe, posso decidere quale colonna del df utilizzare come variabile
    #una volta fatta la scelta della variabile o delle variabili, r mi rilegge il DF in base al valore di quelle variabili
    #il df merged di 10299 obs di 88 variabili, diventa il df molten di 885714 obs (questo è il numero delle 
    #diverse combinazioni presenti nel DF merged delle variabili del vettore c("subjectId","activityName")x le osservazioni:
    # cioé 86x10299=885714) di 4 variabili
molten <- melt(merged,id.vars = c("subjectId","activityName"))

# Cast the molten dataset using "mean" to aggregate: our output dataframe
out_df <- dcast(molten,subjectId + activityName ~ ...,mean)
    
#NOTA BENE: recast: melt and cast in a single step

# Write the output to a file
cat("\nWriting output data.frame...")
if (!dir.exists("./output")) dir.create("./output")
write.table(out_df,"./output/summary_df.txt",row.names = F)
if (file.exists("./output/summary_df.txt")) cat("\nOutput written to:\n  ./output/summary_df.txt")
