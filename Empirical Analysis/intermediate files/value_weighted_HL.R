cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\Empirical Analysis\\intermediate files"
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
HL <- fread("H and L.csv")

Result <- HL %>% group_by(Year, Month, rank) %>% 
  summarise(L1 = weighted.mean(L1, L1_MV, na.rm = TRUE),
            L2 = weighted.mean(L2, L2_MV, na.rm = TRUE),
            L3 = weighted.mean(L3, L3_MV, na.rm = TRUE),
            L4 = weighted.mean(L4, L4_MV, na.rm = TRUE),
            L5 = weighted.mean(L5, L5_MV, na.rm = TRUE),
            L6 = weighted.mean(L6, L6_MV, na.rm = TRUE),
            L7 = weighted.mean(L7, L7_MV, na.rm = TRUE),
            L8 = weighted.mean(L8, L8_MV, na.rm = TRUE),
            L9 = weighted.mean(L9, L9_MV, na.rm = TRUE),
            L10 = weighted.mean(L10, L10_MV, na.rm = TRUE),
            L11 = weighted.mean(L11, L11_MV, na.rm = TRUE),
            L12 = weighted.mean(L12, L12_MV, na.rm = TRUE))

Result %>% write_dta('value_weighted_HL.dta', version = 15)
