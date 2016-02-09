#QUESTIONS ABOUT THIS DOCUMENT:   matthias.bogaert@ugent.be     steven.hoornaert@ugent.be

##########################################################################################################
#4 DATES

#EXERCISE: Output the following sentence to the console: "The 6th of December of 1980 was a SATURDAY."

date <- as.Date("1980-12-6")
cat("The",format(date,'%e'),"th of ",format(date,'%B')," of ",format(date,'%Y')," was a ",toupper(format(date,'%A')),".",sep="")

##########################################################################################################
#5 WORKING WITH STRINGS

#EXERCISE: Make some code to select the title and year of the blog post
url <- "http://www.mma.ugent.be/predictive_analytics/customer_intelligence/Blog/Entries/2014/10/30_DMA_2014_Conference_in_San_Diego%2C_CA.html"

split1 <- unlist(strsplit(url,split="/"))

(year <- split1[8])
(title <- unlist(strsplit(split1[10],split=".html")))

##########################################################################################################
#6 FUNCTIONS

#EXERCISE: Make a function that returns the minimum, maximum, mean and range (i.e. difference between maximum and minimum of a variable) of a variable in a data.frame and call this function 'MyRange'
#Test your function on the 'NbrNewspapers'-variable of the subscriptions table

MyRange <- function(var) {
  return(list(min=min(var),max=max(var),mean=mean(var),range=max(var)-min(var)))
}

MyRange(subscriptions$NbrNewspapers)

##########################################################################################################
#8 LOOPS

#EXERCISE: 
#Use apply to return the product of Sepal.Length and Sepal.Width of the iris dataset for each row
apply(iris[,c("Sepal.Length","Sepal.Width")],1,prod)

#EXERCISE : 
#Make a function that returns the number of missing values per column
sapply(iris,function(var) sum(is.na(x)))
apply(iris,2,function(var) sum(is.na(x)))

#Make a function that returns the number of missing values per row
apply(iris,1,function(var) sum(is.na(x)))




