# Getting and Cleaning Data Course Project - Codebook

This is the codebook for the final project of the Getting and Cleaning Data course of the Data Science specialization in Coursera.
The codebook is divided into three main sections: _Original Data_, _Final Data_, and _Processing the data_.

## Original Data

### Data recording and pre-processing

According to the original source [1], the experiment that led to the _Human Activity Recognition Using Smartphones Dataset - Version 1.0_  was carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each volunteer performed six activities:
<ol>
<li>WALKING</li>
<li>WALKING_UPSTAIRS</li>
<li>WALKING_DOWNSTAIRS</li>
<li>SITTING</li>
<li>STANDING</li>
<li>LAYING</li>
</ol>
wearing a smartphone (Samsung Galaxy S II) on the waist. The 3-axial linear acceleration and angular velocity were recorded at a constant rate of 50Hz using the smartphone's embedded accelerometer and gyroscope. The data was then divided randomly in two datasets, _train_ and _test_, which contained 70% and 30% of the data, respectively.

The data recorded from the accelerometers and gyroscopes was pre-processed using noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The acceleration signal was separated into its gravitational and body motion components using a Butterworth low-pass filter. Assuming that the gravitational force only has low frequency components, a filter with 0.3 Hz cutoff frequency was used. 

After the pre-processing, total and estimated body accelerations where then stored in the files 'total\_acc\_[X/Y/Z]\_[train/test].txt' and 'body\_acc\_[X/Y/Z]\_[train/test].txt', while the angular velocity from the gyroscope was stored in the files 'body\_gyro\_[X/Y/Z]\_[train/test].txt', where each row has 128 elements corresponding to the 128 readings/window.

__Note__ 

Unfortunately, there is no information on the correspondence between each of the 7000+ rows and the respective activity and subject, making these files unusable without further investigation.

### Post pre-processing dataset

For each window, a vector of features was obtained by calculating variables from the time and frequency domain:
<ol>
<li>tBodyAcc-[X/Y/Z]</li>
<li>tGravityAcc-[X/Y/Z]</li>
<li>tBodyAccJerk-[X/Y/Z]</li>
<li>tBodyGyro-[X/Y/Z]</li>
<li>tBodyGyroJerk-[X/Y/Z]</li>
<li>tBodyAccMag</li>
<li>tGravityAccMag</li>
<li>tBodyAccJerkMag</li>
<li>tBodyGyroMag</li>
<li>tBodyGyroJerkMag</li>
<li>fBodyAcc-[X/Y/Z]</li>
<li>fBodyAccJerk-[X/Y/Z]</li>
<li>fBodyGyro-[X/Y/Z]</li>
<li>fBodyAccMag</li>
<li>fBodyAccJerkMag</li>
<li>fBodyGyroMag</li>
<li>fBodyGyroJerkMag</li>
</ol>
where [X/Y/Z] indicates the spatial direction and 'Mag' indicates the Euclidean magnitude. The jerk and angular acceleration were computed using the formulas *j* = d*a*/d*t* and α =  dω/d*t*, respectively. 

For each of these 33 features (24 \* '[X/Y/Z]' + 9 \*'Mag'), a set of measures was calculated
<ol>
<li>mean(): Mean value</li>
<li>std(): Standard deviation</li>
<li>mad(): Median absolute deviation </li>
<li>max(): Largest value in array</li>
<li>min(): Smallest value in array</li>
<li>sma(): Signal magnitude area</li>
<li>energy(): Energy measure. Sum of the squares divided by the number of values. </li>
<li>iqr(): Interquartile range </li>
<li>entropy(): Signal entropy</li>
<li>arCoeff(): Autorregresion coefficients with Burg order equal to 4</li>
<li>correlation(): correlation coefficient between two signals</li>
<li>maxInds(): index of the frequency component with largest magnitude</li>
<li>meanFreq(): Weighted average of the frequency components to obtain a mean frequency</li>
<li>skewness(): skewness of the frequency domain signal </li>
<li>kurtosis(): kurtosis of the frequency domain signal </li>
<li>bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.</li>
</ol>
In addition, the following vectors were obtained by averaging the signals in a signal window sample:
<ol>
<li>gravityMean </li>
<li>tBodyAccMean </li>
<li>tBodyAccJerkMean </li>
<li>tBodyGyroMean </li>
<li>tBodyGyroJerkMean </li>
</ol>
The angle between them were then computed using the angle() function.

