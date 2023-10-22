cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\ME"
clear
import delimited "月末总市值\TRD_Mnth.csv", case(preserve)

// Stkcd [证券代码] - 以上交所、深交所公布的证券代码为准
// Trdmnt [交易月份] - 以YYYY-MM表示
// Msmvttl [月个股总市值] - 个股的发行总股数与月收盘价的乘积。计算公式为：个股的发行总股数与月收盘价的乘积，A股以人民币元计，上海B股以美元计，深圳B股以港币计，注意单位是千

// gen date = date(Trdmnt, "YM")
//
// gen month = mofd(date)
// format month %tm
// drop date

replace Msmvttl = Msmvttl * 1000
gen Log_ME = log(Msmvttl)

sort Stkcd Trdmnt
by Stkcd: gen lag_ME = Msmvttl[_n - 1]

save "ME.dta", replace
export delimited "ME.csv", replace

