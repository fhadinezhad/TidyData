run_analysis.R <- function() {
        ## first thing before running the function is to change the
        ## working directory to the assignment folder. for example :
        ## setwd("/home/fateme/Dropbox/coursera/UCI HAR Dataset/")
        ## th
        testData <- read.table("./test/X_test.txt", header = FALSE)
        trainData <-
                read.table("./train/X_train.txt", header = FALSE)
        testY <- read.table("./test/y_test.txt", header = FALSE)
        trainY <- read.table("./train/y_train.txt")
        subjTrain <- read.table("./train/subject_train.txt")
        subjTest <- read.table("./test/subject_test.txt")
        testData2 <- cbind(testData,testY$V1,subjTest$V1)
        trainData2 <- cbind(trainData,trainY$V1,subjTrain$V1)
        library("dplyr")
        library(reshape2)
        colnames(trainData2)[562] <- "activity"
        colnames(trainData2)[563] <- "subject"
        colnames(testData2)[562] <- "activity"
        colnames(testData2)[563] <- "subject"
        mergedData <- rbind(trainData2,testData2)
        
        features <- read.table("./features.txt")
        names(mergedData) <- features$V2
        names(mergedData)[562] <- "activity"
        names(mergedData)[563] <- "subject"
        
        strMean <-
                grepl("[mM][eE][aA][nN]|[sS][tT][dD]",names(mergedData))
        StrMean <- mergedData[,strMean]
        
        mergedData$activity <-
                sub("1","WALKING",mergedData$activity)
        mergedData$activity <-
                sub("2","WALKING_UPSTAIRS",mergedData$activity)
        mergedData$activity <-
                sub("3","WALKING_DOWNSTAIRS",mergedData$activity)
        mergedData$activity <-
                sub("4","SITTING",mergedData$activity)
        mergedData$activity <-
                sub("5","STANDING",mergedData$activity)
        mergedData$activity <- sub("6","LAYING",mergedData$activity)
        
        meltData <-
                melt(
                        mergedData,id = c("activity", "subject"), measure.vars = features$V2,na.rm = TRUE
                )
        tidyData <-
                dcast(meltData, activity + subject ~ variable, value.var = "value", mean)
        write.table(tidyData,file = "./myTidyData.txt", row.name=FALSE)
}