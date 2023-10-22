********************************* CH3&CH4 **************************************
// CH3
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\CH3&CH4"
import delimited "CH_3_update_20211231.csv", case(preserve) clear 
// 将日期转化为Stata格式
tostring mnthdt, replace
gen date = date(mnthdt, "YMD")
gen Year = year(date)
gen Month = month(date)

drop rf_mon date mnthdt

save "CH3.dta", replace
export delimited "CH3.csv", replace

// CH4
import delimited "CH_4_fac_update_20211231.csv", case(preserve) clear 
// 将日期转化为Stata格式
tostring mnthdt, replace
gen date = date(mnthdt, "YMD")
gen Year = year(date)
gen Month = month(date)

drop rf_mon date mnthdt
rename VMG CH4_VMG
rename SMB CH4_SMB

save "CH4.dta", replace
export delimited "CH4.csv", replace

