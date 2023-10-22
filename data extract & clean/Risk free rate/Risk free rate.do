**************************   Risk-free Rate   *******************************
// monthly
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\Risk free rate"
import excel "monthly rf\RESSET_BDMONRFRET.xls", firstrow clear

// 将日期转化为年月的格式
gen month = mofd(日期_Date)
format month %tm

rename 月无风险收益率_MonRFRet rf 
rename 年份_Year Year
rename 月份_Month Month

drop 日期_Date  

save "monthly rf\RF.dta", replace
export delimited "monthly rf\RF.csv", replace

// daily
import excel "daily rf\RESSET_BDDRFRET.xls", firstrow clear

rename 日期_Date date
rename 日无风险收益率_DRFRet rf

save "daily rf\RF.dta", replace
export delimited "daily rf\RF.csv", replace
