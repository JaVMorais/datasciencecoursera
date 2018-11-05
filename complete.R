#
#   Week 2 of the course "R programming"
#
#   Exercise 2
#

complete <- function(directory = "specdata", id = NULL){
    
    # Check if directory exists
    if(!dir.exists(directory)){
        print(paste("Error: Directory",directory,"does not exist. Goodbye."))
        return(-1)
    }
    # Check if "id" vector is provided. Return -1 if not.
    else if(is.null(id)){
        print("Error: No list of ID numbers provided. Goodbye.")
        return(-1)
    }
    
    else{
        
        # Create list_data to store values and set name of columns
        list_data <- data.frame(matrix(NA, nrow = 0, ncol = 2))
        colnames(list_data) <- c("File","Cases")
        list_names <- colnames(list_data)
        
        # Go through elements of id vector, 1 by 1, to calculate the number of complete cases.
        for(i in 1:length(id)){
            
            # Read csv file and store in temp_data.
            temp_data <- read.csv(paste(directory,paste(sprintf("%03d", id[[i]]),"csv", sep = "."), sep = "/"))
            
            # Of the data read, keep only the complete cases.
            temp_data <- temp_data[complete.cases(temp_data),]
            
            # Add a row to list_data with name of file and number of complete cases
            list_data <- rbind(list_data,list(as.integer(sprintf("%03d", id[[i]])),dim(temp_data)[1]))
            colnames(list_data) <- list_names
        }
        
        
        # Return list_data
        return(list_data)
    }
}