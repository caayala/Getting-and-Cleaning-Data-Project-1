# run_analysis.R

rm(list = ls())
setwd('/Users/caayala/Dropbox (DESUC)/Documentos/Clases/Getting and Cleaning Data/Project 1')

packages <- c("dplyr", "tidyr", "readr")

if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages()))) 
  # Compara los paquetes requeridos con la lista de nombres de paquetes instalados.
}

library(dplyr)
library(tidyr)
library(readr)


# Merges the training and the test sets to create one data set.

if (!file.exists('20Dataset.zip')) {
  url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url = url, destfile = '20Dataset.zip')
  file <- unzip('20Dataset.zip')
}

# Exlore the files in the zip file

## View files inside zip file
files <- dir('UCI HAR Dataset',  recursive = TRUE)

features <- read_delim('UCI HAR Dataset/features.txt', col_names = FALSE, delim = " ")
colnames(features) <- c('id', 'variable')
sum(duplicated(features$variable))

features <- features %>%
  group_by(variable) %>%
  mutate(tot = n(),
         num = 1:n())

table(features$num, features$tot)

## Create unique names for features variables
features <- features %>%
  ungroup() %>%
  mutate(variable = ifelse(tot > 1, paste0(variable,'-',num), variable))

## Read test data
subject_test <- read_table('UCI HAR Dataset/test/subject_test.txt', col_names = FALSE)
X_test <- read_table('UCI HAR Dataset/test/X_test.txt', col_names = FALSE)
y_test <- read_table('UCI HAR Dataset/test/y_test.txt', col_names = FALSE)

nrow(unique(subject_test))

## Add variable names to columns
colnames(subject_test) <- 'subject'
colnames(X_test) <- features$variable
colnames(y_test) <- 'activity'

## Bind subject and data test database
test <- bind_cols(subject_test, y_test) %>%
	mutate(source = 'test') %>%
  bind_cols(X_test)

## Read train data
subject_train <- read_table('UCI HAR Dataset/train/subject_train.txt', col_names = FALSE)
X_train <- read_table('UCI HAR Dataset/train/X_train.txt', col_names = FALSE)
y_train <- read_table('UCI HAR Dataset/train/y_train.txt', col_names = FALSE)

nrow(unique(subject_train))

## Add variable names to columns
colnames(subject_train) <- 'subject'
colnames(X_train) <- features$variable
colnames(y_train) <- 'activity'

## Bind subject and data train database
train <- bind_cols(subject_train, y_train) %>%
  mutate(source = 'train') %>%
  bind_cols(X_train)

## Bind test and train database
dataset <- bind_rows(test, train)

# Extracts only the measurements on the mean and standard deviation for each measurement. 

dataset_filter <- dataset %>%
  select(subject, activity, source, matches('mean\\(|std\\('))

# Uses descriptive activity names to name the activities in the data set.

table(dataset_filter$activity)
dataset_filter$activity <- factor(dataset_filter$activity, 
                                  levels = c(1, 2, 3, 4, 5, 6), 
                                  labels = c('walking', 
                                             'walking_upstairs', 
                                             'walking_downstairs', 
                                             'sitting', 
                                             'standing', 
                                             'laying'))
table(dataset_filter$activity)

dataset_filter$source <- as.factor(dataset_filter$source)
table(dataset_filter$source)

# Appropriately labels the data set with descriptive variable names. 

