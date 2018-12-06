## Peer-graded Assignment:<br> Getting and Cleaning Data Course Project


These are my files for the final assignment of the course 'Getting and Cleaning Data' of the Data Science Specialization.

The objective of the assignment is to create an R script that takes the data from the _Human Activity Recognition Using Smartphones Dataset - Version 1.0_  (link <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">here</a>) and: 
<ol>
<li>Merges the training and the test sets to create one data set.</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
<li>Uses descriptive activity names to name the activities in the data set</li>
<li>Appropriately labels the data set with descriptive variable names.</li>
<li>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.</li>
</ol>

This repo contains:
<ul>
<li>a script 'run_analysis.R' that processes the original data;</li>
<li>a codebook 'CodeBook.md' where the structure of the original and final datasets is explained, along with the all the transformation operations on the original data;</li>
<li>a folder 'output' where all the tidy data sets obtained from 'run_analysis.R' are stored. See 'CodeBook.md' for more information.</li>
</ul>


## Script 'run_analysis.R'

This script reads in the data from the _Human Activity Recognition Using Smartphones Dataset - Version 1.0_ dataset and proceeds to do all the steps required for the assigment and listed in the Introduction.

Apart from the base R, this script uses the following packages:

* dplyr
* data.table
* tidyr

The general flow of the script is as follows:

1. Checks whether a folder 'UCI HAR Dataset' exists in the working directory. If not, it unzips the .zip file provided <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">here</a> into the working directory. If necessary, it will download the .zip file from the link provided. Once the 'UCI HAR Dataset' folder is created, the user is queried whether the .zip should be deleted.</li>
2. Checks whether an 'output' folder exists in the working directory and if not, creates it.</li>
3. Reads and stores the names of the activities and features. Corrects the detected imprecisions in the names of the features. </li>
4. For each dataset reads the tables containing the information about the _subject_, _activity_ and _feature values_ for each observation and merges them into a single dataframe with 'tbl' format. From the list of features, only the mean values (labelled by mean()) and the standard deviation values (labelled by std()) are selected. 
5. Reshapes the previous dataframe so that the columns indicate, by order:</li>
    a. _activity_: the name of the activity
    b. _subject_: the id number of the subject
    c. _feature_: one of five base features (bodyacc, gravityacc, bodyaccjerk, bodygyro, bodygyrojerk)
    d. _type_: identifies whether the value of the base feature was obtained with regards to time (time) or frequency (freq)
    e. _direction_: identifies whether the value of the base feature corresponds to a axial direction (x, y, z) or to the magnitude (mag) 
    f. _measurement_: the id number of measurement by activity and subject
    g. _mean_: the mean value of the base feature
    h. _std_: the standard deviation value of the base feature
6. From the previous dataframe, a new tbl dataframe which contains the average values of the _mean_ and _std_ values of each feature grouped by _activity_, _subject_, _feature_, _type_ and _direction_. The _measurement_ value is collapsed onto the new column _measurements_ which contains the total number of measurements for the corresponding group.
7. The two dataframes are stored in .txt files in the 'output' folder. Additionally, the new list of base features, types, and directions are also stored in .txt files in the 'output' fodler.