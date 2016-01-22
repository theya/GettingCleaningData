## 1. Getting ready
## Loading needed packages
packages <- c("data.table", "utils", "reshape2")
sapply(packages, require, character.only = TRUE, quietly = TRUE)

## Setting path
path <- getwd()
path


## 2. Downloading data
## Getting dataset in a temporary file and recording downloading date
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
tempFile <- "Dataset.zip"
download.file(fileUrl, file.path(path, tempFile))

## Unzipping and deleting temporary file
unzip(file.path(path, tempFile))
unlink(tempFile)
file.exists("Dataset.zip")

## Setting path with unzipped directory and listing files in it
extandedPath <- file.path(path, "UCI HAR Dataset")
list.files(extandedPath, recursive = TRUE)


## 3. Reading files
## See 'README' for more information about sets
## Writing a lisible function to read the files in a data table
readIntoDT <- function (x) {
    setFile <- file.path(extandedPath, x)
    intoDT <- data.table(read.table(setFile))
}

## Reading three 'test' datasets : the set (X), the labels (Y) and the performers (subjects)
testSet <- readIntoDT("test/X_test.txt")
testLabel <- readIntoDT("test/y_test.txt")
testSubject <- readIntoDT("test/subject_test.txt")

## Reproducing for 'train' datasets : the set (X), the labels (Y) and the performers (subjects)
trainSet <- readIntoDT("train/X_train.txt")
trainLabel <- readIntoDT("train/y_train.txt")
trainSubject <- readIntoDT("train/subject_train.txt")


## 4. Merging to create one data set
## Merging 'test' and 'train' sets into a single 'test'/'train' data set
testDT <- cbind(activityNo = testLabel, subjectNo = testSubject, testSet)
trainDT <- cbind(activityNo = trainLabel, subjectNo = trainSubject, trainSet)

## Creating a whole full single data set
fullDT <- rbind(testDT, trainDT)

## Cleaning names
names(fullDT) <- sapply(strsplit(names(fullDT), "\\."), function(x) {x[1]})


## 5. Extracting 'mean' and 'standard deviation' measurements
## Reading 'features' to get the 'mean' and 'standard deviation' locations
featureDT<- readIntoDT("features.txt")
names(featureDT) <- c("featureNo", "featureSignals")

## Adding a column to the table that fits column names in 'fullDT'
featureDT$featureId <- sub("^", "V", featureDT$featureNo)

## Subsetting needed feature measurements containing 'mean' or 'standard deviation'
featureSubDT <- featureDT[grepl("mean\\(\\)|std\\(\\)", featureSignals)]

## Replacing initial columns by the needed subset of columns
namesFullDT <- c("activityNo", "subjectNo", featureSubDT$featureId)
fullDT <- fullDT[, namesFullDT, with = FALSE]


## 6. Naming activities
## Reading 'activity labels' to clarify dataset with activity names
activityDT<- readIntoDT("activity_labels.txt")
names(activityDT) <- c("activityNo", "activityName")

## Merging 'activity' and main data tables to read activiy names
fullDT <- merge(activityDT, fullDT, by = "activityNo", all.x = TRUE)
fullDT <- fullDT[, 2:69, with = FALSE]


## 7. Labelling data with right variable names
## Renaming feature IDs to feature signals'names
names(fullDT)[3:68] <- as.character(featureSubDT$featureSignals)

## Writing a function to replace multiple characters
replaceChar <- function(x, y) {
    if (length(x)!=length(y)) {
        stop("x an y do not have the same length.")
    } else { 
    for (i in 1:length(x)) {
    names(fullDT) <- gsub(x[i], y[i], names(fullDT))
        }
    }
}

## There is a mistake in the original feature labels as the names does not match the information
## Body is repeated twice in some fBody labels from columns 64 to 69
replaceChar(c("^t", "^f", "-", "mean", "std", "\\(\\)", "BodyBody"), 
            c("Time", "Freq", "", "Mean", "Std", "", "Body"))


## 8. Creating an independent tidy data set
## Creating a clean tiny data set first
setkey(fullDT, subjectNo, activityName)
tinyDT <- data.table(melt(fullDT, key(fullDT), variable.name = "featureLabel"))

## And creating the final tidy data set
tidyDT <- tinyDT[, list(count = .N, average = mean(value)), by=key(fullDT)]


## 9. Saving the final data set in a .csv format
newPath <- file.path(path, "HumanActivityRecognition.csv")
write.table(tidyDT, newPath, quote = FALSE, sep = ",", row.names = FALSE)


## 10. Creating related Codebook and README documents
## Please read CodBook.md for more details about this analysis
