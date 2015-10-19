---
title: "README"
author: "Rafael Silveira @silveiR4f"
output: html_document
---

To run this script it's necessary to install and run the following R Packages:

```{r, include=FALSE, cache=FALSE}
library(tidyr)
library(sqldf)
library(psych)
library(plyr)
```

In order to load the files, the next step will set the working directory to the folder downloaded from the Project page. After that, loading the three data sets of the train group, the three data sets of the test group, the activity labels and the feature labels.

```{r, eval=TRUE}
setwd("C:/R/UCI HAR Dataset/")
subject_train <- read.table("train/subject_train.txt")  
X_train <- read.table("train/X_train.txt") 
Y_train <- read.table("train/Y_train.txt")
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
Y_test <- read.table("test/Y_test.txt")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")
```

Before merging the two data sets, the following script will add a new variable to the **Y_test** and **Y_train** data sets with the label of the activity (found in activity_labels.txt).

```{r, eval=TRUE, warning=FALSE}
Y_train <- sqldf('SELECT Y_train.*, activity_labels.V2 FROM Y_train LEFT JOIN activity_labels ON Y_train.V1=activity_labels.V1;')
Y_test <- sqldf('SELECT Y_test.*, activity_labels.V2 FROM Y_test LEFT JOIN activity_labels ON Y_test.V1=activity_labels.V1;')
```

Merging the train data sets into a single data set **TRAIN**. Here I created a new variable TT to label this data set as train and be able to identify these observations after they are merged with the other half. 

```{r, eval=TRUE}
TRAIN <- data.frame(SUBJECT=subject_train[,1],ACTIVITY=Y_train[,2],TT="TRAIN") 
TRAIN <- cbind(TRAIN,X_train)
```

Merging the three *test* data sets into a single data set **TEST**. Here I created a new variable TT to label this data set as test and be able to identify these observations after they are merged with the other half.

```{r, eval=TRUE}
TEST <- data.frame(SUBJECT=subject_test[,1], ACTIVITY=Y_test[,2], TT="TEST")
TEST <- cbind(TEST, X_test)
```

Merging the **TRAIN** and **TEST** data sets into a new data set **TT** and reshaping the data set into long format in a new dataset **TTLONG**.

```{r, eval=TRUE}
TT <- rbind(TRAIN,TEST)
TTLONG <- gather(TT, VARIABLE, MEASUREMENT, V1:V561)
```

Complementing the **VARIABLE** variable with the feature labels found in **features.txt**. For that it's necessary to remove the default V in the variable name in order to perform a *LEFT JOIN* with the sqldf() function.

```{r, eval=TRUE}
TTLONG$VARIABLE <- gsub("V", "", TTLONG$VARIABLE) # removing the "V"
TTLONG <- sqldf('SELECT TTLONG.*, features.V2 FROM TTLONG LEFT JOIN features ON TTLONG.VARIABLE=features.V1;') 
TTLONG$VARIABLE <- TTLONG[,6]  
TTLONG <- TTLONG[,-6] 
```
Now, with the labels of the features and measurements it's possible to subset only the mean and standard deviation measures.
 
 * mean()
 * std()

```{r, eval=TRUE}
TTLONG_MS <- sqldf("SELECT TTLONG.* FROM TTLONG WHERE (TTLONG.VARIABLE LIKE '%mean()%') OR (TTLONG.VARIABLE LIKE '%std()%') ")
TTLONG_MS$VARIABLE <- factor(TTLONG_MS$VARIABLE)  # removing empty levels
```

Now, the final step, creating a tidy data set with DDPLY. This function calculates the mean for each subject, activity and feature measurement.

```{r, eval=TRUE}
TIDY_DATA <- ddply(TTLONG_MS,.(SUBJECT,ACTIVITY,VARIABLE),summarise,MEAN=round(mean(MEASUREMENT),2))
head(TIDY_DATA)
dim(TIDY_DATA)
```

Voilà!
