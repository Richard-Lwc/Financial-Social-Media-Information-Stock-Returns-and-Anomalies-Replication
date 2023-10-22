**************************   AGE   *********************************************
// Stkcd [证券代码] - 以上交所、深交所公布的证券代码为准
// Stknme [证券简称] - 以交易所公布的中文简称为准
// Listdt [上市日期] - 以YYYY-MM-DD表示，上市日期为此股票证券代码的上市日期.

cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\AGE"
import delimited "上市日期\TRD_Co.csv", case(preserve) clear

// 特殊情况
// 上海医药AGE是负的，查询发现是因为在2010年重新上市，因此要转换为原始上市日期：1994-03-24
// 600849是上海医药曾经的代码，在2010年以前一直是沪深300指数的成分股。
//
// 但是，在现今的Wind终端或Wind数据库中，都找不到600849这个代码对应的数据。
// 因为这只股票转换了代码，在Wind数据库中原600849的所有数据（包括行情、财务指标等）都被601607直接继承了。查询历史上600849的数据，都必须转为查询601607。

replace Listdt = "1994-03-24" if Stkcd == 601607
// 生成上市年月变量
gen IPO_date = date(Listdt, "YMD")

gen IPO_ym = mofd(IPO_date)
format IPO_ym %tm

// Merge with Stock Pool
merge 1:m Stkcd using "..\Stock Pool\stock pool.dta", keep(match) nogen

gen date = date(Trdmnt, "YM")

gen ym = mofd(date)
format ym %tm
// 用当前年月减去上市年月得到AGE变量
gen AGE = ym - IPO_ym
gen L1_AGE = AGE - 1
sort Stkcd Trdmnt
keep Stkcd Trdmnt AGE L1_AGE


save "AGE.dta", replace
export delimited "AGE.csv", replace





