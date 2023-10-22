cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\EP"

use  "..\ME\ME.dta", clear

//匹配净利润和总市值数据，由于净利润数据只有季度数据，只有3、6、9、12月数据被完全匹配
merge m:1 Stkcd Trdmnt using "..\扣除非经常性损益净利润\netprfcut.dta"

drop if _merge == 2

sort Stkcd Trdmnt
by Stkcd: carryforward Netprfcut, replace

generate EP = Netprfcut / Msmvttl

sort Stkcd Trdmnt
by Stkcd: gen L1_EP = EP[_n - 1]

keep Stkcd Trdmnt EP L1_EP

save "EP.dta",replace
export delimited "EP.csv", replace