## Set labels for mean varabiables
attributes(dataset_filter$`tBodyAcc-mean()-X`)$label <- 'time Body Accelerometer X-axial signal - mean'
attributes(dataset_filter$`tBodyAcc-mean()-Y`)$label <- 'time Body Accelerometer Y-axial signal - mean'
attributes(dataset_filter$`tBodyAcc-mean()-Z`)$label <- 'time Body Accelerometer Z-axial signal - mean'
attributes(dataset_filter$`tGravityAcc-mean()-X`)$label <- 'time Gravity Accelerometer X-axial signal - mean'
attributes(dataset_filter$`tGravityAcc-mean()-Y`)$label <- 'time Gravity Accelerometer Y-axial signal - mean'
attributes(dataset_filter$`tGravityAcc-mean()-Z`)$label <- 'time Gravity Accelerometer Z-axial signal - mean'
attributes(dataset_filter$`tBodyAccJerk-mean()-X`)$label <- 'time Body Accelerometer Jerk X-axial signal - mean'
attributes(dataset_filter$`tBodyAccJerk-mean()-Y`)$label <- 'time Body Accelerometer Jerk Y-axial signal - mean'
attributes(dataset_filter$`tBodyAccJerk-mean()-Z`)$label <- 'time Body Accelerometer Jerk Z-axial signal - mean'
attributes(dataset_filter$`tBodyGyro-mean()-X`)$label <- 'time Body Gyroscope X-axial signal - mean'
attributes(dataset_filter$`tBodyGyro-mean()-Y`)$label <- 'time Body Gyroscope Y-axial signal - mean'
attributes(dataset_filter$`tBodyGyro-mean()-Z`)$label <- 'time Body Gyroscope Z-axial signal - mean'
attributes(dataset_filter$`tBodyGyroJerk-mean()-X`)$label <- 'time Body Gyroscope Jerk X-axial signal - mean'
attributes(dataset_filter$`tBodyGyroJerk-mean()-Y`)$label <- 'time Body Gyroscope Jerk Y-axial signal - mean'
attributes(dataset_filter$`tBodyGyroJerk-mean()-Z`)$label <- 'time Body Gyroscope Jerk Z-axial signal - mean'
attributes(dataset_filter$`tBodyAccMag-mean()`)$label 		 <- 'time Body Accelerometer magnitude signal - mean'
attributes(dataset_filter$`tGravityAccMag-mean()`)$label 		 <- 'time Gravity Accelerometer magnitude signal - mean'
attributes(dataset_filter$`tBodyAccJerkMag-mean()`)$label 		 <- 'time Body Accelerometer Jerk magnitude signal - mean'
attributes(dataset_filter$`tBodyGyroMag-mean()`)$label 		 <- 'time Body Gyroscope magnitude signal - mean'
attributes(dataset_filter$`tBodyGyroJerkMag-mean()`)$label 		 <- 'frecuency Body Gyroscope Jerk magnitude signal - mean'
attributes(dataset_filter$`fBodyAcc-mean()-X`)$label <- 'frecuency Body Accelerometer X-axial signal - mean'
attributes(dataset_filter$`fBodyAcc-mean()-Y`)$label <- 'frecuency Body Accelerometer Y-axial signal - mean'
attributes(dataset_filter$`fBodyAcc-mean()-Z`)$label <- 'frecuency Body Accelerometer Z-axial signal - mean'
attributes(dataset_filter$`fBodyAccJerk-mean()-X`)$label <- 'frecuency Body Accelerometer Jerk X-axial signal - mean'
attributes(dataset_filter$`fBodyAccJerk-mean()-Y`)$label <- 'frecuency Body Accelerometer Jerk Y-axial signal - mean'
attributes(dataset_filter$`fBodyAccJerk-mean()-Z`)$label <- 'frecuency Body Accelerometer Jerk Z-axial signal - mean'
attributes(dataset_filter$`fBodyGyro-mean()-X`)$label <- 'frecuency Body Gyroscope X-axial signal - mean'
attributes(dataset_filter$`fBodyGyro-mean()-Y`)$label <- 'frecuency Body Gyroscope Y-axial signal - mean'
attributes(dataset_filter$`fBodyGyro-mean()-Z`)$label <- 'frecuency Body Gyroscope Z-axial signal - mean'
attributes(dataset_filter$`fBodyAccMag-mean()`)$label 		 <- 'frecuency Body Accelerometer magnitude signal - mean'
attributes(dataset_filter$`fBodyBodyAccJerkMag-mean()`)$label 		 <- 'frecuency Body Accelerometer Jerk magnitude signal - mean'
attributes(dataset_filter$`fBodyBodyGyroMag-mean()`)$label 		 <- 'frecuency Body Gyroscope magnitude signal - mean'
attributes(dataset_filter$`fBodyBodyGyroJerkMag-mean()`)$label 		 <- 'frecuency Body Gyroscope Jerk magnitude signal - mean'

