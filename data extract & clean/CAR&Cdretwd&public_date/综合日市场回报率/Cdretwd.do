**********************************   Cdretwd    *******************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\CAR&Cdretwd&public_date"
import delimited "综合日市场回报率\TRD_Cndalym.csv", case(preserve) clear 
// 53=沪深A股和创业板和科创板
keep if Markettype == 53
drop Markettype

save "Cdretwd.dta", replace
export delimited using "Cdretwd.csv", replace