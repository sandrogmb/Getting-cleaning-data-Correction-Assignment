#Getting and Cleaning Data Course Project

Please read README.md for project descripion

#Input Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

#For each record it is provided

Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
Triaxial Angular velocity from the gyroscope.
A 561-feature vector with time and frequency domain variables.
Its activity label.
An identifier of the subject who carried out the experiment.

#The dataset includes the following files

'README.txt'
'features_info.txt': Shows information about the variables used on the feature vector.
'features.txt': List of all features.
'activity_labels.txt': Links the class labels with their activity name.
'train/X_train.txt': Training set.
'train/y_train.txt': Training labels.
'test/X_test.txt': Test set.
'test/y_test.txt': Test labels.
The following files are available for the train and test data. Their descriptions are equivalent.

'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 1. 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

#Notes

Features are normalized and bounded within [-1,1].
Each feature vector is a row on the text file.
Script

#The run_analysis.R script includes the following functions

##log

Is a helper logging function that outputs console logs in the form

[15-01-2017 17:44:31] log output
Usage

log(...)

##Arguments

Argument	Default value	Description
...		string arguments to concatanate in log output
Examples

log("log ", "output")



##downloadData

Cleans and creates temp data directory and downloads data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Usage

downloadData(destDir)
Arguments

Argument	Default value	Description
destDir	"./data"	the temporary data directory
Examples

downloadData("./temp")



##getActivities

Gets and prettifies activities labels from "[baseDir]/activity_labels.txt" data file. Underscores removed and labels are converted to lower case.

Usage

getActivities(dir)
Arguments

Argument	Default value	Description
dir	"./"	the directory where "activity_labels.txt" exists
Examples

getActivities("./temp")



##getFeatures

Gets, filters and prettifies features labels from "[baseDir]/features.txt" data file. Labels which include mean and std. are filtered. Lables are then prettified removing all non alphabetic characters.

Usage

getFeatures(dir)
Arguments

Argument	Default value	Description
dir	"./"	the directory where "features.txt" exists
Examples

getFeatures("./temp")


##getData

Reads data files.

Usage

getData(baseDir, dataDir , features)
Arguments

Argument	Default value	Description
baseDir	"."	the base directory where data exists.
dataDir	""	the base directory where data exists.
features		the feature label filters
Examples

getData(dataDir, "test", features)


##writeData

Writes data to output file "output.csv" under given directory.

Usage

writeData(dir, data)
Arguments

Argument	Default value	Description
dir	"."	the data output directory
data		the data frame to output
Examples

writeData("./temp")


##runAnalysis

Main function that gets, merges and cleans data

Usage

runAnalysis(destDir)
Arguments

Argument	Default value	Description
destDir	"./data"	the temporary data directory where input data is downloaded and output data extracted
Examples

runAnalysis("./temp")

##Output Data

The output data is a three dimentional table for measurements against subjects and activities.

Example

subject	activity	tBodyAccMeanX	tBodyAccMeanY	tBodyAccMeanZ	tBodyAccStdX	tBodyAccStdY	tBodyAccStdZ
1	walking	0.277330758736842	-0.0173838185273684	-0.111148103547368	-0.283740258842105	0.114461336747368	-0.260027902210526
1	walkingupstairs	0.255461689622641	-0.0239531492643396	-0.0973020020943396	-0.35470802509434	-0.00232026501698113	-0.0194792388471698
2	walking	0.276426586440678	-0.0185949199145763	-0.105500357966102	-0.423642838474576	-0.0780912533118644	-0.425257524915254
2	walkingupstairs	0.247164790395833	-0.0214121132045833	-0.152513899520833	-0.304376406458333	
