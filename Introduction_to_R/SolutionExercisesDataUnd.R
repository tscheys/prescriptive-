#QUESTIONS ABOUT THIS DOCUMENT: matthias.bogaert@ugent.be or steven.hoornaert@ugent.be

##########################################################################################################
#1 OBJECT TYPES AND SUBSETTING

#EXERCISE: Using the df/dt and l datasets. Select the numbers corresponding with the letters 'd' and 'g.
#df
df[df$fact_vector == 'd' | df$fact_vector =='g', 'int_vector']

#dt
dt[fact_vector == 'd' | fact_vector =='g', int_vector]

#list
l[[1]][df$fact_vector == 'd' | df$fact_vector =='g', 'int_vector']

#Using which
which(df$fact_vector == 'd' | df$fact_vector =='g')

##########################################################################################################
#4 DATA EXPLORATION

#EXERCISE: Display a random subset of 5 elements 
subscriptions[sample(x = 1:nrow(subscriptions),size = 5,replace=FALSE),]
subscriptions[sample.int(n=nrow(subscriptions),5),]

#EXERCISE: relative frequencies of PaymentStatus, rounded on two-digits.
round(table(subscriptions$PaymentStatus)/nrow(subscriptions),digits=2)

##########################################################################################################
#5 MISSING VALUES

#EXERCISE: Change the missing value of the first column to 0. 
data <- data.frame(v_int=as.integer(c(1,1,2,NA)),v_num=as.numeric(c(1.1,1.1,2.2,NA)),v_char=as.character(c('one','one','two',NA)),v_fact=as.factor(c('one','one','two',NA)),stringsAsFactors = FALSE)
data
data[is.na(data)[,1],1] <- 0
data
