rm(list=ls())

#Load libraries
library(ggplot2)

###MY GOAL: MERGE MY DEMOGRAPHIC DATA WITH MY COGNITIVE DATA AND VISUALIZE IF THERE
###ARE LONGITUDINAL CHANGES IN COGNITION BETWEEN DIFFERENT VARIABLES

#Set root directory 
setwd("C:/Users/Andrew Hooyman/Dropbox (Personal)/Andrew/ADNI/ADNIMERGE_0.0.1.tar/ADNIMERGE_0.0.1/ADNIMERGE/data")

#Load in my data
load("ptdemog.RData") #I assume it's wide
load("mmse.RData") #I think it's long

#Let's check that demo is actually wide
names(ptdemog)
unique(ptdemog$VISCODE)

#I just want to screening data (sc)
demosc=ptdemog[ptdemog$VISCODE=="sc",]

#How many NA's do I have in each column?
colSums(apply(demosc,2,is.na))
#11 missing in AGE

#Multiple ways to handle this
demoscNOMISSINGAGE=demosc[!is.na(demosc$AGE),]
#Sanity Check
colSums(apply(demoscNOMISSINGAGE,2,is.na))

#Replace with the mean?
mean(demosc$AGE,na.rm = T)
sd(demosc$AGE,na.rm = T)
range(demosc$AGE,na.rm = T) #WTF?
hist(demosc$AGE) #Young People??
sum(demosc$AGE<55,na.rm = T) #14 people younger than 55
demosc$AGE[which(demosc$AGE<55)] #But how old are they? 5 Babies and a 20 something?

#Let's take a step back and see if there are other weird things in here
library(gtsummary)
library(dplyr)

demo.table=subset(demosc,select = c(AGE,PTGENDER,PTHAND,PTEDUCAT))

#Function to convert the data to a table that can be exported as a .png
tb=tbl_summary(demo.table, #tell function what dataset to convert
              # by = PTGENDER,
               type = all_continuous() ~ "continuous2",#works best when printing range
               statistic = list( #Tell function what statistics you want,
                 #I want multiple so I am going to call them as a list.
                 all_continuous() ~ c("{mean}", "{sd}", "{min},{max}"), #I want mean, standard deviation and range for continuous variables
                 all_categorical() ~ "{n} ({p}%)" #I want count and percent of total sample for categorical
               ),
               digits = all_continuous() ~ 2, #I want two points of precision (two decimal points) for continuous
               missing = "ifany") %>% #This symbol %>% is called the pipe operator and it allows you to link
  #Link functions without having to enter in the arguments for each one independently
  #I want to include a line for all categorical variables if any are missing
  bold_labels() #%>% #Make variable names bold
  #add_p(pvalue_fun = ~ style_pvalue(.x, digits = 2))

#Print to the viewer
tb

#Let's remove the babies and 20 year old
demosc=demosc[demosc$AGE>50,]
demoscNOMISSINGAGE=demoscNOMISSINGAGE[demoscNOMISSINGAGE$AGE>50,]#Do the same thing for our no missing data frame

#Sanity Check
hist(demosc$AGE)#Wonderful

demoscMEANREPLACED=demosc #Create a dataframe for replacing missing with mean
demoscMEANREPLACED$AGE[is.na(demoscMEANREPLACED$AGE)]=mean(demoscMEANREPLACED$AGE,na.rm = T)
sum(is.na(demoscMEANREPLACED$AGE))#Looks good
mean(demoscMEANREPLACED$AGE)#Also acceptable

#For the missing handed and Education people I will just remove
demo.Final=demoscMEANREPLACED[!is.na(demoscMEANREPLACED$PTEDUCAT) & !is.na(demoscMEANREPLACED$PTHAND),]
demo.Final=subset(demo.Final,select = c(AGE,PTGENDER,PTHAND,PTEDUCAT,RID))#Keep only variables of interest
colSums(apply(demo.Final,2,is.na))#My final clean dataset

#Time to merge
#How many visits do I have across all time points?
table(mmse$VISCODE)[order(table(mmse$VISCODE))]#Let's order it to ease our search
#Looks like first for annual visits have good amount
#Do I want all these visits? Let's settle for 4 years in 1 year increments
mmse4=mmse[mmse$VISCODE=="sc" | 
             mmse$VISCODE=="m12" | 
             mmse$VISCODE=="m24" | 
             mmse$VISCODE=="m36" |
             mmse$VISCODE=="m48",]

table(mmse4$VISCODE)

mmse4TOTAL=subset(mmse4,select = c(MMSCORE,RID,VISCODE))#Let's Just keep the things we need
#Now we merge
merged.df=merge(mmse4TOTAL,demo.Final,by="RID")
#Looks like I have some more observations than I expected
#Duplicates?
sum(duplicated(demo.Final$RID))#WTF?! 209 Duplicates?!
table(merged.df$VISCODE)
demo.Final1=demo.Final[!duplicated(demo.Final$RID),]#Remove those duplicates
#Let's try again
merged.df=merge(mmse4TOTAL,demo.Final1,by="RID")#I should get 8227 rows
#I get 8138. This is okay. It probably means that some had demo data but not mmse and vice versa

#Before I visualize I need to set the levels of VISCODE
merged.df$VISCODE=factor(merged.df$VISCODE,levels = c("sc","m12","m24","m36","m48"))
#Sanity Check
levels(merged.df$VISCODE)

#Time to visualize!!
ggplot(merged.df,aes(x=VISCODE,y=MMSCORE,color=PTGENDER))+
  geom_boxplot()+
  ylab("MMSE")+
  xlab("Visit in Years")+
  labs(color="Gender")
  #geom_point()+
  #geom_smooth(method = 'lm')
#Where are my regression lines?!
#VISCODE is a factor, regression won't fit a line with factor as the independent variable

#Time to change VISCODE to a numeric
merged.df$VISCODEn=NA
merged.df$VISCODEn[merged.df$VISCODE=="sc"]=0
merged.df$VISCODEn[merged.df$VISCODE=="m12"]=1
merged.df$VISCODEn[merged.df$VISCODE=="m24"]=2
merged.df$VISCODEn[merged.df$VISCODE=="m36"]=3
merged.df$VISCODEn[merged.df$VISCODE=="m48"]=4

#Sanity Check
table(merged.df$VISCODEn)
table(merged.df$VISCODE)

ggplot(merged.df,aes(x=VISCODEn,y=MMSCORE,color=PTGENDER))+
  geom_point()+
  geom_smooth(method = 'lm')

ggplot(merged.df,aes(x=VISCODEn,y=MMSCORE,color=PTGENDER))+
  #geom_point()+
  geom_smooth(method = 'lm')+
  ylab("MMSE")+
  xlab("Visit in Years")+
  labs(color="Gender")
