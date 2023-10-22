**************************  表3 单变量分组统计   **************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "处理后的个股月超额收益率\refined monthly exret.dta", clear
// 百分比收益率
replace Ri = Ri * 100
// 与FI merge
merge 1:1 Stkcd Year Month using "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", keep(match) nogen
drop if missing(lag_FI)
// 按照FI进行分组
astile rank = lag_FI, nq(10) by(Trdmnt)

save "Empirical Analysis\intermediate files\ranked_exret.dta", replace
// Value_weighted
collapse (mean) RET=Ri [pw=lag_ME], by(Year Month rank)
// 长表变宽表
spread rank RET
// 生成H-L
gen RET11 = RET10 - RET1

merge m:1 Year Month using "CH3&CH4\CH3.dta", keep(match) nogen
merge m:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen

// 生成时间变量
gen t = _n
tsset t

clear matrix
matrix tbl = J(11, 12, .)
// 命名行
matrix rownames tbl = "L" "2" "3" "4" "5" "6" "7" "8" "9" "H" "H-L"


forvalues i=1/11{
//	Value_weighted
//	RET
	qui newey RET`i' , lag(24)
	matrix tbl[`i', 1] = _b[_cons]
	matrix tbl[`i', 2] = _b[_cons] / _se[_cons]
	
// 	CH3
	qui newey RET`i' mktrf SMB VMG, lag(24)
	matrix tbl[`i', 3] = _b[_cons]
	matrix tbl[`i', 4] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey RET`i' mktrf CH4_SMB CH4_VMG PMO , lag(24)
	matrix tbl[`i', 5] = _b[_cons]
	matrix tbl[`i', 6] = _b[_cons] / _se[_cons]
}


// Equal_weighted
use "Empirical Analysis\intermediate files\ranked_exret", clear
collapse (mean) RET=Ri, by(Year Month rank)

// 长表变宽表
spread rank RET
// 生成H-L
gen RET11 = RET10 - RET1

merge m:1 Year Month using "CH3&CH4\CH3.dta", keep(match) nogen
merge m:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen

// 生成时间变量
gen t = _n
tsset t


forvalues i=1/11{
//	Equal_weighted
//	RET
	qui newey RET`i' , lag(24)
	matrix tbl[`i', 7] = _b[_cons]
	matrix tbl[`i', 8] = _b[_cons] / _se[_cons]
	
//	CH3
	qui newey RET`i' mktrf SMB VMG, lag(24)
	matrix tbl[`i', 9] = _b[_cons]
	matrix tbl[`i', 10] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey RET`i' mktrf CH4_SMB CH4_VMG PMO , lag(24)
	matrix tbl[`i', 11] = _b[_cons]
	matrix tbl[`i', 12] = _b[_cons] / _se[_cons]
}

mat list tbl
mat stars = J(11, 12, 0)
forvalues k = 1/11{
	forvalues v = 1(2)11{
		matrix stars[`k', `v'] = (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.1/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.05/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.01/2))
	}
}

frmttable using "Empirical Analysis\表三 单变量分组统计.doc", statmat(tbl) title("Table 3") ctitle("", "Value_weighted", "", "", "Equal_weighted",  "", "" \ "", "RET", "CH3", "CH4", "RET", "CH3", "CH4") multicol(1,2,3;1,5,3) vl({0}1000) substat(1) sdec(2) annotate(stars) asymbol(*, **, ***) landscape replace

 