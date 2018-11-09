## Write a function called rankall that takes two arguments: an outcome name (outcome) and a 
## hospital ranking (num). The function reads the outcome-of-care-measures.csv file and returns a 
## 2-column data frame containing the hospital in each state that has the ranking specified in num. 

## For example the function call rankall("heart attack", "best") would return a data frame 
## containing the names of the hospitals that are the best in their respective states for 30-day 
## heart attack death rates. The function should return a value for every state (some may be NA). 

## The first column in the data frame is named hospital, which contains the hospital name, and the 
## second column is named state, which contains the 2-character abbreviation for the state name. 

## Hospitals that do not have data on a particular outcome should be excluded from the set of
## hospitals when deciding the rankings. 

## Handling ties. The rankall function should handle ties in the 30-day mortality rates in the same
## way that the rankhospital function handles ties.

## NOTE: For the purpose of this part of the assignment (and for efficiency), your function should 
## NOT call the rankhospital function from the previous section.

## The function should check the validity of its arguments. If an invalid outcome value is passed to
## rankall, the function should throw an error via the stop function with the exact message \invalid 
## outcome". The num variable can take values \best", \worst", or an integer indicating the ranking 
## (smaller numbers are better).

## If the number given by num is larger than the number of hospitals in that state, then the 
## function should return NA.

rankall <- function(outcome, num = "best") {
    
    # Internal function to check if an object is an integer number (not if a variable is an atomic integer)
    # Functions checks that:
    # 1) object has length 1
    # 2) object is a number
    # 3) object is an integer number
    check_if_int <- function(number){
        if(length(number)==1 & is.numeric(number) & number== round(number)) TRUE
        else FALSE
    }
    
    # Internal function based on rankhospital() to select the hospital ranked #num in a given state
    # To be used later in a tapply call
    rankindiv <- function(data_state, col_num_indiv, num = "best") {
        
        # For the column number 'col_num_indiv' do:
        # 1) Set values of the column to numeric, suppressing the warning message, to better identify NA values
        data_state[,col_num_indiv] <- suppressWarnings(as.numeric(data_state[,col_num_indiv])) 
        # 2) Re-order 'data_oocm' by increasing order of 'outcome' mortality rate. 
        # NA values excluded by setting na.last = NA within order()
        data_state <- data_state[with(data_state, 
                                    order(data_state[,col_num_indiv],
                                          data_state$Hospital.Name, 
                                          na.last = NA)),]
        
        # Check if num == 'best', 'worst' or if it is an integer between 1 and #Hospitals
        # If not, return NA
        if(isTRUE(num == 'best')){
            return(data_state$Hospital.Name[[1]])
        }
        else if(isTRUE(num =='worst')){
            return(data_state$Hospital.Name[[length(data_state$Hospital.Name)]])
        }
        else if(isTRUE(check_if_int(num)
                       & 1 <= num 
                       & num  <= length(data_state$Hospital.Name)
        )
        ){
            return(data_state$Hospital.Name[[num]])
        }
        else{
            return(NA)
        }
    }
    
    
    ## Read outcome data
    
    # Variable 'data_oocm' stores the values read from the file "outcome-of-care-measures.csv"
    data_oocm <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
    
    
    ## Check that state and outcome are valid
    
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
    
    ## For each state, find the hospital of the given rank
    
    # Split 'data_oocm' by State
    list_oocm <- split(data_oocm,data_oocm$State)
    
    # Apply previously defined 'rankindiv' function to each element of 'list_oocm' and define
    # dataframe with desired output.
    ranking_all <- data.frame(x  = sapply(list_oocm,rankindiv, col_num, num), y = names(list_oocm))
    # Define names of columns
    colnames(ranking_all) <- c("hospital","state")
    
    
    ## Return a data frame with the hospital names and the
    ## (abbreviated) state name
    
    return(ranking_all)
}