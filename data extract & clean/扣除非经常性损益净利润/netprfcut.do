********************    扣非净利润      ***************************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\扣除非经常性损益净利润"
import delimited "扣非净利润.csv",  case(preserve) clear

rename Enddt Trdmnt
drop if missing(Stkcd)

sort Stkcd Trdmnt
 
save "netprfcut.dta",replace