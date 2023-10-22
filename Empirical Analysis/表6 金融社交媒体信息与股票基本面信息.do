******************  表6 金融社交媒体信息与股票基本面信息   ********************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", clear
// 求百分比
replace FI = 100 * FI
// 更新股票池
merge m:1 Stkcd Year Month using "Stock Pool\stock pool.dta", keep(match) nogen

// Merge with CAR and SUE
merge 1:1 Stkcd Year Month using "CAR&Cdretwd&public_date\CAR.dta", keepus(Year Month CAR)

drop if _merge == 2
drop _merge

merge 1:1 Stkcd Trdmnt using "SUE\SUE.dta"

drop if _merge == 2
drop _merge

// 向下补齐CAR与SUE的缺失值 
sort Stkcd Trdmnt
by Stkcd: carryforward CAR, replace
by Stkcd: carryforward SUE, replace

// 根据CAR与SUE，十分位与五分位组合
astile CAR_10=CAR, nq(10) by(Trdmnt)
astile CAR_5=CAR, nq(5) by(Trdmnt)
astile SUE_10=SUE, nq(10) by(Trdmnt)
astile SUE_5=SUE, nq(5) by(Trdmnt)

save "Empirical Analysis\intermediate files\CAR&SUE_rank.dta", replace

// 构建结果矩阵
clear matrix
matrix tbl = J(6, 4, .)
// 命名行列
matrix colnames tbl = "CAR" "t-stat" "SUE" "t-stat"
matrix rownames tbl = "D1" "D10" "D10-D1" "Q1" "Q5" "Q5-Q1"

// CAR十分位
drop if missing(CAR_10)
collapse (mean) FI, by(Year Month CAR_10)

spread CAR_10 FI
gen FI11 = FI10 - FI1
gen t = _n
tsset t

qui newey FI1 , lag(24)
matrix tbl[1, 1] = _b[_cons]
matrix tbl[1, 2] = _b[_cons] / _se[_cons]

qui newey FI10 , lag(24)
matrix tbl[2, 1] = _b[_cons]
matrix tbl[2, 2] = _b[_cons] / _se[_cons]

qui newey FI11 , lag(24)
matrix tbl[3, 1] = _b[_cons]
matrix tbl[3, 2] = _b[_cons] / _se[_cons]

// CAR五分位
use "Empirical Analysis\intermediate files\CAR&SUE_rank.dta", clear
drop if missing(CAR_5)
collapse (mean) FI, by(Year Month CAR_5)

spread CAR_5 FI
gen FI6 = FI5 - FI1
gen t = _n
tsset t

qui newey FI1 , lag(24)
matrix tbl[4, 1] = _b[_cons]
matrix tbl[4, 2] = _b[_cons] / _se[_cons]

qui newey FI5 , lag(24)
matrix tbl[5, 1] = _b[_cons]
matrix tbl[5, 2] = _b[_cons] / _se[_cons]

qui newey FI6 , lag(24)
matrix tbl[6, 1] = _b[_cons]
matrix tbl[6, 2] = _b[_cons] / _se[_cons]

// SUE十分位
use "Empirical Analysis\intermediate files\CAR&SUE_rank.dta", clear
drop if missing(SUE_10)
collapse (mean) FI, by(Year Month SUE_10)

spread SUE_10 FI
gen FI11 = FI10 - FI1
gen t = _n
tsset t

qui newey FI1 , lag(24)
matrix tbl[1, 3] = _b[_cons]
matrix tbl[1, 4] = _b[_cons] / _se[_cons]

qui newey FI10 , lag(24)
matrix tbl[2, 3] = _b[_cons]
matrix tbl[2, 4] = _b[_cons] / _se[_cons]

qui newey FI11 , lag(24)
matrix tbl[3, 3] = _b[_cons]
matrix tbl[3, 4] = _b[_cons] / _se[_cons]

// SUE五分位
use "Empirical Analysis\intermediate files\CAR&SUE_rank.dta", clear
drop if missing(SUE_5)
collapse (mean) FI, by(Year Month SUE_5)

spread SUE_5 FI
gen FI6 = FI5 - FI1
gen t = _n
tsset t

qui newey FI1 , lag(24)
matrix tbl[4, 3] = _b[_cons]
matrix tbl[4, 4] = _b[_cons] / _se[_cons]

qui newey FI5 , lag(24)
matrix tbl[5, 3] = _b[_cons]
matrix tbl[5, 4] = _b[_cons] / _se[_cons]

qui newey FI6 , lag(24)
matrix tbl[6, 3] = _b[_cons]
matrix tbl[6, 4] = _b[_cons] / _se[_cons]

// 添加显著性标识
mat list tbl
mat stars = J(6, 4, 0)
forvalues k = 1/6{
	forvalues v = 1(2)3{
		matrix stars[`k', `v'] = (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.1/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.05/2)) + (abs(tbl[`k', `v' + 1]) > invttail(`e(df_r)', 0.01/2))
	}
}

frmttable using "Empirical Analysis\表6 金融社交媒体信息与股票基本面信息.doc", statmat(tbl) title("Table 6") substat(1) sdec(2) annotate(stars) asymbol(*, **, ***) landscape replace


