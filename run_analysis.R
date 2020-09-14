setwd("C:/Users/User/OneDrive/Documents/R/UCI HAR Dataset")
library(plyr)
library(data.table)
st = read.table('./train/subject_train.txt',header=FALSE)
xt = read.table('./train/x_train.txt',header=FALSE)
yt = read.table('./train/y_train.txt',header=FALSE)

ste = read.table('./test/subject_test.txt',header=FALSE)
xte = read.table('./test/x_test.txt',header=FALSE)
yte = read.table('./test/y_test.txt',header=FALSE)

xds <- rbind(xt, xte)
yds <- rbind(yt, yte)
sds <- rbind(st, ste)
dim(xds)

dim(yds)

dim(sds)

xms <- xds[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xms) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2]
View(xms)
dim(xms)

yds[, 1] <- read.table("activity_labels.txt")[yds[, 1], 2]
names(yds) <- "Activity"
View(yds)

names(sds) <- "Subject"
summary(sds)

single <- cbind(xms, yds, sds)

names(single) <- make.names(names(single))
names(single) <- gsub('Acc',"Acceleration",names(single))
names(single) <- gsub('GyroJerk',"AngularAcceleration",names(single))
names(single) <- gsub('Gyro',"AngularSpeed",names(single))
names(single) <- gsub('Mag',"Magnitude",names(single))
names(single) <- gsub('^t',"TimeDomain.",names(single))
names(single) <- gsub('^f',"FrequencyDomain.",names(single))
names(single) <- gsub('\\.mean',".Mean",names(single))
names(single) <- gsub('\\.std',".StandardDeviation",names(single))
names(single) <- gsub('Freq\\.',"Frequency.",names(single))
names(single) <- gsub('Freq$',"Frequency",names(single))

View(single)

names(single)

D2<-aggregate(. ~Subject + Activity, single, mean)
D2<-D2[order(D2$Subject,D2$Activity),]
write.table(D2, file = "tidydata.txt",row.name=FALSE)


