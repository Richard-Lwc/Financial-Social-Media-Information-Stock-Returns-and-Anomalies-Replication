**********************  表3 金融社交媒体信息与市场异象   ***********************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "处理后的个股月超额收益率\refined monthly exret.dta", clear
// 百分比收益率
replace Ri = Ri * 100

merge 1:1 Stkcd Year Month using "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", keep(match) nogen

// merge with anomaly
merge 1:1 Stkcd Trdmnt using "ISKEW&IVOL&COSKEW\ISKEW&IVOL&COSKEW.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "VOL&MAX&SKEW&MIN\VOL&MAX&SKEW&MIN.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "TO\TO.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "EP\EP.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "BM\BM.dta", keep(match) nogen
merge 1:1 Stkcd Year Month using "TOVOL&TOMAX&TOMIN\TOVOL&TOMAX&TOMIN.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "AGE\AGE.dta", keep(match) nogen

// 按照FI进行分组
astile FI_rank = lag_FI, nq(10) by(Trdmnt)
replace FI_rank = 1 if FI_rank <= 3
replace FI_rank = 2 if FI_rank > 3 & FI_rank <=7
replace FI_rank = 3 if FI_rank > 7

// 对于每个FI组别，对各个异象因子进行十分位分组
local anomaly IVOL VOL MAX SKEW EP BM MIN TO TOVOL TOMAX TOMIN AGE
foreach var of varlist `anomaly'{
	astile `var'_rank = L1_`var' , nq(10) by(Trdmnt FI_rank)
}

save "Empirical Analysis\intermediate files\anomaly_rank.dta", replace

// 构建结果矩阵
clear matrix
matrix tbl = J(12, 16, .)
// 命名行
matrix rownames tbl = `anomaly'


forvalues i=1/12{
	local var: word `i' of `anomaly'
	use "Empirical Analysis\intermediate files\anomaly_rank.dta", clear
//	生成总市值加权平均超额收益率
	collapse (mean) RET = Ri [pw = lag_ME] , by(Year Month FI_rank `var'_rank)
	keep if inlist(`var'_rank, 1, 10)
	spread `var'_rank RET
	// 生成LFI, 2, HFI以及L-H
	gen HL = RET10 - RET1
	drop RET1 RET10
	spread FI_rank HL
	gen HL4 = HL1 - HL3
	// merge with CH3
	merge m:1 Year Month using "CH3&CH4\CH3.dta", keep(match) nogen
	gen t = _n
	tsset t
//	Long-Short
	forvalues j=1/4{
		qui newey HL`j' , lag(12)
	matrix tbl[`i', 2 * `j' - 1] = _b[_cons]
	matrix tbl[`i', 2 * `j'] = _b[_cons] / _se[_cons]
	}
	
//	CH4
	forvalues j=1/4{
		qui newey HL`j' mktrf SMB VMG, lag(12)
	matrix tbl[`i', 8 + 2 * `j' - 1] = _b[_cons]
	matrix tbl[`i', 8 + 2 * `j'] = _b[_cons] / _se[_cons]
	}
}

mat stars = J(12, 16, 0)
forvalues k = 1/12{
	forvalues v = 1(2)15{
		matrix stars[`k', `v'] = (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.1/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.05/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.01/2))
	}
}

frmttable using "Empirical Analysis\表7 金融社交媒体信息与市场异象.doc", statmat(tbl) title("Table 7") ctitle("", "Long-Short", "", "", "", "Alpha", "", "", "" \ "", "LFI", "2", "HFI", "L-H", "LFI", "2", "HFI", "L-H") multicol(1,2,4;1,6,4) substat(1) sdec(2) annotate(stars) asymbol(*, **, ***) landscape replace







 