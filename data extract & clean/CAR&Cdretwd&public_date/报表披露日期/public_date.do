cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\CAR&Cdretwd&public_date"
import delimited "报表披露日期\IAR_Forecdt.csv", case(preserve)

gen date = date(Actudt, "YMD")
gen week = dow(date)
// 若公告日不是交易日，则周六减一天，周日加一天（并没有周日）
replace date = date - 1 if week == 6
// replace date = date + 1 if week == 0
format date %td

drop Stknme Actudt week

save "public_date.dta", replace
export delimited "public_date.csv", replace

