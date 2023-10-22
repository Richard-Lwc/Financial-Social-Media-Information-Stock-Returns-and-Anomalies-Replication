*********************************   SUE    ************************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\SUE"

use "..\扣除非经常性损益净利润\netprfcut.dta", clear

gen end_date = date(Trdmnt, "YM")
format end_date %td

gen year = year(end_date)
gen quarter = quarter(end_date)
sort Stkcd quarter year
by Stkcd quarter: gen L4_Netprfcut = Netprfcut[_n - 1]


sort Stkcd end_date

// 计算净利润过去八个季度的标准差
by Stkcd: gen n = _n

rangestat (sd) sdensity=Netprfcut, interval(n -8 -1) by(Stkcd)
// 删除每个Stock前8条数据因为此时无法得到过去八个季度的标准差
drop if n <= 8

// SUE
gen SUE = (Netprfcut - L4_Netprfcut) / sdensity

keep Stkcd Trdmnt SUE

save "SUE.dta", replace
export delimited "SUE.csv", replace

