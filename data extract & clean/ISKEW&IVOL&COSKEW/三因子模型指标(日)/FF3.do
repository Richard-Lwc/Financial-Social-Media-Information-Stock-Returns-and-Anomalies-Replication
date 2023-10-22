cd "C:\Users\ASUS\Nutstore\1\金融建模\ISKEW&IVOL&COSKEW"
import delimited "三因子模型指标(日)\STK_MKT_THRFACDAY", case(preserve) clear 

// P9714：沪深A股和创业板和科创板
keep if MarkettypeID == "P9714"
drop MarkettypeID
rename TradingDate Trddt

save "FF3.dta", replace
export delimited "FF3.csv", replace