## Set labels for Standard deviation varabiables
attributes(dataset_filter$`tBodyAcc-std()-X`)$label <- 'time Body Accelerometer X-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAcc-std()-Y`)$label <- 'time Body Accelerometer Y-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAcc-std()-Z`)$label <- 'time Body Accelerometer Z-axial signal - Standard deviation'
attributes(dataset_filter$`tGravityAcc-std()-X`)$label <- 'time Gravity Accelerometer X-axial signal - Standard deviation'
attributes(dataset_filter$`tGravityAcc-std()-Y`)$label <- 'time Gravity Accelerometer Y-axial signal - Standard deviation'
attributes(dataset_filter$`tGravityAcc-std()-Z`)$label <- 'time Gravity Accelerometer Z-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAccJerk-std()-X`)$label <- 'time Body Accelerometer Jerk X-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAccJerk-std()-Y`)$label <- 'time Body Accelerometer Jerk Y-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAccJerk-std()-Z`)$label <- 'time Body Accelerometer Jerk Z-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyro-std()-X`)$label <- 'time Body Gyroscope X-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyro-std()-Y`)$label <- 'time Body Gyroscope Y-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyro-std()-Z`)$label <- 'time Body Gyroscope Z-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyroJerk-std()-X`)$label <- 'time Body Gyroscope Jerk X-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyroJerk-std()-Y`)$label <- 'time Body Gyroscope Jerk Y-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyGyroJerk-std()-Z`)$label <- 'time Body Gyroscope Jerk Z-axial signal - Standard deviation'
attributes(dataset_filter$`tBodyAccMag-std()`)$label 		 <- 'time Body Accelerometer magnitude signal - Standard deviation'
attributes(dataset_filter$`tGravityAccMag-std()`)$label 		 <- 'time Gravity Accelerometer magnitude signal - Standard deviation'
attributes(dataset_filter$`tBodyAccJerkMag-std()`)$label 		 <- 'time Body Accelerometer Jerk magnitude signal - Standard deviation'
attributes(dataset_filter$`tBodyGyroMag-std()`)$label 		 <- 'time Body Gyroscope magnitude signal - Standard deviation'
attributes(dataset_filter$`tBodyGyroJerkMag-std()`)$label 		 <- 'frecuency Body Gyroscope Jerk magnitude signal - Standard deviation'
attributes(dataset_filter$`fBodyAcc-std()-X`)$label <- 'frecuency Body Accelerometer X-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAcc-std()-Y`)$label <- 'frecuency Body Accelerometer Y-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAcc-std()-Z`)$label <- 'frecuency Body Accelerometer Z-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAccJerk-std()-X`)$label <- 'frecuency Body Accelerometer Jerk X-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAccJerk-std()-Y`)$label <- 'frecuency Body Accelerometer Jerk Y-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAccJerk-std()-Z`)$label <- 'frecuency Body Accelerometer Jerk Z-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyGyro-std()-X`)$label <- 'frecuency Body Gyroscope X-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyGyro-std()-Y`)$label <- 'frecuency Body Gyroscope Y-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyGyro-std()-Z`)$label <- 'frecuency Body Gyroscope Z-axial signal - Standard deviation'
attributes(dataset_filter$`fBodyAccMag-std()`)$label 		 <- 'frecuency Body Accelerometer magnitude signal - Standard deviation'
attributes(dataset_filter$`fBodyBodyAccJerkMag-std()`)$label 		 <- 'frecuency Body Accelerometer Jerk magnitude signal - Standard deviation'
attributes(dataset_filter$`fBodyBodyGyroMag-std()`)$label 		 <- 'frecuency Body Gyroscope magnitude signal - Standard deviation'
attributes(dataset_filter$`fBodyBodyGyroJerkMag-std()`)$label 		 <- 'frecuency Body Gyroscope Jerk magnitude signal - Standard deviation'

# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

dataset_mean <- dataset_filter %>%
  group_by(subject, activity, source) %>%
  summarise_each('mean')

write.table(dataset_mean, file = 'dataset_mean.txt', row.name=FALSE)
