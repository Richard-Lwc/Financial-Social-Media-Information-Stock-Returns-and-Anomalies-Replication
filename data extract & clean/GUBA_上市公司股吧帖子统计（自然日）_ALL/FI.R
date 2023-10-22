cat("\f")  
rm(list=ls())
###############################################################################
# Set working directory
###############################################################################
wd <- "C:\\Users\\ASUS\\Desktop\\LEARN\\金融建模\\金融建模\\GUBA_上市公司股吧帖子统计（自然日）_ALL"
setwd(wd)
gc()
###############################################################################
# Library
###############################################################################
library(tidyverse)
library(openxlsx)
library(data.table)
library(DescTools)
library(haven)
###############################################################################
# Data merging
###############################################################################
p_2008 <- read.xlsx("2008\\上市公司股吧帖子统计（自然日）-2008.xlsx", startRow = 2)
p_2009_1 <- read.xlsx("2009\\上市公司股吧帖子统计（自然日）-2009_1.xlsx", startRow = 2)
p_2009_2 <- read.xlsx("2009\\上市公司股吧帖子统计（自然日）-2009_2.xlsx", startRow = 2)
p_2010_1 <- read.xlsx("2010\\上市公司股吧帖子统计（自然日）-2010_1.xlsx", startRow = 2)
p_2010_2 <- read.xlsx("2010\\上市公司股吧帖子统计（自然日）-2010_2.xlsx", startRow = 2)
p_2011_1 <- read.xlsx("2011\\上市公司股吧帖子统计（自然日）-2011_1.xlsx", startRow = 2)
p_2011_2 <- read.xlsx("2011\\上市公司股吧帖子统计（自然日）-2011_2.xlsx", startRow = 2)
p_2012_1 <- read.xlsx("2012\\上市公司股吧帖子统计（自然日）-2012_1.xlsx", startRow = 2)
p_2012_2 <- read.xlsx("2012\\上市公司股吧帖子统计（自然日）-2012_2.xlsx", startRow = 2)
p_2013_1 <- read.xlsx("2013\\上市公司股吧帖子统计（自然日）-2013_1.xlsx", startRow = 2)
p_2013_2 <- read.xlsx("2013\\上市公司股吧帖子统计（自然日）-2013_2.xlsx", startRow = 2)
p_2014_1 <- read.xlsx("2014\\上市公司股吧帖子统计（自然日）-2014_1.xlsx", startRow = 2)
p_2014_2 <- read.xlsx("2014\\上市公司股吧帖子统计（自然日）-2014_2.xlsx", startRow = 2)
p_2015_1 <- read.xlsx("2015\\上市公司股吧帖子统计（自然日）-2015_1.xlsx", startRow = 2)
p_2015_2 <- read.xlsx("2015\\上市公司股吧帖子统计（自然日）-2015_2.xlsx", startRow = 2)
p_2016_1 <- read.xlsx("2016\\上市公司股吧帖子统计（自然日）-2016_1.xlsx", startRow = 2)
p_2016_2 <- read.xlsx("2016\\上市公司股吧帖子统计（自然日）-2016_2.xlsx", startRow = 2)
p_2016_3 <- read.xlsx("2016\\上市公司股吧帖子统计（自然日）-2016_3.xlsx", startRow = 2)
p_2017_1 <- read.xlsx("2017\\上市公司股吧帖子统计（自然日）-2017_1.xlsx", startRow = 2)
p_2017_2 <- read.xlsx("2017\\上市公司股吧帖子统计（自然日）-2017_2.xlsx", startRow = 2)
p_2017_3 <- read.xlsx("2017\\上市公司股吧帖子统计（自然日）-2017_3.xlsx", startRow = 2)
p_2018_1 <- read.xlsx("2018\\上市公司股吧帖子统计（自然日）-2018_1.xlsx", startRow = 2)
p_2018_2 <- read.xlsx("2018\\上市公司股吧帖子统计（自然日）-2018_2.xlsx", startRow = 2)
p_2018_3 <- read.xlsx("2018\\上市公司股吧帖子统计（自然日）-2018_3.xlsx", startRow = 2)
p_2019_1 <- read.xlsx("2019\\上市公司股吧帖子统计（自然日）-2019_1.xlsx", startRow = 2)
p_2019_2 <- read.xlsx("2019\\上市公司股吧帖子统计（自然日）-2019_2.xlsx", startRow = 2)
p_2019_3 <- read.xlsx("2019\\上市公司股吧帖子统计（自然日）-2019_3.xlsx", startRow = 2)

post <- rbind(p_2008, p_2009_1, p_2009_2, p_2010_1, p_2010_2, p_2011_1, 
              p_2011_2, p_2012_1, p_2012_2, p_2013_1, p_2013_2, p_2014_1, 
              p_2014_2, p_2015_1, p_2015_2, p_2016_1, p_2016_2, p_2016_3, 
              p_2017_1, p_2017_2, p_2017_3, p_2018_1, p_2018_2, p_2018_3, 
              p_2019_1, p_2019_2, p_2019_3)

names(post) <- c('Stkcd', 'name', 'date', 'total', 'positive', 'negative', 
                 'neutral', 'read_num', 'comment_num')

post <- post %>% mutate(Year = Year(date), Month = Month(date)) %>% 
  group_by(Stkcd, Year, Month) %>% 
  summarise(total = sum(as.numeric(total)), 
            positive = sum(as.numeric(positive)),
            negative = sum(as.numeric(negative)),
            neutral = sum(as.numeric(neutral)),
            read_num = sum(as.numeric(read_num)),
            comment_num = sum(as.numeric(comment_num)))
# 按照原文，构造三种FI的类似指标
post <- post %>% ungroup() %>% mutate(FI = positive / total, 
                        FI_1 = (positive - negative) / (positive + negative),
                        FI_2 = negative / total,
                        FI_3 = (positive - negative) / total,
                        Stkcd = as.numeric(Stkcd))
post <- post %>% group_by(Stkcd) %>% mutate(lag_FI = lag(FI),
                                            lag_read = lag(read_num),
                                            lag_comment = lag(comment_num))
post %>% fwrite('FI.csv')
post %>% write_dta('FI.dta', version = 15)
