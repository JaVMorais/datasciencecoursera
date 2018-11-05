#
#   Week 2 of the course "R programming"
#
#   Exercise 3
#
corr <- function(directory = "specdata", threshold = 0){
    
    # Check if directory exists
    if(!dir.exists(directory)){
        print(paste("Error: Directory",directory,"does not exist. Goodbye."))
        return(-1)
    }
    # Check if threshold is larger than 0. Give a warning if not.
    else if(threshold<0){
        print("Warning: Threshold smaller than 0.")
    }
    
    # Create list_data to store values and set name of columns
    list_data <- vector(mode="numeric",length=0)
    
    # Go through elements of id vector, 1 by 1, to calculate the number of complete cases.
    list_files = list.files(directory)
    for(name in list_files){
        
        # Read csv file and store in temp_data.
        temp_data <- subset(read.csv(paste(directory,name, sep = "/")), select = c("nitrate","sulfate"))
        
        # Of the data read, keep only the complete cases and the columns corresponding to the nitrate and sulfate values.
        temp_data <- temp_data[complete.cases(temp_data),]
        
        # Calculate the correlation of the given values if the number of complete values is larger than threshold
        if(dim(temp_data)[1] > threshold){
            list_data <- c(list_data,cor(temp_data[,1],temp_data[,2]))
        }
    }
    
    
    # Return list_data
    return(list_data)
}