cd "C:/Users/ASUS/Desktop/LEARN/金融建模/金融建模/INST"
clear
import delimited "INI_HolderSystematics.csv", encoding(UTF-8) 

rename symbol Stkcd
rename enddate Trddt
rename insinvestorprop INST

// 对缺失值取0
replace INST = 0 if missing( INST )

gen Trdmnt=reverse(substr(reverse(Trddt),4,.))
merge 1:1 Stkcd Trdmnt using"..\Stock Pool\stock pool.dta"
keep if _merge == 3
drop _merge

save "INST.dta", replace
export delimited "INST.csv", replace


