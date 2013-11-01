# Data loading
# Experiment:  Classification
# Mark E. Madsen
# (c) 2013 - see file LICENSE for license terms

if(!exists("class.grouped")) {
  
  if(file.exists("data/classification-grouped.rda")) {
    load("data/classification-grouped.rda")  
  } else {
    class.grouped <- read.csv("data/classification-experiment-neutral-dataset-grouped.csv", 
                              row.names=NULL,
                              header=TRUE,
                              colClasses=c(
                                "factor","character","factor","integer","integer",
                                "numeric","factor","factor","integer",
                                "numeric","numeric","numeric","numeric","numeric",
                                "numeric","numeric","numeric","numeric","numeric",
                                "numeric","numeric","numeric","numeric","numeric",
                                "numeric","numeric","numeric"
                              )) 
  }	
}

if(!exists("class.full")) {
  
  if(file.exists("data/classification-full.rda")) {
    load("data/classification-full.rda") 
  } else {
    class.full <- read.csv("data/classification-experiment-neutral-dataset-fullrows.csv", 
                           row.names=NULL, 
                           header=TRUE,
                           colClasses = c(
                             "factor","factor","factor","factor",
                             "integer","factor","integer","integer","numeric",
                             "character","numeric","numeric","numeric",
                             "numeric","numeric",
                             "numeric","numeric","numeric",
                             "numeric"
                           ))	  
  }
}


