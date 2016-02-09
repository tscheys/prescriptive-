#QUESTIONS ABOUT THIS DOCUMENT: matthias.bogaert@ugent.be or steven.hoornaert@ugent.be

##########################################################################################################
#2 BY PROCESSING

#EXERCISE: Using the Iris dataset, calculate the mean and the standard deviation for every Species
data(iris)
str(iris)
#mean
species_mean <- aggregate(iris[,names(iris) != 'Species'], by = list(Species=iris$Species),mean)
# standard deviation
species_sd <- aggregate(iris[,names(iris) != 'Species'], by = list(Species=iris$Species),sd)

##########################################################################################################
#3 MERGING

#EXERCISE: Use the datasets created in the previous exercise from the Iris dataset. Create an extra dataset calculating the sum and merge them all together.
#EXTRA: Make sure that you clearly know which columns respresent the mean, the standard deviation and the sum.
species_sum <- aggregate(iris[,names(iris) != 'Species'], by = list(Species=iris$Species),sum)

names(species_sum)[2:ncol(species_sum)]<- paste(names(species_sum)[2:ncol(species_sum)],sep='.','Sum')
names(species_mean)[2:ncol(species_mean)]<- paste(names(species_mean)[2:ncol(species_mean)],sep='.','Mean')
names(species_sd)[2:ncol(species_sd)]<- paste(names(species_sd)[2:ncol(species_sd)],sep='.','Sd')

mergelist <- list(species_sum, species_mean, species_sd)
species_merge2 <- Reduce(function(x,y) merge(x,y,by='Species'), mergelist)