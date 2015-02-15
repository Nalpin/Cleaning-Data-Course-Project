# Cleaning-Data-Course-Project
##run_analysis.R

###This script assumes that the file is downloaded to the designated folder, the same one that the script would be run from. 

### Steps of data processing/cleaning
1) load the feature dataset
2) use regex to select features that contains mean and standard deviation
3) get the test and train activities datasets and merge them.
4) use lapply to calculate the mean of each entry
5) export dataset
