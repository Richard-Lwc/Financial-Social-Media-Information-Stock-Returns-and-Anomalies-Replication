cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\处理后的个股日回报率"
clear
import delimited "月末总市值\TRD_Mnth.csv", case(preserve)

gen date = date(Trdmnt, "YM")

gen month = mofd(date)
format month %tm
drop date

save "Total_Market_Value.dta", replace
export delimited "Total_Market_Value.csv", replace

