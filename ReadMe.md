==================================================================
<dd>
The data can be downloaded from thie link :
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

</dd>
==================================================================

###Instuctions For Running The Script

first thing before running the function is to download the file and unzip it.
then change the working directory to the assignment folder. 
for example : setwd("/home/fateme/Dropbox/coursera/UCI HAR Dataset/")

The output will be in the file myTidyData.txt in the current directory.

==================================================================
### Code Explanation : 

1. first we read the fallowing files into the fallowing variables as data frame :

```
testData <- X_test.txt
trainData <- X_train.txt
testY <- y_test.txt
trainY <- y_train.txt
subjTrain <- subject_train.txt
subjTest <- subject_test.txt
```

until now the dimention are as fallow:

```
> dim(testData)
[1] 2947  561
> dim(trainData)
[1] 7352  561
> dim(trainY)
[1] 7352    1
> dim(testY)
[1] 2947    1
```

<t> train/testY and subjectTrain/test are the activities and subjects. <\t>

2. We make them as one file with these two commands for test and train:

```
testData2 <- cbind(testData,testY$V1,subjTest$V1)
trainData2 <- cbind(trainData,trainY$V1,subjTrain$V1)
```

3.Inorder to merge these two file of data with rbind, we need to have a common name for the colomns, so we should change the name of last two columns for activity and subject.

```
> colnames(trainData2)[562] <- "activity"
> colnames(trainData2)[563] <- "subject"
> colnames(testData2)[562] <- "activity"
> colnames(testData2)[563] <- "subject"
```

Now we can merge these two files :

``` mergedData <- rbind(trainData2,testData2) ```

now this is the dimention of our data :

```
> str(mergedData)
'data.frame':	10299 obs. of  562 variables:
```

4. Now,first we will do the part 4 for the assignment to label the data with discriptive variable names instead of the names R put on them automaticly. 
these discriptive variable names are in feature file, so :

``` features <- read.table("./features.txt") ```

```
names(mergedData) <- features$V2
names(mergedData)[562] <- "activity" 
names(mergedData)[563] <- "subject"
```

5. Now, we extract only the measurements on the mean and standard deviation for each measurement from this mergedData file :
we assume that any feature that has the word "mean" anywhere is a mean meaturment. so :

```
strMean <- grepl("[mM][eE][aA][nN]|[sS][tT][dD]",names(mergedData))
StrMean <- mergedData[,strMean]
```

Now we have those meaturements in strMean variable as the assignment asked.

6.Then we are going to put descriptive activity names for the activities in the data set. (since the assignment did not asked to use the original data file or the extracted meaturements, we use the original file with all the features)

In order to name the activities with more intuitive and discriptive names we use the lables from the activity_label file.

```
Std_Mean_Data$activity <-
                sub("1","WALKING", Std_Mean_Data$activity)
        Std_Mean_Data$activity <-
                sub("2","WALKING_UPSTAIRS", Std_Mean_Data$activity)
        Std_Mean_Data$activity <-
                sub("3","WALKING_DOWNSTAIRS", Std_Mean_Data$activity)
        Std_Mean_Data$activity <-
                sub("4","SITTING", Std_Mean_Data$activity)
        Std_Mean_Data$activity <-
                sub("5","STANDING", Std_Mean_Data$activity)
        Std_Mean_Data$activity <-
                sub("6","LAYING", Std_Mean_Data$activity)
```

Right now, our data is in a wide format since each subject and activity has its own meaturments in one row. which is good for repeated function we might do on our data in future.
But we are melting it to the long and thin format first. ( Long format where each row has its own DV meaturment so that the pair of subjects and avtivities might be repeated in the data .) the nice thing about this is that we have just one column for everything. (such as one for activity, one for subject and one for measutment type and one for the value of the measurement) the reason we are doing this is becasuse after melting we want to measure the mean of all measurment for each subj and activity by casting it back to wide format, But just for subj, activity and means.


7.So we first melt it to the long format like this :

```
meltData <-
                melt(
                        Std_Mean_Data,id = c("activity", "subject"), measure.vars = names(Std_Mean_Data)[-(1:2)],na.rm = TRUE
                )
```

8.Then we cast it to wide format in the way we like, for just subject and activities, and the mean for each pair.

```
 tidyData <-
                dcast(meltData, activity + subject ~ variable, mean)
```

<dd> Now the tidy data file is a tidy data, because for each subject and acitivity we have the mean of each meaturement in the same row.

depending on what we want to do with the data we can change it to long format or keep it in wide format.<\dd>

Finally we write it into a file :

        write.table(tidyData,file = "./myTidyData.txt", row.name = FALSE)






















