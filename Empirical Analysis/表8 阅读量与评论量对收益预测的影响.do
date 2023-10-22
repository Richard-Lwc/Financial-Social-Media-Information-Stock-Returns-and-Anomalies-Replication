**********************  表3 金融社交媒体信息与市场异象   ***********************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "处理后的个股月超额收益率\refined monthly exret.dta", clear
// 百分比收益率
replace Ri = Ri * 100

merge 1:1 Stkcd Year Month using "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", keep(match) nogen

drop if missing(lag_read)
drop if missing(lag_comment)
// 按照read进行分组
astile read_rank = lag_read, nq(10) by(Trdmnt)

// 按照comment进行分组
astile comm_rank = lag_comment, nq(10) by(Trdmnt)


save "Empirical Analysis\intermediate files\read&comment_rank.dta", replace

// read_rank
// 生成总市值加权平均超额收益率
collapse (mean) RET = Ri [pw = lag_ME] , by(Year Month read_rank)
spread read_rank RET
// 多空组合收益
gen RET11 = RET10 - RET1

// merge with CH3&CH4
merge 1:1 Year Month using "CH3&CH4\CH3.dta", keep(match) nogen
merge 1:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen
gen t = _n
tsset t

// 构建结果矩阵
clear matrix
matrix tbl = J(11, 12, .)
matrix rownames tbl = "L" "2" "3" "4" "5" "6" "7" "8" "9" "H" "H-L"

forvalues i=1/11{
//	RET
	qui newey RET`i' , lag(12)
	matrix tbl[`i', 1] = _b[_cons]
	matrix tbl[`i', 2] = _b[_cons] / _se[_cons]
	
// 	CH3
	qui newey RET`i' mktrf SMB VMG, lag(12)
	matrix tbl[`i', 3] = _b[_cons]
	matrix tbl[`i', 4] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey RET`i' mktrf CH4_SMB CH4_VMG PMO , lag(12)
	matrix tbl[`i', 5] = _b[_cons]
	matrix tbl[`i', 6] = _b[_cons] / _se[_cons]
}


// comm_rank
// 生成总市值加权平均超额收益率
use "Empirical Analysis\intermediate files\read&comment_rank.dta", clear
collapse (mean) RET = Ri [pw = lag_ME] , by(Year Month comm_rank)
spread comm_rank RET
// 多空组合收益
gen RET11 = RET10 - RET1

// merge with CH3&CH4
merge 1:1 Year Month using "CH3&CH4\CH3.dta", keep(match) nogen
merge 1:1 Year Month using "CH3&CH4\CH4.dta", keep(match) nogen
gen t = _n
tsset t

forvalues i=1/11{
//	RET
	qui newey RET`i' , lag(12)
	matrix tbl[`i', 7] = _b[_cons]
	matrix tbl[`i', 8] = _b[_cons] / _se[_cons]
	
// 	CH3
	qui newey RET`i' mktrf SMB VMG, lag(12)
	matrix tbl[`i', 9] = _b[_cons]
	matrix tbl[`i', 10] = _b[_cons] / _se[_cons]
	
//	CH4
	qui newey RET`i' mktrf CH4_SMB CH4_VMG PMO , lag(12)
	matrix tbl[`i', 11] = _b[_cons]
	matrix tbl[`i', 12] = _b[_cons] / _se[_cons]
}

mat stars = J(11, 12, 0)
forvalues k = 1/11{
	forvalues v = 1(2)11{
		matrix stars[`k', `v'] = (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.1/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.05/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.01/2))
	}
}

frmttable using "Empirical Analysis\表8 阅读量与评论量对收益预测的影响.doc", statmat(tbl) title("Table 8") ctitle("", "Read", "", "", "Comment",  "", "" \ "", "RET", "CH3", "CH4", "RET", "CH3", "CH4") multicol(1,2,3;1,5,3) substat(1) sdec(2) annotate(stars) asymbol(*, **, ***) landscape replace



	









