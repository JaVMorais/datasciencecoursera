## Script for the final assignment of the course 'Getting and Cleaning Data' of the Data Science Specialization.

library(dplyr)
library(data.table)
library(tidyr)

#-------------------------
#
#       Checking data and setting folder structure
#
#-------------------------

## Define folder 'UCI HAR Dataset' where data is stored
folder_name <- "UCI HAR Dataset"

## Check if folder 'UCI HAR Dataset' exists. 
if(!dir.exists(paste0("./",folder_name))){
    message(paste0("Cannot find folder \'",folder_name,"\'. Checking for data files..."))
    
    
    ## If not, check if 'UCI_HAR_dataset.zip' with data exists.
    if(!file.exists("UCI_HAR_dataset.zip")){
        message("Data files not detected. Downloading data...")
        
        ## If not, download data to file 'UCI_HAR_dataset.zip'.
        download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip", 
                      destfile = "UCI_HAR_dataset.zip")
    }
    else{
        message("Data files found.")
    }
    
    ## Unzip data from 'UCI_HAR_dataset.zip', selecting only the files within the folder 'UCI HAR dataset'.
    message("Unzipping data...")
    unzip( "UCI_HAR_dataset.zip", list = TRUE)$Name %>%
        grep(pattern = "^UCI", value = TRUE) %>%
        unzip(zipfile = "UCI_HAR_dataset.zip")
    
    removeswitch <- menu(c("Yes", "No"), title="Do you want this?")
    if(removeswitch==1) file.remove("UCI_HAR_dataset.zip")
    
    message("Complete.")
}

## Check if folder for output exists and if not create it.
if(!dir.exists("output")) dir.create("output")

#-------------------------
#
#       Reading data labels
#
#-------------------------

## List with name of all .txt files inside folder 'UCI HAR dataset'.
file_list <- list.files(folder_name, pattern = "*.txt", recursive = TRUE)

## List with name of features. First column with # of features is not necessary.
feature_names <- read.table(
    paste(
        folder_name,
        grep("^features\\.txt",file_list, value = TRUE),
        sep = "/"
    ),
    header = FALSE,
    colClasses = c("numeric","character")
)$V2 %>%
    gsub(pattern = "-", replacement = "") %>%  # removing "-" from the feature names
    sub(pattern = "BodyBody",replacement = "Body") %>%  # eliminating the repetition of 'Body' in some feature names
    tolower


## List with labels of activities. First column with # of activities is not necessary.
activity_names <- read.table(
    paste(
        folder_name,
        grep("^activity",file_list, value = TRUE),
        sep = "/"
    ),
    header = FALSE
)$V2 %>%
    tolower
activity_names <- factor(activity_names,activity_names)

#-------------------------
#
#       Reading data from training and test sets
#
#-------------------------

## Temporary empty list to hold data from the sets 'train' and 'test'.
data_list = list()

## For loop that loads the data from each set and stores it in 'data_list'.
for(set_name in c("train","test")){
    
    ## Set data of subjects 
    file_name <- paste0("subject_",set_name) %>% grep(file_list, value = TRUE)
    
    set_subjects <- read.table(
        paste(
            folder_name,
            file_name,
            sep = "/"
        ),
        header = FALSE,
        col.names = "subject",
        colClasses = "numeric"  # subject set momentarily to numeric. Later set to factor once all subjects are together
    )
    
    ## Set data of measures 
    file_name <- paste0("/X_",set_name) %>% grep(file_list, value = TRUE)
    
    ## Read data with fread due to the large size of the file.
    set_data <- fread(
        paste(
            folder_name,
            file_name,
            sep = "/"
        ), 
        header = FALSE,
        colClasses = rep("numeric",561),  # sets all columns to numeric
        col.names = grep("mean\\(\\)|std\\(\\)",feature_names,value = TRUE),  # sets the names for the columns with mean or std
        select = grep("mean\\(\\)|std\\(\\)",feature_names),  # choses only the columns with mand or standard deviation values
        data.table = FALSE  # sets output to data.frame instead of data.table
    )
    
    
    ## Set data of activities 
    file_name <- paste0("/y_",set_name) %>% grep(file_list, value = TRUE)
    
    set_activity <- paste(
        folder_name,
        file_name,
        sep = "/"
    ) %>%
        read.table(
            header = FALSE,
            col.names = "activity"
        ) %>%
        mutate(
            activity = activity_names[activity] #  changes the variable activity from the number code to the respective name
        )
    
    ## Store all the data of the set in data_list
    data_list[[set_name]] <- cbind(set_activity,set_subjects,set_data)
    
    ## Free the temporary set data variables
    rm(set_subjects,set_activity,set_data)
}

