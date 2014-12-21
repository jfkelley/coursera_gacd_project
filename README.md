## README

The following is an explanation of the code provided to data acquisition and clean-up for the UCI Machine Learning Human Activity Recognition Using Smartphones Data Set.

The entirety of the code is contained in one script: run_analysis.R. Here is an explanation of the various steps in the script:

1. Acquire raw data set (lines 1-12). If the data set is not present in the current working directory, it is automatically downloaded (line 8) and unzipped (line 11).
2. Read and transform feature names (lines 14-17). The "features.txt" contains feature names that are pretty good, but they contain some strange formatting, so a simple regex-based transformation is performed to normalize them.
3. Read and combine datasets (lines 19-32)
   1. The "x values" file (line 22), "y values" file (line 24), and "subjects" file (line 26) are all read, and cbind is used to combine them into one table (line 28).
   2. This happens for both the test (line 33) and training (line 34) datasets, and then they are unioned with rbind (line 32).
4. Merge in activity names (lines 37-41). Activity numbers are not useful/readable, so the actual activity names are read and attached to the table
   1. Read the file containing the activity number-name mapping (line 38)
   2. Add an "activity" column to the table using that mapping (line 41)
5. Keep only some columns - activity, subject, mean, and stddev columns (lines 43-51)
   1. keep.column is a function that returns a boolean vector specifying whether a column name should be kept (lines 44-49)
   2. that function is applied to all columns in the table in order to actually do the filtering (line 51)
6. Generate a smaller data set containing one row per subject+activity, with the means of the other columns (lines 54-56)
7. Write out the full data set to "activity_data_full.csv" (line 59)
8. Write out the smaller data set (means) to "activity_data_means.txt" (line 60)