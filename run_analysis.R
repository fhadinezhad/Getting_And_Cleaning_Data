run_analysis <- function() {
        library("dplyr")
        library(reshape2)
        
        # change the working directory to the folder of homework
        #for example :setwd("/home/fateme/Dropbox/coursera/UCI HAR Dataset/")
        
        #read the fallowing files into the fallowing variables as data frame ------------------
        
        testData <- read.table("./test/X_test.txt", header = FALSE)
        trainData <-
                read.table("./train/X_train.txt", header = FALSE)
        testY <- read.table("./test/y_test.txt", header = FALSE)
        trainY <- read.table("./train/y_train.txt")
        subjTrain <- read.table("./train/subject_train.txt")
        subjTest <- read.table("./test/subject_test.txt")
        
        # merging files together and changing the variable lables to descriptive names --------
        
        
        testData2 <- cbind(testData,testY$V1,subjTest$V1)
        trainData2 <- cbind(trainData,trainY$V1,subjTrain$V1)
        
        colnames(trainData2)[562] <- "activity"
        colnames(trainData2)[563] <- "subject"
        colnames(testData2)[562] <- "activity"
        colnames(testData2)[563] <- "subject"
        mergedData <- rbind(trainData2,testData2)
        
        features <- read.table("./features.txt")
        names(mergedData) <- features$V2
        names(mergedData)[562] <- "activity"
        names(mergedData)[563] <- "subject"
        
        # extract only the measurements on the mean and standard deviation for each measurement from this mergedData file.
        # we assume that any feature that has the word "mean" anywhere is a mean meaturment
        
        strMean <-
                grepl("[mM][eE][aA][nN]|[sS][tT][dD]",names(mergedData))
        StrMean <- mergedData[,strMean]
        
        # adding the activity and subject column to the new data file
        
        Std_Mean_Data <-
                cbind(mergedData$activity,mergedData$subject, StrMean)
        
        names(Std_Mean_Data)[1] <- "activity"
        names(Std_Mean_Data)[2] <- "subject"
        # changing the number of activities to more discriptive names
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
        
        # changing data to the long format inorder to recast them to the wide format with the mean of measurments
        meltData <-
                melt(
                        Std_Mean_Data,id = c("activity", "subject"), measure.vars = names(Std_Mean_Data)[-(1:2)],na.rm = TRUE
                )
        tidyData <-
                dcast(meltData, activity + subject ~ variable, mean)
        write.table(tidyData,file = "./myTidyData.txt", row.name = FALSE)
}