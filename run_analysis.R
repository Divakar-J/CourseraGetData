library(sqldf)
## read required data . 2 datasets are common for both test and training
activity_labels <- read.table("activity_labels.txt" )
features <- read.table("features.txt" )
x_test <- read.table("test/X_test.txt" )
y_test <- read.table("test/y_test.txt" )
subject_test <- read.table("test/subject_test.txt" )
x_train <- read.table("train/X_train.txt" )
y_train <- read.table("train/y_train.txt" )
subject_train <- read.table("train/subject_train.txt" )

## bind rows from test and train . column names will be added later
subject_all <- rbind(subject_test,subject_train)
y_all  <- rbind(y_test, y_train)
x_all  <- rbind(x_test,x_train)
## add column names
colnames(subject_all) <- "volunteerID"
colnames(y_all) <- "ActivityCode"
colnames(activity_labels) <- c("ActivityCode","ActivityLabel")
colnames(x_all) <- features[,c(2)]
## add activity label to y_all

getLabel <- function(x) {
label <- activity_labels$ActivityLabel[x]
 label
}
 y_all$ActivityLabel <- getLabel(y_all$ActivityCode)

## column bind subjects , y and x data
uci_data <- cbind(subject_all,y_all,x_all)

## validate data . 561 columns from x data , 1 column from subject , 2 from ydata
nrow(uci_data)
ncol(uci_data)

## Extract only required columns . Keep only mean() + std(), volunteer, activity label
uci_col_names <- colnames(uci_data)
#uci_col_names[uci_col_names=="volunteerID" | uci_col_names=="ActivityLabel"]
#uci_col_names[grep("mean\\(",uci_col_names)]
#uci_col_names[grep("std\\(",uci_col_names)]

uci_final_data <- uci_data[,c(uci_col_names[uci_col_names=="volunteerID" | uci_col_names=="ActivityLabel"],uci_col_names[grep("mean\\(",uci_col_names)],uci_col_names[grep("std\\(",uci_col_names)])]

uci_col_names <- colnames(uci_final_data)
colnames(uci_final_data) <- gsub("\\)","",gsub("\\(","",uci_col_names))

## replace column names again to remove "(" and ")"
uci_col_names <- colnames(uci_final_data)
colnames(uci_final_data) <- gsub("\\)","",gsub("\\(","",uci_col_names))

## Make quick checks
sqldf("select count(volunteerID) from uci_final_data")
sqldf("select count(distinct volunteerID) from uci_final_data")
sqldf("select count(distinct ActivityLabel) from uci_final_data")

## prepare tidy data

uci_final_data$ActivityLabel <- as.character(uci_final_data$ActivityLabel)
## data contains character column activity label. suppress warning as it is remapped later
suppressWarnings(aggdata <-aggregate(uci_final_data, by=list(uci_final_data$volunteerID,uci_final_data$ActivityLabel), FUN=mean, na.rm=TRUE))
## aggregate creates two additional columns for group . delete original


colnames(aggdata)[1:2] <- c("Volunteer","Activity")
tidyData <- aggdata[,-c(3,4)]

#write.table(tidyData, file = "tidyData.txt", sep = ",", row.name=FALSE)
write.table(tidyData, file = "tidyData.txt",  row.name=FALSE)
