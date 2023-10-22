************************ 综合日市场回报率  *************************************
cd "C:\Users\ASUS\Nutstore\1\金融建模\ISKEW&IVOL&COSKEW"
import delimited "综合日市场回报率\TRD_Cndalym.csv", case(preserve) clear 
// Markettype [综合市场类型] - 5=沪深A股市场（不包含科创板、创业板）， 10=沪深B股市场， 15=沪深AB股市场， 21=沪深A股和创业板， 31=沪深AB股和创业板， 37=沪深A股和科创板， 47=沪深AB股和科创板， 53=沪深A股和创业板和科创板， 63=沪深AB股和创业板和科创板，33=上证A股和科创板，20=深证A股和创业板， 69=沪深京A股市场，79=沪深京AB股市场，85=沪深京A股和创业板，95=沪深京AB股和创业板， 101=沪深京A股和科创板， 111=沪深京AB股和科创板， 117=沪深京A股和创业板和科创板，127=沪深京AB股和创业板和科创板。
keep if Markettype == 53
drop Markettype
save "Cdretwd.dta", replace
export delimited "Cdretwd.csv", replace
