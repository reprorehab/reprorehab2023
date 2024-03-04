#Clears workspace of old data frames
rm(list=ls())

#Loads relevant libraries with the functions we need
library(tidyverse)
library(ggdist)

#Set working directory tells R where to look for the data we are trying to load
setwd("/Users/Tanner/Library/CloudStorage/Box-Box/ReproRehab2023 Pod 2/Data Visualization")

#Reads in dataframe we want to work with
mfr_data <- read.csv("MFR_TQ_CV.csv") %>% dplyr::select(-1) %>% 
  dplyr::mutate(Muscle = recode(Muscle,'SOL' = 'MLSOL')) %>% filter(SubID != 'S1')


#Plotting all data points on a single graph
ggplot(data=mfr_data,aes(x=Muscle,y=MFR,fill=Muscle))+
  geom_boxplot(width = 0.4, outlier.shape = NA, linewidth=0.5)+
  geom_jitter(size=0.2,width=0.2,alpha=0.5)+
  theme_classic()+
  ylab("MFR (pulses per second)")+
  theme(legend.position="NONE")+
  ggtitle("MFR vs. Muscle")


#Allow a new graph for each subject
ggplot(data=mfr_data,aes(x=Muscle,y=MFR))+
  geom_boxplot(width = 0.4, outlier.shape = NA,linewidth=0.5)+
  geom_jitter(size=0.2,width=0.2,alpha=0.5,aes(color=Muscle))+
  theme_classic()+
  facet_wrap(~SubID)+
  theme(legend.position="NONE")+
  ggtitle("MFR vs. Muscle")

#Plot distributions for each muscle
ggplot(data=mfr_data,aes(y=Muscle,x=MFR,fill=Muscle))+
  stat_halfeye()+
  stat_summary(aes(group=SubID,color=SubID),fun=mean)+
  theme_classic()+
  theme(legend.position="NONE")

#Connected Lines for paired data
ggplot(data=mfr_data,aes(x=Muscle,y=MFR))+
  geom_boxplot(outlier.shape=NA, width = 0.4)+
  stat_summary(fun.y="mean",geom="line",aes(group=SubID),linewidth=0.3)+
  stat_summary(fun.y="mean",aes(group=SubID,color=SubID))+
  theme_classic()+
  theme(legend.position="NONE")

ggplot(data=mfr_data,aes(x=Muscle,y=MFR))+
  geom_boxplot(outlier.shape=NA, width = 0.4)+
  stat_summary(fun.y="mean",aes(group=SubID,color=SubID),position=position_jitter(width=0.2))+
  theme_classic()+
  theme(legend.position="NONE")
  


