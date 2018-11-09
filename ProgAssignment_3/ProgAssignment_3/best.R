## Write a function called best that take two arguments: the 2-character abbreviated name of a state 
## and an outcome name. The function reads the outcome-of-care-measures.csv file and returns a 
## character vector with the name of the hospital that has the best (i.e. lowest) 30-day mortality
## for the specified outcome in that state. The hospital name is the name provided in the 
## Hospital.Name variable. The outcomes can ## be one of \heart attack", \heart failure", or 
## \pneumonia". Hospitals that do not have data on a particular outcome should be excluded from the 
## set of hospitals when deciding the rankings.

## Handling ties. If there is a tie for the best hospital for a given outcome, then the hospital
## names should be sorted in alphabetical order and the first hospital in that set should be chosen
## (i.e. if hospitals \b", \c", and \f" are tied for best, then hospital \b" should be returned).

## The function should check the validity of its arguments. If an invalid state value is passed to
## best, the function should throw an error via the stop function with the exact message \invalid 
## state". If an invalid outcome value is passed to best, the function should throw an error via 
## the stop function with the exact message \invalid outcome".

best <- function(state, outcome) {
    
    ## Read outcome data
    
    # Variable 'data_oocm' stores the values read from the file "outcome-of-care-measures.csv"
    data_oocm <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    

    ## Check that 'state' and 'outcome' are valid
    
    # List with the 2-character abbreviated names of states. 
    list_states <- unique(data_oocm$State)
    
    # Check if 'state' is in the list of states. If not, stop and return error message "invalid state"
    if(!any(state == list_states)){
        stop("invalid state")
    }
    # If 'state' is a valid identifier, keep only the data from that State
    else{
        data_oocm <- subset(data_oocm, subset = data_oocm$State == state)
    }
    
    # List with valid outcomes and value of respective column in database
    list_outcomes <- c(11,17,23)
    names(list_outcomes) <- c("heart attack", "heart failure", "pneumonia")
    
    
    # Check if 'outcome' is in the list of outcomes. If not, stop and return error message "invalid outcome"
    if(!any(outcome == names(list_outcomes))){
        stop("invalid outcome")
    }
    # If 'outcome' is valid, store number of column in new variable (to make code more readable)
    else{
        col_num = list_outcomes[[outcome]]
    }
    
    # For the column number stored corresponding to 'outcome' (number stored in list_outcomes) do:
    # 1) Set values of the column to numeric, suppressing the warning message
    data_oocm[,col_num] <- suppressWarnings(as.numeric(data_oocm[,col_num])) 
    # 2) Re-order 'data_oocm' by increasing order of 'outcome' mortality rate. 
    # NA values excluded by setting na.last = NA within order()
    data_oocm <- data_oocm[with(data_oocm, 
                                order(data_oocm[,col_num],
                                      data_oocm$Hospital.Name, 
                                      na.last = NA)),]
    
    
    ## Return hospital name in that state with lowest 30-day death
    ## rate
    return(data_oocm$Hospital.Name[[1]])
    
    
    ## rate
}