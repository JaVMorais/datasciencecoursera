library(dplyr)
library(data.table)

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
    
    message("Complete.")
}

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
    colClasses = c("factor","character")
)$V2


## List with labels of activities. First column with # of activities is not necessary.
activity_names <- read.table(
    paste(
        folder_name,
        grep("^activity",file_list, value = TRUE),
        sep = "/"
    ),
    header = FALSE,
    colClasses = c("factor","factor")
)$V2

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
        col.names = grep("mean|std",feature_names,value = TRUE),  # sets the names for the columns with mean or std
        select = grep("mean|std",feature_names),  # choses only the columns with mand or standard deviation values
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
            col.names = "activity",
            colClasses = c("factor")
        ) %>%
        mutate(
            activity = activity_names[activity] #  changes the variable activity from the number code to the respective name
        )
    
    ## Store all the data of the set in data_list
    data_list[[set_name]] <- cbind(set_activity,set_subjects,set_data)
    
    ## Free the temporary set data variables
    rm(set_subjects,set_activity,set_data)
}

## Free remaining temporary variables
rm(file_list,file_name,feature_names,activity_names,set_name)

## Define tbl data.frame with all the data in data_list with subject as a factor
total_data <- rbind(data_list[[1]], data_list[[2]]) %>%
    arrange(subject) %>%
    mutate(subject = as.factor(subject)) %>%  # subject coerced into a factor type
    tbl_df  # saves as a tbl
## Clean names of variables, according to the 'alllowercase' requested. 
## Not my favourite one (see https://www.r-bloggers.com/consistent-naming-conventions-in-r/).
names(total_data) <- names(total_data) %>% 
    gsub(pattern = "[\\.-]",replacement = "") %>%  # cleans '-' and '.'
    gsub(pattern = "[\\(\\)]",replacement = "") %>%  # cleans '(' and ')'
    tolower  # sets all letters to lowercase

## Free data_list as it is ni longer necessary
rm(data_list)

## Define tbl data.frame with the average values of all variables by activity and subject
average_data <- tbl_df(arrange(aggregate(total_data[,-(1:2)],total_data[,(1:2)],mean),activity))

## Check if folder for output exists and if not create it.
if(!dir.exists(paste(folder_name,"tidydata", sep = "/"))) dir.create(paste(folder_name,"tidydata", sep = "/"))

## Save file with 'total_data'
write.table(total_data, paste(folder_name,"tidydata","tidy_total.txt", sep = "/"), sep = " \t", quote = FALSE, row.names = FALSE, col.names = FALSE)

## Save file with 'average_data'
write.table(average_data, paste(folder_name,"tidydata","tidy_average.txt", sep = "/"), sep = " \t", quote = FALSE, row.names = FALSE, col.names = FALSE)

## Save file with column names
write.table(names(total_data), paste(folder_name,"tidydata","tidy_names.txt", sep = "/"), sep = "\n", quote = FALSE, row.names = FALSE, col.names = FALSE)