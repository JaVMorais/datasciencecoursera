#
#   Week 2 of the course "R programming"
#
#   Exercise 1
#

pollutantmean <- function(directory = "specdata", pollutant="nitrate", id = NULL){
    
    # Check if directory exists
    if(!dir.exists(directory)){
        print(paste("Error: Directory",directory,"does not exist. Goodbye."))
        return(-1)
    }
    # Check if correct pollutant name is provided. Return -1 if not.
    else if(!any(pollutant == c("nitrate","sulfate"))){
        print(paste("Error: Name of pollutant",pollutant,"is neither \"nitrate\" nor \"sulfate\". Goodbye."),quote = FALSE)
    }
    # Check if "id" vector is provided. Return -1 if not.
    else if(is.null(id)){
        print("Error: No list of ID numbers provided. Goodbye.")
        return(-1)
    }
    
    else{
        
        # Create list_data to store values and set name of columns
        list_data <- data.frame(matrix(NA, nrow = 0, ncol = 1))
        colnames(list_data) <- "Date"
        list_names <- colnames(list_data)
        
        # Go through elements of id vector, 1 by 1, to add the data in the files to list_data.
        for(i in 1:length(id)){
            
            # Read csv file and store in temp_data.
            temp_data <- read.csv(paste(directory,paste(sprintf("%03d", id[[i]]),"csv", sep = "."), sep = "/"))
            
            # Of the data read, store only the dates and the values for the wanted pollutant.
            temp_data <- subset(temp_data,select = c("Date",pollutant))
            
            # Merge data from csv file to list_data by "Date" and putting NA in undefined values
            list_data <- merge(list_data,temp_data, by = "Date", all = TRUE)
            
            # Update list of names, adding the number of the detector as name for the new collumn
            list_names <- append(list_names,sprintf("%03d", id[[i]]))
            colnames(list_data) <- list_names
            
        }
        
        # Extract non NA values from list_data.
        list_data_values <- list_data[2:length(list_names)]
        
        # Return mean of non NA values.
        return(mean( list_data_values[!is.na( list_data_values)]))
    }
}
