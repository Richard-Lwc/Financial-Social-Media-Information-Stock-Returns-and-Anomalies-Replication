cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\VOL&MAX&SKEW&MIN"
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
# daily return data
###############################################################################
daily_ret <- fread('..\\处理后的个股日回报率\\中间数据\\1.csv')
###############################################################################
# Generate index
###############################################################################
Result <- daily_ret %>% 
  group_by(Stkcd, Trdmnt) %>% 
  summarise(VOL = sd(Dretwd, na.rm = TRUE), 
            MAX = max(Dretwd, na.rm = TRUE),
            MIN = min(Dretwd, na.rm = TRUE),
            SKEW = skewness(Dretwd, na.rm = TRUE)) %>% 
  mutate(L1_VOL = lag(VOL),
         L1_MAX = lag(MAX),
         L1_MIN = lag(MIN),
         L1_SKEW = lag(SKEW))

# Outliers example
# daily_ret %>% filter(Dretwd > 10)
# daily_ret %>% filter(Stkcd == 156)

Result %>% fwrite('VOL&MAX&SKEW&MIN.csv')  
Result %>% write_dta('VOL&MAX&SKEW&MIN.dta', version = 15)

