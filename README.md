# Run analysis: ReadMe

This document explains how all of the scripts work and how they are connected.

## Synopsis

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
  
> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:  

> [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

> Here are the data for the project:  

> [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  

> You should create one R script called run_analysis.R that does the following.  

> Merges the training and the test sets to create one data set.  
Extracts only the measurements on the mean and standard deviation for each measurement.  
Uses descriptive activity names to name the activities in the data set.  
Appropriately labels the data set with descriptive variable names.  
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  


## Code example and documentation

Please read CodeBook.md for more details about the analysis.

The outputs at this analysis are:

* HARUS-tidy-dataset.csv
* run_analysis.R
* CodeBook.md


## Installation

To reproduce the analysis, run the R script `run_analysis.R` in R or RStudio.  
Make sure to set the right working directory with the `setwd()` function.  
  
The CodeBook can help following the analysis step by step.

The analysis was made on RStudio Version 0.99.489 on Mac OS X Version 10.9.5.

The project could have been run using the `knitr` package. But for the purpose of the assignment, the R script have been separated from the codebook.
The necessary packages are specified in the R script.


## Contributors

This is an assessment project lead by the John Hopkins University on Coursera platform.  
This is a part of the third course of Data Science Specilization named Getting and Cleaning Data.

More information about the data source is in the synopsis.

Author of the analysis: Molina Rafidison  
January 2015  
Github link: https://github.com/theya/CourseProject

## License

Data are provided by UCI and deals with Human activity recognition using smartphones.  

Source credits:  
Jorge L. Reyes-Ortiz(1,2), Davide Anguita(1), Alessandro Ghio(1), Luca Oneto(1) and Xavier Parra(2)  
1 - Smartlab - Non-Linear Complex Systems Laboratory  
DITEN - Università degli Studi di Genova, Genoa (I-16145), Italy.   
2 - CETpD - Technical Research Centre for Dependency Care and Autonomous Living  
Universitat Politècnica de Catalunya (BarcelonaTech). Vilanova i la Geltrú (08800), Spain  
activityrecognition '@' smartlab.ws  