#Assignment Module 3

#if (!file.exists("Project"))   dir.create("Project")
setwd("D:/AIS/kursus/DataScience/Module3/Project")


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileURL, destfile=("./Project3-dataset.zip"))
unzip("./Project3-dataset.zip" )

# 1. Merges the training and the test sets to create one data set.
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x <- rbind(x.train, x.test)

subj.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subj.test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subj <- rbind(subj.train, subj.test)

y.train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y <- rbind(y.train, y.test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./UCI HAR Dataset/features.txt")
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2]) #Only extract the features with mean and std only
x.mean.sd <- x[, mean.sd] #x.mean.sd holds the mean and std measurements only

# 3. Uses descriptive activity names to name the activities in the data set
names(x.mean.sd) <- features[mean.sd, 2] # Get the names of the features
names(x.mean.sd) <- tolower(names(x.mean.sd)) #Lowercase the features names
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd)) #Remove the () in the features names

activities <- read.table('./UCI HAR Dataset/activity_labels.txt') # Get the names of the activities
activities[, 2] <- tolower(as.character(activities[, 2])) #Lowercase the activities names
activities[, 2] <- gsub("_", "", activities[, 2]) #Remove the _ in the features names

y[, 1] = activities[y[, 1], 2] #Get all the training labels
colnames(y) <- 'activity' #Name the column names as activity
colnames(subj) <- 'subject' #Name the column names as subject

# 4. Appropriately labels the data set with descriptive activity names.
data <- cbind(subj, x.mean.sd, y)
str(data)
write.table(data, "./merged.txt", row.names = F)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
str(average.df)
write.table(average.df, './average.txt', row.names = FALSE)

