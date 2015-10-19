##########################################
####  COURSERA
####  DATA SCIENCE SPECIALIZATION
####  GETTING AND CLEANING DATA - PROJECT
####  RAFAEL G SILVEIRA @SILVEIR4F
##########################################

##########################################
#### PREAMBLE -- installing and loading necessary packages for this assigment
##########################################
install.packages("tidyr")
install.packages("sqldf")
install.packages("psych")
install.packages("plyr")
library(tidyr)
library(sqldf)
library(psych)
library(plyr)


##########################################
#### SETTING WORKING DIRECTORY  -- pointing to UCI HAR Dataset folder
##########################################
setwd("C:/R/UCI HAR Dataset/")


##########################################
#### LOADING FILES
##########################################
subject_train <- read.table("train/subject_train.txt")  
X_train <- read.table("train/X_train.txt") 
Y_train <- read.table("train/Y_train.txt")
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")


################################################
#### PRIOR MERGING THE TRAIN AND TEST DATASETS -- data fixing Y_t* files
################################################
# ADDING A VARIABLE TO IDENTIFY THE LABEL OF THE ACTIVITY | SQLDF: LEFT JOIN from "activity_labels.txt"
Y_train <- sqldf('SELECT Y_train.*, activity_labels.V2 FROM Y_train LEFT JOIN activity_labels ON Y_train.V1=activity_labels.V1;')
Y_test <- sqldf('SELECT Y_test.*, activity_labels.V2 FROM Y_test LEFT JOIN activity_labels ON Y_test.V1=activity_labels.V1;')


################################################
#### MERGING THE TRAIN DATA SET
################################################
#SUBJECT from subject_train, ACTIVITY from Y_train, TT (TEST/TRAIN) declaring "TRAIN"
TRAIN <- data.frame(SUBJECT=subject_train[,1],ACTIVITY=Y_train[,2],TT="TRAIN") 
# TRAIN + X_train 
TRAIN <- cbind(TRAIN,X_train)


################################################
#### MERGING THE TEST DATA SET
################################################
#SUBJECT from subject_test, ACTIVITY from Y_test, TT (TEST/TRAIN) declaring "TEST"
TEST <- data.frame(SUBJECT=subject_test[,1], ACTIVITY=Y_test[,2], TT="TEST")
# TEST + X_test 
TEST <- cbind(TEST, X_test)


################################################
#### MERGING THE TEST AND TRAIN
################################################
TT <- rbind(TRAIN,TEST)


################################################
#### TRANSFORMING THE MERGED DATASETS INTO LONG FORMAT
################################################
TTLONG <- gather(TT, VARIABLE, MEASUREMENT, V1:V561)


################################################
#### TRANSFORMING THE MERGED DATASETS INTO LONG FORMAT
################################################
TTLONG$VARIABLE <- gsub("V", "", TTLONG$VARIABLE) # removing the "V"
TTLONG <- sqldf('SELECT TTLONG.*, features.V2 FROM TTLONG LEFT JOIN features ON TTLONG.VARIABLE=features.V1;') 
TTLONG$VARIABLE <- TTLONG[,6]  
TTLONG <- TTLONG[,-6] 


################################################
#### SUBSETTING MEAN() AND STD()
################################################
TTLONG_MS <- sqldf("SELECT TTLONG.* FROM TTLONG WHERE (TTLONG.VARIABLE LIKE '%mean()%') OR (TTLONG.VARIABLE LIKE '%std()%') ")
TTLONG_MS$VARIABLE <- factor(TTLONG_MS$VARIABLE)  # removing empty levels


################################################
#### TIDY DATA WITH DDPLY[PLYR]
################################################
TIDY_DATA <- ddply(TTLONG_MS,.(SUBJECT,ACTIVITY,VARIABLE),summarise,MEAN=round(mean(MEASUREMENT),2))
write.table(TIDY_DATA, "TIDYDATA.txt", row.name=FALSE, sep="\t", dec=".") 
