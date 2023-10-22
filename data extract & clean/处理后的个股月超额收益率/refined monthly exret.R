cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\处理后的个股月超额收益率"
setwd(wd)
gc()
###############################################################################
# Library
###############################################################################
library(tidyverse)
library(data.table)
library(haven)
###############################################################################
# Data Insert
###############################################################################
monthly_ret <- fread("月个股回报率\\TRD_Mnth.csv")
# 股票池
stock_pool <- fread("..\\Stock Pool\\stock pool.csv")
# 月末总市值
MV <- fread("..\\ME\\ME.csv")
# Risk free rate
rf <- fread("..\\Risk free rate\\monthly rf\\RF.csv") %>% select(-month)
###############################################################################
# Select and Generate
###############################################################################
monthly_ret <- monthly_ret %>% select(-Markettype) %>% filter(!is.na(Mretwd)) %>% 
  semi_join(stock_pool, by = c('Stkcd', 'Trdmnt')) %>% 
  separate(Trdmnt, into = c('Year', 'Month'), sep = '-', convert = TRUE, remove = FALSE) %>% 
  left_join(MV, by = c('Stkcd', 'Trdmnt')) %>% 
  left_join(rf, by = c('Year', 'Month')) %>% 
  mutate(Ri = Mretwd - rf,
         lag_ME = lag_ME / 1000,
         Msmvttl = Msmvttl / 1000)
# 因为haven包导出的dta数据不能过大，因此市值均除以1000

monthly_ret %>% fwrite('refined monthly exret.csv')
monthly_ret %>% write_dta('refined monthly exret.dta', version = 15)