In total, a list of 561 final features is provided in the file 'features.txt'. The values of these features is stored in the columns of the files 'train/X_train.txt' and 'test/X_test.txt', where each rows corresponds to a different observation. The corresponding subject and activity are stored in the files 'train/subject_train.txt'|'test/subject_test.txt' and 'train/y_train.txt'|'test/y_test.txt', respectivel.

__Original notes__

* Features are normalized and bounded within [-1,1].
* Each feature vector is a row on the text file.
* The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
* The gyroscope units are rad/seg.
*A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: http://www.youtube.com/watch?v=XOEN9W05_4A

__Further notes__

Some imprecisions were detected in the feature names presented in the file 'features.txt':
<ul>
<li>In the rows 516-554, the label 'Body' appears duplicated.  </il>
<li>In the row 555, the label 'Mean' is ommited in the variable 'gravityMean'. </li>
</ul>
In addition, the process of normalization in the pre-processing is not clear. This is particularly confusing due to the existence of negative values for the standard deviation of several features and for the mean value of 'Mag' features. 


### Files

The complete dataset of the experiment is contained in the folder 'UCI HAR Dataset' which can be downloaded from the link provided <a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">here</a>. Inside that folder, the following files can be found:
<ul>
<li>'README.txt'</li>
<li>'features_info.txt': Shows information about the variables used on the feature vector.</li>
<li>'features.txt': List of all features.</li>
<li>'activity_labels.txt': Links the class labels with their activity name.</li>
<li>'train/X_train.txt': Training set.</li>
<li>'train/y_train.txt': Training labels.</li>
<li>'test/X_test.txt': Test set.</li>
<li>'test/y_test.txt': Test labels.</li>
</ul>
The following files are also available for the train and test data. Their descriptions are equivalent. 
<ul>
<li>'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.</li> 
<li>'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. </li>
<li>'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. </li>
<li>'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. </li>
</ul>

## Final Data

### Structure

The idea behind the structure of the final data is to break down the initial list of 66 features corresponding to mean() or std() values by _basefeature_, _type_, _direction_ and function (_mean_ or _std_). This separates all the information in the initial feature names in different columns, making it easier to query the data.

The downside of this approach is that the extra factor sensibly double the amount of memory required to store the dataframes.

After the script 'run_analysis.R' is run, two dataframes are created, _total\_data_ and _average\_data_, each with 8 columns of values:

* _activity_ <_fct_>: the name of the activity (walking, walking\_upstairs, walking\_downstairs, sitting, standing, laying)
* _subject_ <_fct_>: the id number of the subject
* _basefeature_ <_fct_>: one of five base features (bodyacc, gravityacc, bodyaccjerk, bodygyro, bodygyrojerk)
* _type_ <_fct_>: identifies whether the value of the base feature was obtained with regards to time (time) or frequency (freq)
* _direction_ <_fct_>: identifies whether the value of the base feature corresponds to a axial direction (x, y, z) or to the magnitude (mag) 
* _measurement/measurements_ <_int_>: the id number of the measurement/the total number of measurements by activity and subject
* _mean_/_average\_mean_ <_dbl_>: the mean value/average mean value of the base feature + type + direction
* _std_/_average\std_ <_dbl_>: the standard deviation/average standard deviation of the base feature + type + direction

The five base features are:

* bodyacc: the body motion acceleration.
* gravityacc: the gravitational acceleration.
* bodyaccjerk: the body motion jerk.
* bodygyro: the body motion angular velocity.
* bodygyrojerk: the body motion angular acceleration. \
The initial nomenclature 'jerk' is maintained, despite the fact that this is in fact an acceleration, in order to facilitate comparison with the original features.

In the variables _mean_/_average\_mean_ and _std_/_average\_std_, the original normalization of the features is maintained, including the negative values of standard deviations and of mean values for _direction_='mag' (see *Further notes* in *Original Data/Post pre-processing dataset*).


### Files

