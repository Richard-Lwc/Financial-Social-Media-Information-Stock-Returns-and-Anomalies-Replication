**************************   ISKEW&IVOL&COSKEW   *******************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\ISKEW&IVOL&COSKEW"
use "..\处理后的个股日回报率\中间数据\1.dta", clear
//merge FF3, Cdretwd and Risk free rate
merge m:1 Trddt using "FF3.dta", keep(match) nogen
merge m:1 Trddt using "Cdretwd.dta", keep(match) nogen
merge m:1 date using "..\Risk free rate\daily rf\RF.dta", keep(match) nogen

// 超额收益
gen Ri = Dretwd - rf
gen Rm = Cdretwdtl - rf
sort Stkcd date

// 分组回归后取残差
cap program drop 	get_residual
program define get_residual
	reg Ri RiskPremium2 SMB2 HML2
		predict residual, residual
end

runby get_residual, by(Stkcd month) status

save "ff3_residual.dta", replace
export delimited "ff3_residual.csv", replace


