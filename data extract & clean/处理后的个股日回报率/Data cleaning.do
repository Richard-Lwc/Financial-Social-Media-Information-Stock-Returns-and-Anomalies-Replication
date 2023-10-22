************************  Data Cleaning   ************************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\处理后的个股日回报率"
import delimited "daily_return.csv", case(preserve) clear 
drop Markettype

// sum Dretwd
// 生成“YM"格式，方便与月末市值进行匹配
gen date = date(Trddt, "YMD")
format date %td

gen month = mofd(date)
format month %tm

// merge with Market Value
merge m:1 Stkcd month using "Total_Market_Value.dta", keep(match) nogen

// generate the number of monthly observations for each stock
bys Stkcd month: egen obs = count(Dretwd)

// 去极化，与原文数据最大最小值相匹配
winsor2 Dretwd, replace cuts(0.001, 99.996) trim
save "中间数据\1.dta", replace
export delimited "中间数据\1.csv", replace

// 将日度数据变为月度数据，生成滞后项(因为需要剔除上个月观测值不满...的数据)
collapse (first) obs, by(Stkcd month)
bys Stkcd: gen obs_m1 = obs[_n - 1]

// 生成过去12个月的观测值数目并删除不满12个月的数据
bys Stkcd: gen n = _n
rangestat (sum) yearly_obs=obs, interval(month -12 -1) by(Stkcd)
replace yearly_obs = . if n <= 12
drop n
save "中间数据\2.dta", replace

use "中间数据\1.dta", clear
merge m:1 Stkcd month obs using "中间数据\2.dta", keep(match) nogen

// 剔除市值最小30%的股票和上个月观测值小于7以及过去12个月交易日观测值小于120的股票
bys month: egen Msmvttl_p30 = pctile(Msmvttl), p(30)
drop if Msmvttl < Msmvttl_p30 | obs_m1 < 7 | yearly_obs < 120
sort Stkcd date
// 去掉2009年之前的样本
gen year = year(date)
drop if year < 2009

drop obs obs_m1 yearly_obs Msmvttl_p30 year

// merge m:1 Trddt using ".\dta\Cdretwd.dta", keep(match) nogen
drop if missing(Dretwd)
save "refined daily return.dta", replace
// 意思就是已经筛选过了的个股日回报率数据

export delimited using "refined daily return.csv", replace