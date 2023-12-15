#THIS CODE IS MEANT TO TAKE A DATASET AND CONVERT IT INTO A DEMOGRAPHICS TABLE
#WHICH CAN BE THEN CONVERTED INTO A WORD DOC TO BE THEN USED AS PART OF A MANUSCRIPT
#THIS IS A WORKING EXAMPLE WITH A DATASET TAKEN FROM KAGGLE

#link here: https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset/

#IT IS FREE TO DOWNLOAD THOSE DATA, ALTHOUGH THEY ARE ALSO POSTED IN THE REPROREHAB FOLDER

rm(list = ls()) #remove variables from environment

#You will want to install the package before loading it if you haven't already
#You only need to do this once for each installation of R
#install.packages("gtsummary") 
#load library
library(gtsummary) #You will have to load each library once for every new session/restart
#install.packages("huxtable") #This library has a function that will convert the table to a word doc
library(huxtable)

#THE MINIMUM AMOUT OF CODE YOU NEED TO COVERT A TABLE INTO A WORD DOC IS FROM LINES 14 TO 48

#You'll want to change this to your computer specific path
setwd("C:/Users/Andrew Hooyman/Dropbox (ASU)/ReproRehab/2023/Datasets")

#Import data
data=read.csv("healthcare-dataset-stroke-data.csv")

#Look at varaible types in data. Is everything a num/chr/int that should be 
str(data)

#Remove any variables you don't want to include in your table
#I don't want id
data1=subset(data,select = -id)

#sanity check to make sure I remove
names(data1) #looks good

#Function to convert the data to a table that can be exported as a .png
tb=tbl_summary(data1, #tell function what dataset to convert
               statistic = list( #Tell function what statistics you want,
                 #I want multiple so I am going to call them as a list.
                 all_continuous() ~ "{mean} ({sd})", #I want mean and standard deviation for continuous variables
                 all_categorical() ~ "{n} ({p}%)" #I want count and percent of total sample for categorical
               ),
               digits = all_continuous() ~ 2, #I want two points of precision (two decimal points) for continuous
               missing = "ifany") %>% #This symbol %>% is called the pipe operator and it allows you to link
                                      #Link functions without having to enter in the arguments for each one independently
              #I want to include a line for all categorical variables if any are missing
  bold_labels() #Make variable names bold

#Print to the viewer
tb

###IF THE TABLE LOOKS GOOD THEN YOU WOULD EXECUTE LINES 54 AND 57 TO GET THE WORD DOC
# #Convert to a format that can then be convert to a word doc
# table1=as_hux_table(tb)
# #Convert to word doc which will be saved in your current path
# quick_docx(table1)

#THIS TABLE IS NOT MANUSCRIPT READY YET. I AM GOING TO WORK ON IT SOME MORE TO GET IT TO A LEVEL
#THAT IT WOULD BE MANUSCRIPT READY.

#bmi is NOT in the variable class, currently character, should be num
#this was probably because missing values were coded as N/A and not NA
#I can convert the strings to numeric with this function, and anything that isn't easily convertible will be 
#"coerced" into an NA
data1$bmi=as.numeric(data1$bmi) 

#Let's try again
tb=tbl_summary(data1, 
               statistic = list(
                 all_continuous() ~ "{mean} ({sd})",
                 all_categorical() ~ "{n} ({p}%)"
               ),
               digits = all_continuous() ~ 2,
               missing = "ifany") %>%
  bold_labels()

#Print to the viewer; much better
tb

#The variable names need to be changed to include capitalization and spaces between words
names(data1)
#I can do this by replacing the names of the variable as if they were a vector
names(data1)=c("Gender","Age","Hypertension","Heart Disease","Ever Married",
               "Work Type","Residence Type","Average Glucose Level","BMI (kg/m\u00b2)", #/u00b2 is unicode to
               "Smoking Status","Stroke")                                               #give a superscript 2

names(data1)

#Better Variable Names
tb=tbl_summary(data1, 
               statistic = list(
                 all_continuous() ~ "{mean} ({sd})",
                 all_categorical() ~ "{n} ({p}%)"
               ),
               digits = all_continuous() ~ 2,
               missing = "ifany") %>%
  bold_labels()

#Print to the viewer; much better
tb

#I could continue to modify the names of categorical variables but since this will be a word
#doc I can just modify them directly. Work smarter not harder

#However, I may want to change the order of the variables.
#I'll create a new data variable for this as a mistake may make debugging difficult
data2 = data1[,c("Age","Gender","BMI (kg/m²)","Stroke","Heart Disease","Hypertension",
                 "Average Glucose Level","Smoking Status","Ever Married", "Residence Type","Work Type")]

names(data2)

#Better Variable Names
tb=tbl_summary(data2, #Changed dataset 
               statistic = list(
                 all_continuous() ~ "{mean} ({sd})",
                 all_categorical() ~ "{n} ({p}%)"
               ),
               digits = all_continuous() ~ 2,
               missing = "ifany") %>%
  bold_labels()

#Print to the viewer; I think that is good to go!
#Again, I can change the text further in the word doc and don't need to change it via code
tb

#NOW TAKE FINAL TABLE AND CONVERT TO WORD DOC
# #Convert to a format that can then be convert to a word doc
# table1=as_hux_table(tb)
# #Convert to word doc which will be saved in your current path
# quick_docx(table1)