## Free obsolete temporary variables
rm(folder_name,file_list,file_name,set_name)

#-------------------------
#
#       Unifying datasets in total_data
#
#------------------------- 
    

## Define tbl data.frame with all the data in data_list with subject as a factor
total_data <- rbind(data_list[[1]], data_list[[2]])  %>% # saves as a tbl
    arrange(subject) %>%
    mutate(
        subject = factor(subject,1:30)
    ) %>% # subject coerced into a factor type
    tbl_df 

## Free data_list as it is no longer necessary
rm(data_list)

#-------------------------
#
#       Change structure of total_data
#
#------------------------- 

## List of names of base structures
basefeature_names <- feature_names[grep("mean\\(\\)|std\\(\\)",feature_names)] %>%
    sub(pattern = "mean\\(\\)|std\\(\\)", replacement = "") %>% 
    sub(pattern = "[xyz]$", replacement = "") %>%
    sub(pattern = "mag", replacement = "") %>%
    sub(pattern = "^t", replacement = "") %>%
    sub(pattern = "^f", replacement = "") %>%
    unique

## Free feature_names
rm(feature_names)

## Restructure total_data into final format
total_data <- total_data %>% 
    ## Add measurement ID number
    split(list(total_data$activity,total_data$subject)) %>%
    lapply(function(y){
        y$measurement <- seq.int(nrow(y))
        y
    }) %>%
    bind_rows() %>%
    ## Collapse features
    gather(
        key = observation, 
        value = value, 
        grep("[(mean)(std)]\\(\\)", names(total_data), value = TRUE)
    ) %>% 
    ## Separate information in feature name
    mutate(
        observation = observation %>% 
        sub(pattern = "mag", replacement = "") %>%
        sub(pattern = "(\\))$", replacement = "\\)mag") %>%
        sub(pattern = "^t", replacement = "time_") %>%
        sub(pattern = "^f", replacement = "freq_") %>%
        sub(pattern = "mean\\(\\)", replacement = "_mean_") %>%
        sub(pattern = "std\\(\\)", replacement = "_std_")
    ) %>%
    separate(
        col = observation,
        into = c("type","basefeature","function","direction"),
        sep = "_"
    ) %>%
    mutate(
        type = factor(type, c("time","freq")),
        feature = factor(basefeature,basefeature_names),
        direction = factor(direction,c("x","y","z","mag"))
    ) %>%
    ## Spread values by mean and std functions
    spread(
        key = "function",
        value = "value"
    ) 

## Reorder columns and rows in total_data
total_data <- total_data[c("activity","subject","basefeature","type","direction","measurement","mean","std")] %>% 
    arrange(subject,activity,basefeature,type,direction,measurement)


#-------------------------
#
#       Define average_data
#
#------------------------- 

## Define tbl data.frame with the average values of all variables by activity and subject
 average_data <- total_data %>% 
     group_by(activity,subject,basefeature,type,direction) %>% 
     summarize(
         measurements = length(measurement), 
         average_mean = mean(mean), 
         average_std = mean(std)
    )

#-------------------------
#
#       Save output
#
#------------------------- 

## Save file with 'total_data'
write.table(total_data, paste("output","tidydata_total.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = FALSE)

## Save file with 'average_data'
write.table(average_data, paste("output","tidydata_average.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = FALSE)

## Save file with activity names
write.table(activity_names, paste("output","activies.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = FALSE)
rm(activity_names)

## Save file with basefeature names
write.table(basefeature_names, paste("output","basefeatures.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = FALSE)
rm(basefeature_names)

## Save file with type names
write.table(levels(total_data$type), paste("output","types.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = FALSE)

## Save file with direction names
write.table(levels(total_data$direction), paste("output","directions.txt", sep = "/"), sep = "\t", quote = FALSE, row.names = TRUE, col.names = FALSE)