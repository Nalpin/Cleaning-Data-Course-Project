# Coursera Getting and Cleaning Data.
# Course Project

##set initial environment
basedir<-getwd()
require(data.table)

## Download dataset
download.data <- function(){
  url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  file <- 'dataset.zip'
  download(url,file)
  unzip(file)
}


## Helper function to load and processes dataset of train or test text files
load.dataset <- function(type, selected.features, activity.labels){
 
  # Load data files
  feature.vectors.data <- read.table(file.path(basedir,type,paste("X_",type,".txt",sep="")))[,selected.features$id]
  activity.labels.data <- read.table(file.path(basedir,type,paste("y_",type,".txt",sep="")))[,1]
  subject.ids.data <- read.table(file.path(basedir,type,paste("subject_",type,".txt",sep="")))[,1]
  
  # Name columns
  names(feature.vectors.data) <- selected.features$label
  feature.vectors.data$label <- factor(activity.labels.data, levels=activity.labels$id, labels=activity.labels$label)
  feature.vectors.data$subject <- factor(subject.ids.data)
  
  feature.vectors.data
}

## actual analysis
run.analysis <- function(){

  ###get feature dataset
  feature.vector.labels.data <- read.table('features.txt', col.names = c('id','label'))
  ### use regex to select only mean and standard deviation for each measurement.
  
  selected.features <- subset(feature.vector.labels.data, grepl('-(mean|std)\\(', feature.vector.labels.data$label))
  
  ### get activities
  activity.labels <- read.table('activity_labels.txt', col.names = c('id', 'label'))
  
  ### get train and test 
  
  train.df <- load.dataset('train', selected.features, activity.labels)
  
  test.df <- load.dataset('test', selected.features, activity.labels)
  
  ### Merge train and test datasets
  
  merged.df <- rbind(train.df, test.df)
  
  ### Convert to data.table
  
  merged.dt <- data.table(merged.df)
  
  ### Calculate the mean of each variable for each activity and each subject.
  tidy.dt <- merged.dt[, lapply(.SD, mean), by=list(label,subject)]
  
  ### set col names for cleaned dataset
  tidy.dt.names <- names(tidy.dt)
  tidy.dt.names <- gsub('-mean', 'Mean', tidy.dt.names)
  tidy.dt.names <- gsub('-std', 'Std', tidy.dt.names)
  tidy.dt.names <- gsub('[()-]', '', tidy.dt.names)
  tidy.dt.names <- gsub('BodyBody', 'Body', tidy.dt.names)
  setnames(tidy.dt, tidy.dt.names)
  
  # export dataset to computer
  write.csv(tidy.dt,
            file = 'cleanedData.csv',
            row.names = FALSE, quote = FALSE)
}
