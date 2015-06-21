run_analysis <- function(export = TRUE, returned = 2, directory = ".", file = "getdata-projectfiles-UCI HAR Dataset.zip") {
# UCI HAR Dataset zip file must be in folder/subfolder of working directory
        
# Find zip file path
file <- list.files(path = directory, pattern = file, full.names = TRUE, recursive = TRUE)[1]

# Returns error if "getdata-projectfiles-UCI HAR Dataset.zip" not found
if (anyNA(file)) {
        stop("UCI HAR Dataset not found")
}

# Create file list
file_list <- unzip(file, list = TRUE)[c(31, 17, 30, 16, 32, 18, 2, 1), 1]

# print(file_list)
# [1] "UCI HAR Dataset/train/X_train.txt"       "UCI HAR Dataset/test/X_test.txt"         "UCI HAR Dataset/train/subject_train.txt"
# [4] "UCI HAR Dataset/test/subject_test.txt"   "UCI HAR Dataset/train/y_train.txt"       "UCI HAR Dataset/test/y_test.txt"        
# [7] "UCI HAR Dataset/features.txt"            "UCI HAR Dataset/activity_labels.txt"    

# Merge data sets
x.train <- read.table(unz(file, file_list[1]))
x.test <- read.table(unz(file,file_list[2]))
x.dat <- rbind(x.train, x.test)

subject.train <- read.table(unz(file, file_list[3]))
subject.test <- read.table(unz(file, file_list[4]))
subject.dat <- rbind(subject.train, subject.test)

y.train <- read.table(unz(file, file_list[5]))
y.test <- read.table(unz(file, file_list[6]))
y.dat <- rbind(y.train, y.test)

# Extract mean and std of features
feat.dat <- read.table(unz(file, file_list[7]))
feat.index <- grep("-mean\\(\\)|-std\\(\\)", feat.dat[, 2])
x.dat <- x.dat[, feat.index]
names(x.dat) <- tolower(gsub("\\(|\\)", "", feat.dat[feat.index, 2]))

# Give new names to activities
act.dat <- read.table(unz(file, file_list[8]))
act.dat[, 2] <- gsub("_", "", tolower(as.character(act.dat[, 2])))
y.dat[, 1] <- act.dat[y.dat[, 1], 2]
names(y.dat) <- "activity"

# Give new names to subjects
names(subject.dat) <- "subject"
dat.1 <- cbind(subject.dat, y.dat, x.dat)

# Write & cache tidy data set 1 if export = TRUE, else return if returned = 1
if (any(export)) {
        write.table(dat.1, "tidy_data_1.txt", row.name = FALSE)
        dataset_1 <<- dat.1
} else if (identical(as.numeric(returned)[1], 1)) {
        result <- dat.1
        return(result)
}

# Build tidy data set 2
dat.2 <- as.data.frame(matrix(NA, nrow = (length(table(subject.dat) * dim(act.dat)[1])), ncol = dim(dat.1)[2]))
colnames(dat.2) <- colnames(dat.1)
k <- 1

for (i in seq_along(1:length(table(subject.dat)))) {
        for (j in seq_along(1:dim(act.dat)[1])) {
                dat.2[k, 1] <- sort(unique(subject.dat)[, 1])[i]
                dat.2[k, 2] <- act.dat[j, 2]
                l <- i == dat.1$subject
                m <- act.dat[j, 2] == dat.1$activity
                dat.2[k, 3:dim(dat.1)[2]] <- colMeans(dat.1[l & m, 3:dim(dat.1)[2]])
                k <- k + 1
        }
}

# Write & cache tidy data set 2 if export = TRUE, else return if returned = 2
if (any(export)) {
        write.table(dat.2, "tidy_data_2.txt", row.name = FALSE)
        dataset_2 <<- dat.2
        result <- TRUE
        return(result)
} else if (identical(as.numeric(returned)[1], 2)) {
        result <- dat.2
        return(result)
}
}
