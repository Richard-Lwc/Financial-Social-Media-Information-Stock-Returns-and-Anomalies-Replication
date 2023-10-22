****************************  CAR  *********************************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\CAR&Cdretwd&public_date"

use "..\处理后的个股日回报率\refined daily return.dta", clear
//merge综合日市场回报率数据
merge m:1 Trddt using "Cdretwd.dta", keep(match) nogen
// 1:m是因为可能年报和第四季度报表是同时披露的，就会出现public_date的重合
merge 1:m Stkcd date using "public_date.dta"

// 去掉在daily_return中没有出现的数据
drop if _merge == 2
drop _merge

local startday -2
local endday 1

*估计期为窗口事件周围的startday-endday个交易日
gen end_date = date(Accper, "YMD")
format end_date %td
egen any_public = max(end_date !=.), by(Stkcd month)

bys Stkcd month: gen dateid = _n if any_public == 1

gen eventday = (end_date !=.) if any_public == 1  //事件日的eventday锁定为1
replace eventday = dateid if eventday == 1  //事件日的eventday改为对应的dateid
egen tmp = sum(eventday), by(Stkcd month)  //将该dateid拓展到全体tmp变量里
replace dateid = dateid - tmp  //核心！计算所有观测值距离事件日的距离(只算交易日)
gen estimate_window = (dateid >= `startday' & dateid <= `endday')  //估计窗口赋值

// 删除没有公告的月份以及剔除计算CAR时需要用到t + 1月数据的月份)
egen window_length = sum(estimate_window), by(Stkcd month)
keep if window_length == 4 & estimate_window == 1

// 计算CAR
gen AR = Dretwd - Cdretwdtl
bys Stkcd month: egen CAR = sum(AR)

keep Stkcd date end_date CAR 
keep if end_date !=.

// 生成年月变量，方便匹配, 并取每一个月的最新公告日作为当月的CAR
gen Year = year(date)
gen Month = month(date)
bys Stkcd Year Month: keep if _n == _N

// Save
sort Stkcd end_date
save "CAR.dta", replace
export delimited using "CAR.csv", replace
