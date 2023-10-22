*****************************        BM         ********************************
cd "C:\Users\ASUS\Desktop\LEARN\金融建模\金融建模\BM"

// 股东权益以及优先股数据
// Stkcd [证券代码] - 以沪、深、北证券交易所公布的证券代码为准。
// ShortName [证券简称] - 以沪、深、北证券交易所公布的证券简称为准。
// Accper [统计截止日期] - YYYY-MM-DD，前四位表示会计报表公布年度
// Typrep [报表类型] - 指上市公司的财务报表中反映的是合并报表或者母公司报表。"A＝合并报表"、"B＝母公司报表"。
// A003112101 [其中：优先股] - 优先股是相对于普通股而言的。主要指在利润分红及剩余财产分配的权利方面，优先于普通股。2015年起使用。
// A003000000 [所有者权益合计] - 股东权益各项目之合计。1990年起使用
import delimited "优先股以及所有者权益\FS_Combas.csv", case(preserve) clear
// 数据处理
*由于和ME数据中时间格式不一致，通过删掉日期后缀生成年月日期格式*
gen Trdmnt = reverse(substr(reverse(Accper),4,.))

drop Typrep ShortName
rename A003000000 equity
rename A003112101 preferred
// 对于优先股缺失的数据，采用向下fill的方式填补
sort Stkcd Trdmnt
by Stkcd: carryforward preferred, replace

*将剔除优先股的股东权益生成新变量账面价值*
gen BV = equity - preferred


save "BV.dta", replace

// 计算BM
use "..\ME\ME.dta", clear
merge 1:1 Stkcd Trdmnt using  "BV.dta"

// 账面市值为最近可获取的剔除优先股的股东权益，因此需要用前面的值填充缺失值
sort Stkcd Trdmnt
by Stkcd: carryforward BV, replace

*生成账面市值比并去掉小于等于0项*
generate BM = BV / Msmvttl
drop if BM <= 0

sort Stkcd Trdmnt
by Stkcd: gen L1_BM = BM[_n - 1]

keep Stkcd Trdmnt BM L1_BM

save "BM.dta", replace
export delimited "BM.csv", replace