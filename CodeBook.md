# Run analysis: CodeBook

This document describes the variables, the data, and any transformations or work that has been performed to clean up the data.

## Variables

### 
Here is an overvieww of the variables in the final data set.

Column       | Variable       | Description                                                |
:----------- |:-------------- | :--------------------------------------------------------- |
1            | subjectNo      | Number associated to the performer from 1 to 30            |
2            | activityName   | Name of the activity performed:  Laying, Sitting, Standing, Walking, Walking downstairs or Walking upstairs                                            |
3            | Count          | Total measurements obtained for each subject and activity  |
4            | Average        | Average of values obtained for each subject and activity   |

Here below is a detailed table of how features are built. The features can be found in the intermediary data set used in the analysis.   
Features' names contains between five and six parts respecting a precise order.  
  
Position     | Variable            | Values                                      |
:----------- |:------------------- | :------------------------------------------ |
1            | Domain              | Time or Freq for frequency                  |
2            | Acceleration signal | Boy or Gravity                              |
3            | Instrument          | Acc for Accelerometer or Gyro for gyroscope |
4            | First derivative    | Jerk (optional)                             |
5            | Second derivative   | Mag for magnitude (optional)                |
6            | Measure             | Mean or Std for standard deviation          |


## Data

The data source is indicated in the ReadMe markdown file.
The list of the needed data sets to perform the analysis is the following:

* "test/X_test.txt"
* "test/y_test.txt"  
* "test/subject_test.txt"
* "train/X_train.txt"  
* "train/y_train.txt" 
* "train/subject_train.txt"

They are located in the main directory "UCI HAR Dataset".
The information were collected in the following:

* "README.txt"
* "features_info.txt" 
* "activity_labels.txt" 
* "features.txt"

The Inertial signals directories are not necessary for this analysis.

The outputs of this analysis are:

* HARUS-tidy-dataset.csv
* run_analysis.R


## How Run analysis works

The following part describes what the script `run_analysis.R` does step by step.

### 1. Getting ready
   
Load needed packages to run this analysis.

	packages <- c("data.table", "utils", "reshape2")
	sapply(packages, require, character.only = TRUE, quietly = TRUE)

	## data.table      utils   reshape2 
    ## 		 TRUE       TRUE       TRUE 
    
Install packages with `install.packages()` if one or more of the results equals to `FALSE`.
And set path.

	path <- getwd()
	path

	## [1] "/Users/theyanike/Documents/DataScience/GettingAndCleaningData/CourseProject"

### 2. Downloading data

Get dataset in a temporary file. This prevents from taking space uselessly. 

	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	tempFile <- "Dataset.zip"
	download.file(fileUrl, file.path(path, tempFile))

Unzip and delete the temporary file in the working directory.

	unzip(file.path(path, tempFile))
	unlink(tempFile)
	
	## > file.exists("Dataset.zip")
	## [1] FALSE

Set an extanded path due to the creation of the new directory contained in the .zip file.  
Then list files in it.

	extandedPath <- file.path(path, "UCI HAR Dataset")
	list.files(extandedPath, recursive = TRUE)
	
	 ## [1] "activity_labels.txt"                         
	 ## [2] "features_info.txt"                           
	 ## [3] "features.txt"                                
	 ## [4] "README.txt"                                  
	 ## [5] "test/Inertial Signals/body_acc_x_test.txt"  
	 ## [6] "test/Inertial Signals/body_acc_y_test.txt"   
	 ## [7] "test/Inertial Signals/body_acc_z_test.txt"   
	 ## [8] "test/Inertial Signals/body_gyro_x_test.txt"  
	 ## [9] "test/Inertial Signals/body_gyro_y_test.txt"  
	 ## [10] "test/Inertial Signals/body_gyro_z_test.txt"  
	 ## [11] "test/Inertial Signals/total_acc_x_test.txt"  
	 ## [12] "test/Inertial Signals/total_acc_y_test.txt"  
	 ## [13] "test/Inertial Signals/total_acc_z_test.txt"  
	 ## [14] "test/subject_test.txt"                       
	 ## [15] "test/X_test.txt"                             
	 ## [16] "test/y_test.txt"                             
	 ## [17] "train/Inertial Signals/body_acc_x_train.txt" 
	 ## [18] "train/Inertial Signals/body_acc_y_train.txt" 
	 ## [19] "train/Inertial Signals/body_acc_z_train.txt" 
	 ## [20] "train/Inertial Signals/body_gyro_x_train.txt"
	 ## [21] "train/Inertial Signals/body_gyro_y_train.txt"
	 ## [22] "train/Inertial Signals/body_gyro_z_train.txt"
	 ## [23] "train/Inertial Signals/total_acc_x_train.txt"
	 ## [24] "train/Inertial Signals/total_acc_y_train.txt"
	 ## [25] "train/Inertial Signals/total_acc_z_train.txt"
	 ## [26] "train/subject_train.txt"                     
	 ## [27] "train/X_train.txt"                           
	 ## [28] "train/y_train.txt"  
	 
