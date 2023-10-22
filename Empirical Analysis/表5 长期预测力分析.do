**************************  表5 单变量分组统计   **************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "处理后的个股月超额收益率\refined monthly exret.dta", clear
// 百分比收益率
replace Ri = Ri * 100
sort Stkcd Trdmnt
forvalues i=1/12{
	bys Stkcd: gen L`i' = Ri[_n + `i'] 
}

forvalues i=1/12{
	bys Stkcd: gen L`i'_MV = lag_ME[_n + `i'] 
}
// 与FI merge
merge 1:1 Stkcd Year Month using "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", keep(match) nogen
drop if missing(lag_FI)
// 按照FI进行分组
astile rank = lag_FI, nq(10) by(Trdmnt)
// 只保存High和Low组别
keep if inlist(rank, 1, 10)
save "Empirical Analysis\intermediate files\H and L.dta", replace
export delimited "Empirical Analysis\intermediate files\H and L.csv", replace

// 跳转到R，进行总市值加权平均超额收益计算

// 计算收益平均值和标准差
local RET L1 L2 L3 L4 L5 L6 L7 L8 L9 L10 L11 L12
// Value_weighted
use "Empirical Analysis\intermediate files\value_weighted_HL.dta", replace

// 分时，生成H-L收益
gather `RET', variable("period") value("RET")
spread rank RET
gen HL = RET10 - RET1

drop RET1 RET10

// 宽表变长表
spread period HL

merge 1:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen

forvalues i=1/12{
	gen L`i'_mktrf = mktrf[_n + `i']
	gen L`i'_CH4_SMB = CH4_SMB[_n + `i']
	gen L`i'_CH4_VMG = CH4_VMG[_n + `i']
	gen L`i'_PMO = PMO[_n + `i']
}

// 生成时间变量
gen t = _n
tsset t

// 构建结果矩阵
clear matrix
matrix tbl = J(12, 8, .)
// 命名行
matrix rownames tbl = "t+2" "t+3" "t+4" "t+5" "t+6" "t+7" "t+8" "t+9" "t+10" "t+11" "t+12" "t+13"

forvalues i=1/12{
//	Value_weighted
//	H-L
	qui newey L`i' , lag(24)
	matrix tbl[`i', 1] = _b[_cons]
	matrix tbl[`i', 2] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey L`i' L`i'_mktrf L`i'_CH4_SMB L`i'_CH4_VMG L`i'_PMO , lag(24)
	matrix tbl[`i', 3] = _b[_cons]
	matrix tbl[`i', 4] = _b[_cons] / _se[_cons]
}


// Equal_weighted
use "Empirical Analysis\intermediate files\H and L.dta", clear
collapse (mean) `RET', by(Year Month rank)

// 分时，生成H-L收益
gather `RET', variable("period") value("RET")
spread rank RET
gen HL = RET10 - RET1

drop RET1 RET10

// 宽表变长表
spread period HL

merge 1:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen

forvalues i=1/12{
	gen L`i'_mktrf = mktrf[_n + `i']
	gen L`i'_CH4_SMB = CH4_SMB[_n + `i']
	gen L`i'_CH4_VMG = CH4_VMG[_n + `i']
	gen L`i'_PMO = PMO[_n + `i']
}

// 生成时间变量
gen t = _n
tsset t



forvalues i=1/12{
//	Equal_weighted
//	H-L
	qui newey L`i' , lag(24)
	matrix tbl[`i', 5] = _b[_cons]
	matrix tbl[`i', 6] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey L`i' L`i'_mktrf L`i'_CH4_SMB L`i'_CH4_VMG L`i'_PMO , lag(24)
	matrix tbl[`i', 7] = _b[_cons]
	matrix tbl[`i', 8] = _b[_cons] / _se[_cons]
}

mat list tbl
mat stars = J(12, 8, 0)
forvalues k = 1/12{
	forvalues v = 1(2)7{
		matrix stars[`k', `v'] = (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.1/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.05/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.01/2))
	}
}

frmttable using "Empirical Analysis\表五 长期预测力分析.doc", statmat(tbl) title("Table 5") ctitle("", "Value_weighted", "", "Equal_weighted", "" \ "", "H-L",  "Alpha", "H-L", "Alpha") multicol(1,2,2;1,4,2) substat(1) sdec(2) annotate(stars) asymbol(*, **, ***) landscape replace






