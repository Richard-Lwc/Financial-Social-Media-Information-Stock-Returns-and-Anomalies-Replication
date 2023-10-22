cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\ISKEW&IVOL&COSKEW"
setwd(wd)
gc()
###############################################################################
# Library
###############################################################################
library(tidyverse)
library(data.table)
library(moments)
library(haven)
###############################################################################
# Data Insert
###############################################################################
residual_data <- fread('ff3_residual.csv')
###############################################################################
# Construct index
###############################################################################
Result <- residual_data %>% group_by(Stkcd, Trdmnt) %>% 
  summarise(ISKEW = skewness(residual),
            IVOL = sd(residual),
            COSKEW = mean(residual * (Rm ** 2)) / 
              (sqrt(mean(residual ** 2)) * mean(Rm ** 2))) %>% 
  mutate(L1_ISKEW = lag(ISKEW),
         L1_IVOL = lag(IVOL),
         L1_COSKEW = lag(COSKEW))

            
Result %>% fwrite('ISKEW&IVOL&COSKEW.csv')
Result %>% write_dta('ISKEW&IVOL&COSKEW.dta', version = 15)
