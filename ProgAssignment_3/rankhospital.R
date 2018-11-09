## Write a function called rankhospital that takes three arguments: the 2-character abbreviated name
## of a state (state), an outcome (outcome), and the ranking of a hospital in that state for that
## outcome (num). The function reads the outcome-of-care-measures.csv file and returns a character
## vector with the name of the hospital that has the ranking specified by the num argument. 
## For example, the call rankhospital("MD", "heart failure", 5) would return a character vector 
## containing the name of the hospital with the 5th lowest 30-day death rate for heart failure. 

## The num argument can take values \best", \worst", or an integer indicating the ranking
## (smaller numbers are better). 
## If the number given by num is larger than the number of hospitals in that state, then the 
## function should return NA. Hospitals that do not have data on a particular outcome should be 
## excluded from the set of hospitals when deciding the rankings.

## Handling ties. It may occur that multiple hospitals have the same 30-day mortality rate for a
## given cause of death. In those cases ties should be broken by using the hospital name. For 
## example, in Texas (\TX"), the hospitals with lowest 30-day mortality rate for heart failure are 
## shown here.

## The function should check the validity of its arguments. If an invalid state value is passed to 
## rankhospital, the function should throw an error via the stop function with the exact message 
## \invalid state". If an invalid outcome value is passed to rankhospital, the function should throw
## an error via the stop function with the exact message \invalid outcome".

rankhospital <- function(state, outcome, num = "best") {
    
    # Internal function to check if an object is an integer number (not if a variable is an atomic integer)
    # Functions checks that:
    # 1) object has length 1
    # 2) object is a number
    # 3) object is an integer number
    check_if_int <- function(number){
        if(length(number)==1 & is.numeric(number) & number== round(number)) TRUE
        else FALSE
    }
    
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
    
    # For the column number corresponding to 'outcome' do:
    # 1) Set values of the column to numeric, suppressing the warning message, to better identify NA values
    data_oocm[,col_num] <- suppressWarnings(as.numeric(data_oocm[,col_num])) 
    # 2) Re-order 'data_oocm' by increasing order of 'outcome' mortality rate. 
    # NA values excluded by setting na.last = NA within order()
    data_oocm <- data_oocm[with(data_oocm, 
                                order(data_oocm[,col_num],
                                      data_oocm$Hospital.Name, 
                                      na.last = NA)),]
    
    
    
    ## Return hospital name in that state with the given rank
    ## 30-day death rate
    
    # Check if num == 'best', 'worst' or if it is an integer between 1 and #Hospitals
    # If not, return NA
    if(isTRUE(num == 'best')){
        return(data_oocm$Hospital.Name[[1]])
    }
    else if(isTRUE(num =='worst')){
        return(data_oocm$Hospital.Name[[length(data_oocm$Hospital.Name)]])
    }
    else if(isTRUE(check_if_int(num)
                   & 1 <= num 
                   & num  <= length(data_oocm$Hospital.Name)
                )
            ){
        return(data_oocm$Hospital.Name[[num]])
    }
    else{
        return(NA)
    }
}