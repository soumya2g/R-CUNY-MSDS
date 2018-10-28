
##############################################################################################################
#  Author:  Soumya Ghosh
#  Purpose: This R Code is written like an Interface program which will receive the API URL and the API Key.
#           The JSON response received by the API Call will be flattened and transformed into an R data frame.  
#  Note:    New York Time API Development site has been used as an example here. But this interface program 
#           is generic and can be used for any API based Web data source with a JSON response. 
#
#  Assignment: CUNY DATA 607 Week9 Assignment
###############################################################################################################

library(rvest)
library(httr)
library(jsonlite)
library(data.table)

#url <- "https://api.nytimes.com/svc/mostpopular/v2/mostemailed//.json" 

#url <- "https://api.nytimes.com/svc/mostpopular/v2/mostemailed/all-sections/1.json"

#url <- "https://api.nytimes.com/svc/semantic/v2/geocodes/query.json";

#url <- "https://api.nytimes.com/svc/mostpopular/v2/mostmailed/Arts/1.json"

#API_Key = "31b8d9353fbb4fbdb9c1d4d9c32dd991"


### OMDB Test ##

url = "http://www.omdbapi.com/"

API_Key = "e0564296"

GetAPIResponse <- function(API_URL,API_Key)
{
  
  apiResponse <- GET(API_URL, add_headers('api-key' = API_Key))

#apiResonse <- GET(url, add_headers('api-key' = "31b8d9353fbb4fbdb9c1d4d9c32dd991"))

  responseContent <- content(apiResponse,"text")

  raw_df <- as.data.frame(fromJSON(responseContent, simplifyDataFrame = T, flatten = T), stringsAsFactors = FALSE)


  str(raw_df)

# One way you can "flatten" this is to "fix" the list columns. There are three fixes - 
# 
# 1. flatten (from "jsonlite") will take care of columns like the "person" column.
# 2. Columns like the "facility" column can be fixed using toString, which would convert each element to a 
#    comma separated item or which can be converted into multiple columns.
# 3. Columns where there are data.frames, some with multiple rows, first need to be flattened into a single row 
#    (by transforming to a "wide" format) and then need to be bound together as a single data.table. 
#   (I'm using "data.table" for reshaping and for binding the rows together).
#                                                                                                                                                                                                            
  columnFixer <- function(x, vec2col = FALSE)
  {
    if (!is.list(x[[1]])) {
      if (isTRUE(vec2col)) {
        as.data.table(data.table::transpose(x))
      } else {
        vapply(x, toString, character(1L))
      }
    } else {
      temp <- rbindlist(x, use.names = TRUE, fill = TRUE, idcol = TRUE)
      temp[, .time := sequence(.N), by = .id]
      value_vars <- setdiff(names(temp), c(".id", ".time"))
      dcast(temp, .id ~ .time, value.var = value_vars)[, .id := NULL]
    }
  }

#  We can take care of the second and third points with a function like the following:
  
  Flattener <- function(input_df, vec2col = FALSE) {
    input_df <- flatten(input_df)
    listColumns <- sapply(input_df, is.list)
    newCols <- do.call(cbind, lapply(input_df[listColumns], columnFixer, vec2col))
    input_df[listColumns] <- list(NULL)
    cbind(input_df, newCols)
  }


  
  ### 1st Flattenr() Function Call ###
  
  final_df <- Flattener(raw_df,vec2col = FALSE)
  
  ### Check if there is any other nested List or Data Frame columns ####
  
  listColumnsVec <- sapply(final_df, is.list)
  
  ### Recursively call the Flattenr() function until the resultset is completely flattened ###
  
  while(!is.na(table(listColumnsVec)["TRUE"]))
  {
    final_df <- Flattener(final_df,vec2col = FALSE)
    listColumnsVec <- sapply(final_df, is.list)
  }
  
  return(final_df)

####################################################################################################################

}

responseDF <- GetAPIResponse (url,API_Key)

print(responseDF)
