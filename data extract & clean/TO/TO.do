**************************   TO   *********************************************
// monthly turnover
// Stkcd [证券代码] - 以交易所公布的证券代码为准。
// Trdmnt [交易月份] - 以YYYY-MM表示
// ToverOsM [月换手率(流通股数)(%)] - 计算公式为：月内日换手率（流通股数）之和
// ToverTlM [月换手率(总股数)(%)] - 计算公式为：月内日换手率（总股数）之和

// 采用[月换手率(总股数)(%)]
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\TO"
import delimited "个股月换手率\LIQ_TOVER_M.csv", case(preserve) clear

rename ToverTlM TO
replace TO = TO / 100
bys Stkcd: gen L1_TO = TO[_n - 1]
gen ym = date(Trdmnt, "YM")
gen Year = year(ym)
gen Month = month(ym)

drop ToverOsM ym

save "TO.dta", replace
export delimited "TO.csv", replace

