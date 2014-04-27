library(stringr)
library(plyr)

fname <- 'UCI\ HAR\ Dataset/'
zipfile <- 'har_data.zip'
if(! file.exists(fname)) {
  download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                method='curl', destfile=zipfile)
  unzip(zipfile)
}

labelNames <- read.table(paste(fname, 'activity_labels.txt', sep='/'))
colnames(labelNames) <- c("label", "activity")

featureNames <- read.table(paste(fname, 'features.txt', sep='/'), stringsAsFactors=F)
colnames(featureNames) <- c("featureNum", "featureName")
featureNames <- featureNames$featureName
featureNames <- str_replace_all(featureNames, "-", "_")
featureNames <- str_replace_all(featureNames, "[\\(|\\)]", "")

#direc <- 'test'
readData <- function(direc) {
  Xdata <- read.table(paste(paste(fname, direc, 'X', sep='/'), '_', direc, '.txt', sep=''))
  colnames(Xdata) <- featureNames
  Ydata <- read.table(paste(paste(fname, direc, 'y', sep='/'), '_', direc, '.txt', sep=''))  
  # Uses descriptive activity names to name the activities in the data set  
  # Appropriately labels the data set with descriptive activity names.   
  Ydata$activity <- labelNames[Ydata$V1,"activity"]  
  subject <- read.table(paste(paste(fname, direc, 'subject', sep='/'), '_', direc, '.txt', sep=''))
  colnames(subject) <- c('subject')
  subject$subject <- factor(subject$subject)
  cbind(activity=Ydata[,'activity'], subject, Xdata)
}

# Merges the training and the test sets to create one data set.
testData <- readData('test')
trainData <- readData('train')
fullData <- rbind(trainData, testData)

# Extracts only the measurements on the mean and standard deviation for each measurement. 
matchedFeatures <- featureNames[str_detect(featureNames, "mean|std")]
meanAndStdData <- fullData[, c('activity', as.character(matchedFeatures))]
#View(meanAndStdData)
write.table(meanAndStdData, file='meanAndStdData.txt')

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
matchedData <- fullData[, c('activity', 'subject', as.character(matchedFeatures))]
splitData <- split(matchedData[, matchedFeatures], matchedData[, c('activity', 'subject')])
meanData <- as.data.frame(t(sapply(splitData, colMeans, na.rm=T)))
groupNames <- t(sapply(row.names(meanData), str_split_fixed, pattern='\\.', n=2))
row.names(groupNames) <- c()
meanData <- cbind(activity=groupNames[,1], subject=groupNames[,2], meanData)
row.names(meanData) <- c()
# View(meanData)
write.table(meanData, file='meanData.txt')
