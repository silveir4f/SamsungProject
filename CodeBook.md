# SamsungProject
Getting and Cleaning Data

title: "CODEBOOK"
author: "Rafael Silveira @silveiR4f"

### INTRO

This document describe the process for the Getting and Cleaning Data Project.

The data about wearable computing was collected from the accelerometers from the Samsung Galaxy S smartphone.

### RAW DATA 

Data was provided by Coursera. It was divided into Test and Train files (t*) :

 * Subject number (a vector between 1 and 30) **[subject_t*.txt]**
 * Activity Id (a vector between 1 and 6) **[Y_t*.txt]**
 * Feature measurents (a data matrix with a collection of signals and statistical measures) **[X_t*.txt]**.

### GOAL


The goal is to create a tidy data set (in wide or long format) with the average of each variable, for each activity and each subject. In order to achieve that: 

 * Merges the training and the test sets to create one data set.
 * Extracts only the measurements on the mean and standard deviation for each measurement. 
 * Uses descriptive activity names to name the activities in the data set
 * Appropriately labels the data set with descriptive variable names. 


### CODEBOOK

Included a new variable in Y_test.txt and Y_train.txt with the label of the activities in activity_labels.txt. Merged the train data sets: first the SUBJECT (subject_train.txt), ACTIVITY (Y_train.txt), a new variable TT to indicate this data as "TRAIN" and finally the X_train.txt. Merged the test data sets: first the SUBJECT (subject_test.txt), ACTIVITY (Y_test.txt), a new variable TT to indicate this data as "TEST" and finally the X_test.txt. Merged the test and train datasets into one. Reshaped the data set into long format. Added the labels of the features in the long data set with the referenced label in the features.txt file. Subset the data set to contain only "mean()" and "std()" measurements. Agregate the long data set to calculate the mean for each Subject, Activity and Feature Measurement (tidy data for submission).
