#clears out old variables
rm(list=ls())

#Loads in relevant libraries
library(tidyverse)
library(psych)
library(ggcorrplot)
library(ggpubr)
library(scales)
library(qqplotr)
library(multcomp)
library(car)
#install.packages(c("car","multcomp"))
#Loads in data
data(mtcars)

#Provides information regarding variables in the data frame
?mtcars()

#Let's just select the column's we are interested in 
mtcars <- mtcars %>% dplyr::select(mpg,cyl,disp,hp,wt,am)

#Basic descriptive statistics
describe(mtcars)

#Correlations between variables
#Correlation matrix
cor(mtcars)
ggcorrplot(cor(mtcars),type="lower",hc.order=TRUE,lab=TRUE)

cor(mtcars$mpg,mtcars$disp)
#How does gas mileage change with engine displacement?

ggplot(data=mtcars, aes(x=disp,y=mpg))+
  geom_point()+
  geom_smooth(method="lm")+
  ylab("Fuel Economy (miles per gallon)")+
  xlab("Engine Displacement")+
  theme_classic()

#Let's fit a model predicting mpg from engine displacement
mod1 <- lm(mpg ~ 1 + disp, data=mtcars)
summary(mod1)

#Presently the intercept corresponds to the mean mpg for a hypothetical 
#car w/out an engine (mpg = 0). I prefer to center continuous predictors
#when convenient to aid in interpretation

#You can center on any value you'd like, but I prefer to use the mean.
mtcars$disp_c <- mtcars$disp - mean(mtcars$disp)

mod2 <- lm(mpg ~ 1 + disp_c, data=mtcars)
summary(mod2)
#Centered and non-centered versions provide identical model fit
anova(mod1,mod2)

#We can use the summary() function to look at model results
summary(mod2)

#We can also add this to our plot
ggplot(data=mtcars, aes(x=disp_c,y=mpg))+
  geom_point()+
  geom_smooth(method="lm")+
  ylab("Fuel Economy (miles per gallon)")+
  xlab("Engine Displacement (centered at mean)")+
  stat_regline_equation(label.x=100)+
  theme_classic()

ggplot(data=mtcars, aes(x=disp_c,y=mpg))+
  geom_point()+
  geom_smooth(method="lm")+
  ylab("Fuel Economy (miles per gallon)")+
  xlab("Engine Displacement")+
  stat_regline_equation(
    aes(label = paste(..eq.label..,..adj.rr.label..,sep ="~~~~")),
                                      label.x=100)+
  theme_classic()


#QQ Plot to check some model assumptions
ggplot(data=resid(mod2) %>% as.data.frame(),aes(sample = .))+
  stat_qq_line()+
  stat_qq_band()+
  stat_qq_point()

mod2_resid = cbind(resid(mod2),fitted(mod2)) %>% as.data.frame()
names(mod2_resid) = c("Fitted","Residual")

#Residual vs fitted plot to check for heteroskedasticity
ggplot(data=mod2_resid, aes(x=Fitted,y=Residual))+
  geom_point()+
  geom_smooth()

#Let's look at adding a categorical interaction
#Let's see if mpg vs disp changes as a function 
#of the number of cylinders we have

#Setting up cyl as a factor variable
mtcars$cyl_f <- factor(mtcars$cyl)

#Accounting for this iteraction...
mod3a <- lm(mpg ~ 1 + cyl_f + disp_c + cyl_f:disp_c, data=mtcars)

#Equivalent model
mod3b <- lm(mpg ~ 1 + cyl_f*disp_c,data=mtcars)
summary(mod3b)

#No Intercept model
mod3_no_int <- lm(mpg ~ 0 + cyl_f + cyl_f:disp_c,data=mtcars)
summary(mod3_no_int)
anova(mod3a,mod3b,mod3_no_int)

anova(mod2,mod3a)
anova(mod3a)

summary(mod3a)

#We can update our plot to reflect this model
ggplot(data=mtcars, aes(x=disp_c,y=mpg,color=cyl_f))+
  geom_point()+
  geom_smooth(method="lm")+
  ylab("Fuel Economy (miles per gallon)")+
  xlab("Engine Displacement")+
  stat_regline_equation(label.x=100)+
  theme_classic()

#Checking homogeneity of covariance assumption to ensure regression slopes are equal
ggplot(data=mtcars, aes(x=disp_c,y=mpg,color=cyl_f))+
  geom_point()+
  geom_smooth(method="lm")+
  geom_abline(slope = -0.135,intercept = 9.69,color=hue_pal()(1))+
  geom_abline(slope = -0.020,intercept = 17.5,color=hue_pal()(2)[2])+
  geom_vline(xintercept = mean(mtcars$disp_c))+
  ylab("Fuel Economy (miles per gallon)")+
  xlab("Engine Displacement")+
  geom_point(data=data.frame(cyl_f=factor(c(4,6,8)),disp_c=c(0,0,0),mpg=coef(mod3_no_int)[1:3]),
             size=3)+
  scale_color_discrete(name="Number\nof Cylinders")+
  stat_regline_equation(label.x=100)+
  theme_classic()

#linear combination 
rownames=c("4-6","4-8","6-8")
colnames=names(coef(mod3_no_int))
mat = matrix(c(0,0,0,1,-1,0,
               0,0,0,1,0,-1,
               0,0,0,0,1,-1),
               byrow=TRUE,nrow=3,
               dimnames = list(rownames,colnames))

summary(mod3_no_int)
summary(glht(mod3_no_int,linfct=mat,alternative="two.sided",rhs=0))


ggplot(data=mtcars,aes(x=cyl_f,y=mpg,fill=cyl_f))+
  geom_boxplot()+
  theme_classic()


#Remember with analysis of covariance we are trying to adjust the means
#we are interested in comparing by controlling for a continuous variable
#that could account for some of these differences
summary(glht(mod4,linfct=matrix(c(0,0,-1,1),byrow=TRUE,nrow=1),
             alternative="two.sided",rhs=0))

summary(mod3a)

#Type I sums of squares (the default in R)
anova(mod3a)

Anova(mod3a,type="III")

describe(mtcars)

summary(mod3a)
