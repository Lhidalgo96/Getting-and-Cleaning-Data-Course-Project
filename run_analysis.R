# 1. Merges the training and the test sets to create one data set.

    # Reading datasets

        x_train <- read.table("./cleanDataProject/UCI HAR Dataset/train/X_train.txt")
        y_train <- read.table("./cleanDataProject/UCI HAR Dataset/train/y_train.txt")

        subject_train <- read.table("./cleanDataProject/UCI HAR Dataset/train/subject_train.txt")

        x_test <- read.table("./cleanDataProject/UCI HAR Dataset/test/X_test.txt")
        y_test <- read.table("./cleanDataProject/UCI HAR Dataset/test/y_test.txt")

        subject_test <- read.table("./cleanDataProject/UCI HAR Dataset/test/subject_test.txt")

        features <- read.table("./cleanDataProject/UCI HAR Dataset/features.txt")

        activityLabels = read.table("./cleanDataProject/UCI HAR Dataset/activity_labels.txt")
    
    ## Appropriately labels the data set with descriptive variable names. 
    
        colnames(x_train) <- features[,2]
        colnames(y_train) <- "activityID"
        colnames(subject_train) <- "subjectID"
        colnames(x_test) <- features[,2]
        colnames(y_test) <- "activityID"
        colnames(subject_test) <- "subjectID"
        colnames(activityLabels) <- c("activityID", "activityType")

    #Merge

        alltrain <- cbind(y_train, subject_train, x_train)
        alltest <- cbind(y_test, subject_test, x_test)
        myDataset <- rbind(alltrain, alltest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    
     colNames <- colnames(myDataset)

     meanAndSTD <- (grepl("activityID", colNames) | grepl("subjectID", colNames) | grepl("mean: ", colNames) | grepl("std: ", colNames) )

     setMeanandStd <- myDataset[ , meanAndSTD == TRUE]

# 3. Uses descriptive activity names to name the activities in the data set

     setWithActivityNames <- merge(setMeanandStd, activityLabels,by = "activityID", all.x = TRUE)


# 4. Independent tidy data set with the average of each variable for each activity and each subject.

      tidyDataSet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
      tidyDataSet <- tidyDataSet[order(tidyDataSet$subjectID, tidyDataSet$activityID), ]

      write.table(tidyDataSet, "tidyDataSet.txt", row.names = FALSE)