# Getting and cleaning data: Project 1

Creating a tidy data set of wearable computing data for the course *Getting and Cleaning Data*

## Files in this repo
* README.md -- you are reading it right now
* CodeBook.md -- codebook describing variables, the data and transformations
* run_analysis.R -- actual R code

## run_analysis.R
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

It should run in a folder with Samsung data zip file. The script assumes it is in the working directory.

The tidy dataset output is created in the working directory as `dataset_mean.csv`.

## run_analysis.R walkthrough
It follows the goals step by step.

* Step 1:
  * Unzip and read all the test and training files.
  * Combine the files to a single data frame `dataset`.

* Step 2:
  * Select the variables from `dataset` that are either means ("mean(") or standard deviations ("std(").
  * A new data frame is then created: `dataset_filter`.

* Step 3:
  * Create factors for `activity` and `source` variables.
  * Add labels to every variable.
  
* Step 4:
  * Write the tidy set into a text file called `dataset_mean.csv`.