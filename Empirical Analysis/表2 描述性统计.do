**************************   Descriptive Statistics   **************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模"
use "GUBA_上市公司股吧帖子统计（自然日）_ALL\FI.dta", clear
// merge with other datasets
merge 1:1 Stkcd Year Month using "TO\TO.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "ME\ME.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "EP\EP.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "BM\BM.dta", keep(match) nogen
// merge 1:1 Stkcd Trdmnt using "ILL\ILL.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "REV&MOM\REV&MOM.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "ISKEW&IVOL&COSKEW\ISKEW&IVOL&COSKEW.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "VOL&MAX&SKEW&MIN\VOL&MAX&SKEW&MIN.dta", keep(match) nogen
merge 1:1 Stkcd Year Month using "TOVOL&TOMAX&TOMIN\TOVOL&TOMAX&TOMIN.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "AGE\AGE.dta", keep(match) nogen
merge 1:1 Stkcd Trdmnt using "Stock Pool\stock pool.dta", keep(match) nogen


local percentage_v EP REV MOM IVOL VOL MAX MIN SKEW
foreach var of varlist `percentage_v'{
	replace `var' = `var' * 100
}
logout, save("Empirical Analysis\表二 描述性统计.doc") word replace:univar FI Log_ME EP BM TO REV MOM IVOL VOL MAX MIN TOMAX TOMIN TOVOL SKEW AGE, d(3) 


