#run_analysis.R 
if(!file.exists("rawData")){
    dir.create("rawData")
}
fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile = "rawData", method = "curl")
data=read.table("./rawData")
#unzip(temp, exdir = "./rawData")

