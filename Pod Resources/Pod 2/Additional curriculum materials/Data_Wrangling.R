library(tidyverse)
library(tidybayes)
library(lme4)
library(lmerTest)
library(car)
library(merTools)
library(emmeans)
library(qqplotr)
library(modelr)
library(EMAtools)
library(multcomp)
library(insight)
library(bayestestR)
library(rstan)
library(psych)
library(brms)
library(tibble)
rm(list=ls())

#https://www.statology.org/pivot_wider-r/
#Typical Long format
df_long <- data.frame(player=rep(c('A', 'B'), each=4),
                 year=rep(c(1, 1, 2, 2), times=2),
                 stat=rep(c('points', 'assists'), times=4),
                 amount=c(14, 6, 18, 7, 22, 9, 38, 4))

#Can pivot to a wider version and create separate columns for points and assists
df_wider <- df_long %>% pivot_wider(id_cols = c(player,year),names_from = stat, values_from=amount)

# This might be where we want to stop for plotting purposes. 
# Having variables in their own distinct columns tends to work well for a lot of visuazlizations
# in ggplot
ggplot(df_wider,aes(x = points,y=assists,color=player))+
  geom_point()+
  theme_classic()
  
#But theoretically we could go wider still to obtain all the data for each player in a row
df_widest <- df_wider %>% pivot_wider(id_cols = c(player), names_from = year,
                                      values_from=c(assists,points),names_prefix = "year")

#Here we might compute some descriptive statistics
psych::describe(df_widest)

#We can also go from wide format back to long
#Remember to reference the pivot_longer information using ?pivot_longer in the console
#cols = the columns that contain the data you intend to pivot
#names_to = the names of your newly created column(s). If you specify more than one,
#you need to indicate a names_sep argument as well. Here "_year" tells R to take what
#comes before and after "_year" when putting data in the columns
df_long_again <- df_widest %>% pivot_longer(cols = 2:5, names_to=c("stat","year"),
                                            names_sep = "_year",values_to="amount")


#Loads in data from base R

data(iris)

#Specifies Species is a factor
iris$Species <- iris$Species %>% factor(levels=c("versicolor","virginica","setosa"))

#Specifies Species as a character
iris$Species <- iris$Species %>% as.character()

#Both character and factor variables can be used in stats functions and ggplot, 
#but I prefer to explicitly change my datatypes to what I want them to be instead of letting
#a function do it automatically (whether it ends of working the way I intend or not)

#library(magrittr)
#The %<>% pipe version allows you to overwrite your dataframe automatically after its modified by whatever functions
#eg The below code takes iris and pipes it through all the code we talked about, but then it also saves
#the result in the iris data frame. You must use library(magrittr) (install it first) 
#for this pipe to work
# iris %<>% pivot_longer(cols=c(1:4),names_to="Measure",
#                        values_to = "Value") %>% 
#   separate(Measure,c("FlowerPart","Measure"),sep = "\\.") %>% 
#   dplyr::mutate(id = rep(1:(nrow(.)/4),each=4)) %>%  
#   pivot_wider(names_from = "Measure", values_from = "Value") %>% 
#   dplyr::select(1,2,4,5,3)

# %>% this pipe is more common and comes from tidyverse. 
#This does not save the dataframe automatically
#The below code will run but it won't save anything as an object in your workspace

# iris %>%  pivot_longer(cols=c(1:4),names_to="Measure",
#                        values_to = "Value") %>% 
#   separate(Measure,c("FlowerPart","Measure"),sep = "\\.") %>% 
#   dplyr::mutate(id = rep(1:(nrow(.)/4),each=4)) %>%  
#   pivot_wider(names_from = "Measure", values_from = "Value") %>% 
#   dplyr::select(1,2,4,5,3)

#You would have to assign it to an object with the same name as iris or a different name

# iris <- iris %>%  pivot_longer(cols=c(1:4),names_to="Measure",
#                        values_to = "Value") %>% 
#   separate(Measure,c("FlowerPart","Measure"),sep = "\\.") %>% 
#   dplyr::mutate(id = rep(1:(nrow(.)/4),each=4)) %>%  
#   pivot_wider(names_from = "Measure", values_from = "Value") %>% 
#   dplyr::select(1,2,4,5,3)

#Creates
iris_long <- iris %>% pivot_longer(cols=c(1:4),names_to="Measure",
                                   values_to = "Value") %>% 
                      separate(Measure,c("FlowerPart","Measure"),sep = "\\.") %>% 
                      dplyr::mutate(id = rep(1:(nrow(.)/4),each=4)) %>%  
  pivot_wider(names_from = "Measure", values_from = "Value") %>% 
  dplyr::select(1,2,4,5,3)

iris_long$Species <- as.character(iris_long$Species)
iris_long$Species <- iris_long$Species %>% factor(levels=c("virginica","setosa","versicolor"))
  

ggplot(data=iris_long,aes(x=Width,y=Length,color=Species))+
  facet_wrap(~FlowerPart)+
  geom_point()+
  geom_smooth(aes(group=Species),method="lm")+
  theme_classic()

#Can use longer formats to run statistical models
iris_model <- lm(Length ~ 1 + Width*Species,data=iris_long)
iris_model_2 <- glmmTMB::glmmTMB(Length ~ 1 + Width*Species,data=iris_long)


#Converting to numeric to character can distort visualization
iris_long$Length <-as.character(iris_long$Length)

ggplot(data=iris_long,aes(x=Width,y=Length,color=Species))+
  facet_wrap(~FlowerPart)+
  geom_point()+
  geom_smooth(aes(group=Species),method="lm")+
  theme_classic()
