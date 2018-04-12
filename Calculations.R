##Read files named xyz1111.csv, xyz2222.csv, etc.
filenames <- list.files(pattern="*.csv")

##Create list of data frame names without the ".csv" part 

library(readr)
library(data.table)
###Load all files
data.list <- list()
for(i in 1:length(filenames)){
  data.list[[i]] <- read_csv(filenames[i])
  data.list[[i]] <- data.list[[i]][,c("Student ID", "Aggregate Total")]
  colnames(data.list[[i]]) <- c("NET_ID", paste("SCORE_", sub('\\..*', '', filenames[i])))
  data.list[[i]] <- as.data.table(data.list[[i]])
  setkey(data.list[[i]], NET_ID)
}

all.dat <- data.list[[1]]
for (i in 2:length(data.list)) {
  all.dat <- merge(all.dat, data.list[[i]], all.x = TRUE)
}

d1 <- read.csv("Snow.csv", stringsAsFactors = FALSE)
d1$Aggregate.Total <- as.numeric(d1$Aggregate.Total)
d1  <- d1[!is.na(d1$Aggregate.Total),]
d1$max <- max(d1$Aggregate.Total)




# Net2 <- read.csv("Survey.csv", stringsAsFactors = FALSE)
# d1$Aggregate.Total <- d1$Aggregate.Total + 1
# d1$pct <- numeric(nrow(d1))
# for (i in 1:nrow(d1)){
#   if(d1[i,3] %in% Net2[,1]){
#     d1[i,5]=d1[i,5]+1
#   }
#   d1[i,7] <- min(1, d1[i,5]/d1[i,6])
# }

d1$pct <- 100*d1$pct
write.csv(d1, "Snow2.csv")