The analysis does not need the sub-directories of test and train called Inertial Signals.  
To know more about the data sets, refer to README.txt.

### 3. Reading files
 
Write a lisible and simple function to read the files in a data table. This will allow to read files with a single short line of code. 

	readIntoDT <- function (x) {
    	setFile <- file.path(extandedPath, x)
    	intoDT <- data.table(read.table(setFile))
	}

Read three 'test' datasets : the set (X), the labels (Y) and the performers (subjects)

	testSet <- readIntoDT("test/X_test.txt")
	testLabel <- readIntoDT("test/y_test.txt")
	testSubject <- readIntoDT("test/subject_test.txt")

Again for 'train' datasets : the set (X), the labels (Y) and the performers (subjects)

	trainSet <- readIntoDT("train/X_train.txt")
	trainLabel <- readIntoDT("train/y_train.txt")
	trainSubject <- readIntoDT("train/subject_train.txt")

### 4. Merging to create one data set
  
Merge three 'test' sets and thress 'train' sets into a single 'test' and 'train' data set.

	testDT <- cbind(activityNo = testLabel, subjectNo = testSubject, testSet)
	trainDT <- cbind(activityNo = trainLabel, subjectNo = trainSubject, trainSet)

**Create a whole full single merged data set.**

	fullDT <- rbind(testDT, trainDT)
	
	## > str(fullDT)
	## Classes ‘data.table’ and 'data.frame':	10299 obs. of  563 variables:
	## $ activityNo.V1: int  5 5 5 5 5 5 5 5 5 5 ...
	## $ subjectNo.V1 : int  2 2 2 2 2 2 2 2 2 2 ...
	## $ V1           : num  0.257 0.286 0.275 0.27 0.275 ...
	## $ V2           : num  -0.0233 -0.0132 -0.0261 -0.0326 -0.0278 ...
	## $ V3           : num  -0.0147 -0.1191 -0.1182 -0.1175 -0.1295 ...
	## $ V4           : num  -0.938 -0.975 -0.994 -0.995 -0.994 ...
	## $ V5           : num  -0.92 -0.967 -0.97 -0.973 -0.967 ...
	## $ V6           : num  -0.668 -0.945 -0.963 -0.967 -0.978 ...
	
	## > head(names(fullDT))
	## [1] "activityNo.V1" "subjectNo.V1"  "V1"            "V2"            "V3"            "V4"

Clean names containing dot.

	names(fullDT) <- sapply(strsplit(names(fullDT), "\\."), function(x) {x[1]})

	## > head(names(fullDT))
	## [1] "activityNo" "subjectNo"  "V1"         "V2"         "V3"         "V4"


### 5. Extracting 'mean' and 'standard deviation' measurements

Read 'features' to get the 'mean' and 'standard deviation' locations.

	featureDT<- readIntoDT("features.txt")
	names(featureDT) <- c("featureNo", "featureSignals")
	
	## > dim(featureDT)
	## [1] 561   3

Add a column to the table to get a common column between both sets.

	featureDT$featureId <- sub("^", "V", featureDT$featureNo)
	
	## > head(featureDT, 10)
	##    featureNo    featureSignals featureId
	## 1:         1 tBodyAcc-mean()-X        V1
	## 2:         2 tBodyAcc-mean()-Y        V2
	## 3:         3 tBodyAcc-mean()-Z        V3
	## 4:         4  tBodyAcc-std()-X        V4
	## 5:         5  tBodyAcc-std()-Y        V5
	## 6:         6  tBodyAcc-std()-Z        V6
	## 7:         7  tBodyAcc-mad()-X        V7
	## 8:         8  tBodyAcc-mad()-Y        V8
	## 9:         9  tBodyAcc-mad()-Z        V9
	## 10:        10  tBodyAcc-max()-X       V10

