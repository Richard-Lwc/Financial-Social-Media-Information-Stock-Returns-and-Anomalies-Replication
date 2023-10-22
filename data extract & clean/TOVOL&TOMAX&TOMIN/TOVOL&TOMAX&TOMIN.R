cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\TOVOL&TOMAX&TOMIN"
setwd(wd)
gc()
###############################################################################
# Library
###############################################################################
library(tidyverse)
library(data.table)
library(haven)
###############################################################################
# Data merging
###############################################################################
# ToverOs [换手率(流通股数)(%)] - 计算公式为：日个股交易股数*100/流通股份
# ToverTl [换手率(总股数)(%)] - 计算公式为：日个股交易股数*100/总股份
# 采用换手率(总股数)(%)
to1 <- fread("个股换手率表(日)2008\\LIQ_TOVER_D.csv")
to2 <- fread("个股换手率表2009-2013\\LIQ_TOVER_D.csv")
to3 <- fread("个股换手率表2009-2013\\LIQ_TOVER_D1.csv")
to4 <- fread("个股换手率表2009-2013\\LIQ_TOVER_D2.csv")
to5 <- fread("个股换手率表(日)2014-2018\\LIQ_TOVER_D.csv")
to6 <- fread("个股换手率表(日)2014-2018\\LIQ_TOVER_D1.csv")
to7 <- fread("个股换手率表(日)2014-2018\\LIQ_TOVER_D2.csv")
to8 <- fread("个股换手率表(日)2014-2018\\LIQ_TOVER_D3.csv")
to9 <- fread("个股换手率表(日)2019\\LIQ_TOVER_D.csv")

to <- rbind(to1, to2, to3, to4, to5, to6, to7, to8, to9) %>% 
  mutate(Year = Year(Trddt), Month = Month(Trddt))

###############################################################################
# Construct index
###############################################################################
Result <- to %>% group_by(Stkcd, Year, Month) %>% 
  summarise(TOVOL = sd(ToverTl, na.rm = TRUE), 
            TOMAX = max(ToverTl, na.rm = TRUE),
            TOMIN = min(ToverTl, na.rm = TRUE), .groups = "drop") %>% 
  group_by(Stkcd) %>% mutate(L1_TOVOL = lag(TOVOL),
                             L1_TOMAX = lag(TOMAX),
                             L1_TOMIN = lag(TOMIN)) %>% 
  filter(!is.infinite(L1_TOMIN), 
         !is.infinite(L1_TOMAX),
         !is.infinite(L1_TOVOL))


Result %>% fwrite('TOVOL&TOMAX&TOMIN.csv')
Result %>% write_dta('TOVOL&TOMAX&TOMIN.dta', version = 15)
