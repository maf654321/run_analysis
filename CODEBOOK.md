# Getting and Cleaning Data
## Course Project - Code Book

[run_analysis.R](run_analysis.R) runs the following steps to make **"tidy_data_1.txt"** and **"tidy_data_2.txt"**:

- Looks for **"getdata-projectfiles-UCI HAR Dataset.zip"** in working directory
- Creates desired file list within **"getdata-projectfiles-UCI HAR Dataset.zip"**
- Reads and merges data sets from zip file
- Extracts mean and std of features
- Gives new labels to activities
- Gives new labels to subjects 
- Writes **"tidy_data_1.txt"** and caches tidy data set 1 to `dataset_1`
- - Contains 10299 lines of subject IDs, activity names, and 66 rows of attributes
- Uses dimensions of merged data sets to create data frame
- Fills data frame with subject name, activity, and means for each of the attributes
- - 30 subjects with 6 activities each with 66 attribute means per activity per subject
- Writes **"tidy_data_2.txt"** and caches tidy data set 2 to `dataset_2`