The folder 'output' contains all the files generated by the script 'run_analysis.R':

* 'tidydata_total.txt': the contents of the dataframe _total\_data_. \
Each row corresponds to a different measurement of base feature + type + direction by subject and activity.
* 'tidydata_average.txt': the contents of the dataframe average\_data_. \
Each row corresponds to the average of all measurements of base feature + type + direction by subject and activity.
* 'activities.txt': the list of activities by order of factor. 
* 'basefeatures.txt': the list of base features by order of factor.
* 'types.txt': the list of types by order of factor.
* 'directions.txt': the list of directions by order of factor.

## Processing the data

Below is a detailed description of the various transformations applied to the original data.

### Activity names

* The list of activity names is read from the 'activity_labels.txt' in the 'UCI HAR Dataset' folder and stored in the variable as 'activity_names', which is treated as a list of factors whose order respects the one in 'activity_labels.txt'.
* The names of the activities are set to lower case, in accordance with the rest of the variables.
* When adding the activity label from the files 'train/y_train.txt' and 'test/y_test.txt', the numeric label is replaced by the corresponding value of levels(activity_names).
* The list of activity names in the final data is stored in the file 'activities.txt' in the folder 'output'.

### Subject ID number

* The subjects are numbered from 1 to 30 and divided between the train (70%) and test (30%) sets.
* The subject label corresponding to each measurement is read from the files 'train/subject_train.txt' and 'test/subject_test.txt' and is converted to a factor variable with levels 1:30.

### Measurement ID number

* After all the data from the 'train' and 'test' sets is read and gathered in one single data frame, a new label _measurement_ is added that identifies the number of the measurement by subject and activity. 
* This ID allows to match the corresponding _mean_ and _std_ values on the final dataframes. 

### Features

* The list of feature names is read from the 'features.txt' in the 'UCI HAR Dataset' folder and stored in the variable as 'feature_names', which is treated as a list of factors whose order respects the one in 'features.txt'.
* The imprecision 'BodyBody' in the name of some of the variables is corrected to 'Body', the characters "-" are eliminated and the names are set to lowercase.
* Since only the features corresponding to mean values and standard deviations are required, the condition grep("mean\\(\\)|std\\(\\)",feature_names,value = TRUE) is used to select only the corresponding columns when reading the data files 'train/X_train.txt' and 'test/X_test.txt'.
* After all the data from the 'train' and 'test' sets is read and gathered in one single dataframe, _total\_data_, and the measurement number ID is added, all the feature columns are gathered into two columns with the name of the feature (_observation_) and the corresponding value (_value_). 
* At this point the different types of information (_basefeature_, _type_, _direction_ and function) in the feature name are identified and separated by underscores, e.g.:
    * tbodyaccmean()x -> time\_bodyacc\_mean\_x
    * fbodygyrojerkmagstd() -> freq\_bodygyrojerk\_std\_mag\
The column _observation_ is then separated into four different columns: _type_, _basefeature_, _function_ and _direction_.
* The columns _type_, _basefeature_ and _direction_ are set to factor variables. The column _function_ is used to spread the column _value_ into two columns _mean_ and _std_.
* After reordering the columns, the result is stored in the dataframe _total\_data_.
* The dataframe _average\_data_ with the average values of _mean_ and _std_ is created by grouping _total\_data_ by _activity_, _subject_, _basefeature_, _type_ and _direction_ and then summarizing the dataframe, replacing _measurement_, _mean_ and _std_ by:
    * _measurements_ = length(_measurement_)
    * _average\_mean_ = mean(_mean_)
    * _average\_std_ = mean(_std_)
* The total and average dataframes are saved in the files 'tidydata_total.txt' and 'tidydata_average' with '\t' separations and with column names in the first line.\
* Finally, the lists of base features, types and directions are stored in the respective .txt files in following format: 
    * The first column indicates the order of the factor levels
    * The second column indicates the names of the factor levels.
    
## References

[1] - D. Anguita, A. Ghio, L. Oneto, X. Parra and J. L. Reyes-Ortiz, _A Public Domain Dataset for Human Activity
Recognition Using Smartphones_, ESANN 2013 proceedings, European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning. Bruges (Belgium), 24-26 April 2013
