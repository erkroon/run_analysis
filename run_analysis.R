#Get the data
#fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
#download.file(fileUrl, destfile = "Dataset.zip", method = "curl") 
#unzip("Dataset.zip") 

#read the data
y_test = read.table("./cleandata/test/y_test.txt")             
subject_test = read.table("./cleandata/test/subject_test.txt") 
x_test = read.table("./cleandata/test/x_test.txt")             
x_train = read.table("./cleandata/train/x_train.txt")          
y_train = read.table("./cleandata/train/y_train.txt")          
subject_train  = read.table("./cleandata/train/subject_train.txt") 
header = read.table("./cleandata/features.txt")                

# 4. Appropriately labels the data set with descriptive activity names
colnames(x_test) <- header$V2
colnames(x_train) <- header$V2
colnames(y_test) <- c("activity")
colnames(y_train) <- c("activity")
colnames(subject_test) <- c("subject")
colnames(subject_train) <- c("subject")

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
extract_mean_std <- grep("mean\\(\\)|std\\(\\)", header[, 2]) # gives 66 columns back from the header file

x_test <- x_test[, extract_mean_std] # Select only the columns with the mean and std in the list
x_test <- cbind(x_test,y_test)  # merge the test data
x_test <- cbind(x_test,subject_test) # add the subject

x_train <- x_train[, extract_mean_std] # Select only the columns with the mean and std in the list
x_train <- cbind(x_train,y_train) # merge the training data
x_train <- cbind(x_train,subject_train) # merge the subjects

# 1. Merging data together
bigData <- rbind(x_test,x_train) # make one table

# 3. Uses descriptive activity names to name the activities in the data set
bigData$activity[bigData$activity == 1] = "WALKING" 
bigData$activity[bigData$activity == 2] = "WALKING_UPSTAIRS" 
bigData$activity[bigData$activity == 3] = "WALKING_DOWNSTAIRS" 
bigData$activity[bigData$activity == 4] = "SITTING" 
bigData$activity[bigData$activity == 5] = "STANDING" 
bigData$activity[bigData$activity == 6] = "LAYING" 

# 5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy <- aggregate(bigData, by=list(activity = bigData$activity, subject=bigData$subject), mean)
#remove activity and subject, no meaning
tidy[,70]= NULL
tidy[,69] = NULL
write.table(tidy, "./cleandata/tidy.txt", sep=",", row.names=FALSE)
