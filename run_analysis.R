# Download and unzip data if it does not already exist in the working directory
data.dir <- "UCI HAR Dataset"
zip.file <- "getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(data.dir)) {
  message(data.dir, " not found. checking for zip...")
  if (!file.exists(zip.file)) {
    message(zip.file, " not found. downloading...")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", zip.file, method = "curl")
  }
  message("unzipping...")
  unzip(zipfile)
}

# Get feature names from features.txt file
raw.names <- read.table(file.path(data.dir, "features.txt"), sep = " ")[,2]
# Convert feature names to better names (replace non-alphanumeric chars with ".")
feature.names <- gsub("\\.$","", gsub("[^A-Za-z0-9]+", ".", raw.names))

# one function for reading either test or training data
read.data.in.dir <- function(dir, xfile, yfile, subjectfile) {
  # read features file
  xs <- read.table(file.path(data.dir, dir, xfile), col.names = feature.names)
  # read activities file
  ys <- read.table(file.path(data.dir, dir, yfile), col.names = "activity.num")
  # read subjects file
  subjects <- read.table(file.path(data.dir, dir, subjectfile), col.names = "subject.num")
  # cbind all of the above datasets together
  cbind(xs, ys, subjects)
}

# read both test and training data, and rbind together
all.raw.data <- rbind(
  read.data.in.dir("test",  "X_test.txt",  "y_test.txt",  "subject_test.txt"),
  read.data.in.dir("train", "X_train.txt", "y_train.txt", "subject_train.txt")
)

# read activity labels dataset
activity.labels <- read.table(file.path(data.dir, "activity_labels.txt"), col.names = c("num", "name"))

# add activity name to main data
all.raw.data$activity <- activity.labels[all.raw.data$activity.num, "name"]

# which columns to keep - just activity, subject.num, means and stddevs
keep.column <- function(colnames) {
  colnames == "activity" |
    colnames == "subject.num" |
    grepl("[Mm]ean(\\.[XYZ])?$", colnames) |
    grepl("std(\\.[XYZ])?$", colnames)
}
# keep only the above columns
final.data <- all.raw.data[,keep.column(names(all.raw.data))]

# smaller dataset for output: mean of each column, grouped by activity and subject
means <- aggregate(final.data[,c(-73,-74)], # omit last two cols; group on those
                   by=list(subject.num = final.data$subject.num, activity = final.data$activity), # group by subject and activity
                   mean) # mean of each group

# write out data to two files
write.table(final.data, file = "activity_data_full.csv", sep = ",", col.names = TRUE)
write.table(means, file = "activity_data_means.txt", sep = ",", col.names = FALSE)
