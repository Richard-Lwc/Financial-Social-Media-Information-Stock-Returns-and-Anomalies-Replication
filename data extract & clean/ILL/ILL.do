**************************   ILL   *********************************************
// Stkcd [证券代码] - 以交易所公布的证券代码为准。
// Trdmnt [交易月份] - 以YYYY-MM表示
// ILLIQ_M [ILLIQ_M] - 详见计算公式

cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\ILL"
import delimited "ILL非流动性指标\LIQ_AMIHUD_M.csv", case(preserve) clear

// Merge with Stock Pool
merge 1:1 Stkcd Trdmnt using "..\Stock Pool\stock pool.dta", keep(match) nogen

rename ILLIQ_M ILL

save "ILL.dta", replace
export delimited "ILL.csv", replace