**Extract needed feature measurements containing 'mean' or 'standard deviation'.**

	featureSubDT <- featureDT[grepl("mean\\(\\)|std\\(\\)", featureSignals)]
	
	## > featureSubDT[7]
    ##		featureNo       featureSignals featureId
	## 	 1:        41 tGravityAcc-mean()-X       V41

Replace initial columns by the subset of extracted columns.

	namesFullDT <- c("activityNo", "subjectNo", featureSubDT$featureId)
	fullDT <- fullDT[, namesFullDT, with = FALSE]

	## > length(names(fullDT))
	## [1] 68

### 6. Naming activities

Read 'activity labels' file.

	activityDT<- readIntoDT("activity_labels.txt")
	names(activityDT) <- c("activityNo", "activityName")

**Merge 'activity' and main data tables to read activiy names.**
Keep only the activity name and remove the activity number column.

	fullDT <- merge(activityDT, fullDT, by = "activityNo", all.x = TRUE)
	fullDT <- fullDT[, 2:69, with = FALSE]


### 7. Labelling data with right variable names

Rename feature IDs to feature signals'names.

	names(fullDT)[3:68] <- as.character(featureSubDT$featureSignals)
	
	## > head(names(fullDT))
	## [1] "activityName"      "subjectNo"         "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y"
	## [5] "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" 

Write a function to replace multiple characters in one line.

	replaceChar <- function(x, y) {
    	if (length(x) != length(y)) {
        	stop("x an y do not have the same length.")
    	} else { 
    		for (i in 1:length(x)) {
    		names(fullDT) <- gsub(x[i], y[i], names(fullDT))
        	}
    	}
	}

*There is a mistake in the original feature labels as the names does not match the information.*
*'Body' is repeated twice in some fBody labels from columns 64 to 69, which should not be according to the features information.*

Identify patterns to replace and their respective replacements.
**This makes the name of the variables "human-readable" and easy to use for any further analysis.**

	replaceChar(c("^t", "^f", "-", "mean", "std", "\\(\\)", "BodyBody"), 
            	c("Time", "Freq", "", "Mean", "Std", "", "Body"))

	## > head(names(fullDT))
	## [1] "activityName"     "subjectNo"        "TimeBodyAccMeanX" "TimeBodyAccMeanY" "TimeBodyAccMeanZ"
	## [6] "TimeBodyAccStdX"

### 8. Creating an independent tidy data set

Create a clean tiny data set first.

	setkey(fullDT, subjectNo, activityName)
	tinyDT <- data.table(melt(fullDT, key(fullDT), variable.name = "featureLabel"))

	## > head(tinyDT)
	##    subjectNo activityName     featureLabel     value
	## 1:         1       LAYING TimeBodyAccMeanX 0.4034743
	## 2:         1       LAYING TimeBodyAccMeanX 0.2783732
	## 3:         1       LAYING TimeBodyAccMeanX 0.2765553
	## 4:         1       LAYING TimeBodyAccMeanX 0.2795748
	## 5:         1       LAYING TimeBodyAccMeanX 0.2765270
	## 6:         1       LAYING TimeBodyAccMeanX 0.2781233

**And create the final tidy data set with the average for each subject and activity.**

	tidyDT <- tinyDT[, list(count = .N, average = mean(value)), by=key(fullDT)]
	
	## > head(tidyDT)
	##    subjectNo       activityName count    average
	## 1:         1             LAYING  3300 -0.6815820
	## 2:         1            SITTING  3102 -0.7250103
	## 3:         1           STANDING  3498 -0.7518869
	## 4:         1            WALKING  6270 -0.1932046
	## 5:         1 WALKING_DOWNSTAIRS  3234 -0.1493580
	## 6:         1   WALKING_UPSTAIRS  3498 -0.3153368


### 9. Saving final data set

Save the tidy data set in a .csv format to be able to read it easily in the future.

	newPath <- file.path(path, "HARUS-tidy-dataset.csv")
	write.table(tidyDT, newPath, quote = FALSE, sep = ",", row.names = FALSE)
	
	## > file.exists("HARUS-tidy-dataset.csv")
	## [1] TRUE


### 10. Creating run_analysis, CodeBook and README

Create and save run_analysis, CodeBook and README as markdown files.      
  
Codebook.md: "describes the variables, the data, and any transformations or work that you performed to clean up the data". It identifies what the R file does step by step.   
  
README.md: "explains how all of the scripts work and how they are connected".
