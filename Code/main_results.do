//Import intetnational sample data
use "intetnational female sample data.dta",clear

//Logarithmic processing
foreach var in escore emission resource innovation {
    gen ln_`var' = ln(`var' + 1)
}
gen l_size=ln(l_asset+1)
gen l_lnsale=ln(l_sale+1)

//Define control variables
local control "l_size l_lnsale l_roa l_debt l_boardsize l_independent"

//Table2 Board Gender Diversity and Environmental Performance (the international sample).
reg ln_escore l_FD,cluster(nationcode)
outreg2 using table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,No,Country FE, No,Industry FE, No,Year FE, No,Firm FE, No)
reg ln_escore l_FD $control ,cluster(nationcode)
outreg2 using table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, No,Industry FE, No,Year FE, No,Firm FE, No)
reghdfe ln_escore l_FD $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode)
outreg2 using table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes,Firm FE, No)


//Table3 By Region: Board Gender Diversity and Environmental Performance (the international sample).
gen region=1
replace region=2 if NATION =="UNITED STATES"
replace region=3 if NATION =="CHINA"|NATION =="JAPAN"|NATION =="SOUTH KOREA"
reghdfe ln_escore l_FD $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode),if region==2
outreg2 using table3.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, No,Industry FE, Yes,Year FE, Yes)
reghdfe ln_escore l_FD $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode),if region==1
outreg2 using table3.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)
reghdfe ln_escore l_FD $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode),if region==3
outreg2 using table3.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

//Table4 By Region: Board Gender Diversity (Other Measures) and Environmental Performance (the international sample).
gen l_fd1=0
replace l_fd1=1 if l_fnumber>0
gen l_fd3=0
replace l_fd3=1 if l_fnumber>=3
foreach var in l_fnumber l_fd1 l_fd3 {
    reghdfe ln_escore `var' $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode) if region==2
    outreg2 using table4.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore `var') ///
        addtext(Controls, Yes, Country FE, No, Industry FE, Yes, Year FE, Yes)
}
foreach var in l_fnumber l_fd1 l_fd3 {
    reghdfe ln_escore `var' $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode) if region==1
    outreg2 using table4.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore `var') ///
        addtext(Controls, Yes, Country FE, No, Industry FE, Yes, Year FE, Yes)
}
foreach var in l_fnumber l_fd1 l_fd3 {
    reghdfe ln_escore `var' $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode) if region==3
    outreg2 using table4.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore `var') ///
        addtext(Controls, Yes, Country FE, No, Industry FE, Yes, Year FE, Yes)
}

//Table5 By Region: Board Gender Diversity and Categorical Environmental Performance (the international sample).
foreach var in ln_emission ln_resource ln_innovation{
    foreach reg in 1 2 3 {
        if `reg' == 2 {
            reghdfe `var' l_FD $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode) if region==`reg'
            outreg2 using table5.xlsx, nocon tstat bdec(3) tdec(2) ctitle(`var') keep(`var' l_FD) ///
                addtext(Controls, Yes, Country FE, No, Industry FE, Yes, Year FE, Yes)
        }
        else {
            reghdfe `var' l_FD $control, vce(cluster nationcode) absorb(i.year i.IndustryCode i.nationcode) if region==`reg'
            outreg2 using table5.xlsx, nocon tstat bdec(3) tdec(2) ctitle(`var') keep(`var' l_FD) ///
                addtext(Controls, Yes, Country FE, Yes, Industry FE, Yes, Year FE, Yes)
        }
    }
}

//Table6 Personal Characteristics of Female Directors—Across Samples.
//Import intetnational female directors characteristics data
use "intetnational female characteristics data.dta",clear
gen region=1
replace region=0 if NATION =="CHINA"
foreach var in age tenure manager independent concurrent degree{
    ttest `var', by(region)
}

//Table7 Personal Characteristics of Female and Male Directors in China (the Chinese sample).
//Import Chinese directors characteristics data
use "Chinese directors data.dta",clear
foreach var in age tenure manager independent concurrent degree production finance{
    ttest `var', by(gender)
}

//Table8 Independent Female Board Representation and Environmental Performance (the Chinese sample).
//Import Chinese sample data
use "Chinese female sample data.dta",clear
gen ln_snsi=ln(snsiscore+1)
gen l_size=ln(l_asset+1)
gen l_lnsale=ln(l_sale+1)
local control "l_size l_lnsale l_roa l_debt l_boardsize l_independent"
foreach var in l_inFD l_inFDnumber l_inFD1 l_inFD2{
    reghdfe ln_snsi `var' $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode) 
    outreg2 using table8.xlsx, nocon tstat bdec(3) tdec(2) ctitle(snsiscore) keep(ln_snsi `var') ///
        addtext(Controls, Yes, Industry FE, Yes, Year FE, Yes)
}

//Table9 Bartik IV: Independent Female Board Representation and Environmental Performance (the Chinese sample).
//Generate instrumental variables(proince)
foreach var of varlist l_inFDnumber {
bysort year province:egen total_`var'=total(`var')
bysort year province:egen number`var'=count(`var')
gen d`var'=total_`var'-`var'
gen mean_`var'=d`var'/(number`var'-1)
}

foreach var of varlist l_inFDnumber {
xtset id year
gen g_`var'=mean_`var'/l.mean_`var'
sort id year
bys id:gen n_`var'=_n
replace g_`var'=1 if n_`var'==1
bys id:gen `var'_start=`var'[1]
}

mata:
mata clear
real rowvector product(real matrix X) {
  real rowvector product
  real scalar i
  
  product = X[1,]
  for (i = 2; i <= rows(X); i++) {
    product = product :* X[i,]
  }
  
  return(product)
}
end

foreach var of varlist l_inFDnumber {
rangestat (product) g_`var', interval(year -5 0) by(id)
gen iv`var'=`var'_start*product1
drop product1
}

//The first stage of regression
reghdfe l_inFDnumber ivl_inFDnumber $control ,absorb(i.IndustryCode i.year) cluster(IndustryCode)
outreg2 using table9.xlsx, nocon tstat bdec(3) tdec(2) ctitle(l_inFDnumber) keep(l_inFDnumber ivl_inFDnumber) addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
//The second stage of regression
ivreghdfe ln_snsi $control (l_inFDnumber= ivl_inFDnumber),absorb(i.IndustryCode i.year) cluster(IndustryCode)
outreg2 using table9.xlsx, nocon tstat bdec(3) tdec(2) ctitle(snsiscore) keep(ln_snsi l_inFDnumber) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

//Generate instrumental variables(industry)
foreach var of varlist l_inFDnumber {
bysort year IndustryCode:egen total_`var'=total(`var')
bysort year IndustryCode:egen number`var'=count(`var')
gen d`var'=total_`var'-`var'
gen mean_`var'=d`var'/(number`var'-1)
}

foreach var of varlist l_inFDnumber {
xtset id year
gen g_`var'=mean_`var'/l.mean_`var'
sort id year
bys id:gen n_`var'=_n
replace g_`var'=1 if n_`var'==1
bys id:gen `var'_start=`var'[1]
}

mata:
mata clear
real rowvector product(real matrix X) {
  real rowvector product
  real scalar i
  
  product = X[1,]
  for (i = 2; i <= rows(X); i++) {
    product = product :* X[i,]
  }
  
  return(product)
}
end

foreach var of varlist l_inFDnumber {
rangestat (product) g_`var', interval(year -5 0) by(id)
gen iv`var'=`var'_start*product1
drop product1
}

//The first stage of regression
reghdfe l_inFDnumber ivl_inFDnumber $control ,absorb(i.IndustryCode i.year) cluster(IndustryCode)
outreg2 using table9.xlsx, nocon tstat bdec(3) tdec(2) ctitle(l_inFDnumber) keep(l_inFDnumber ivl_inFDnumber) addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
//The second stage of regression
ivreghdfe ln_snsi $control (l_inFDnumber= ivl_inFDnumber),absorb(i.IndustryCode i.year) cluster(IndustryCode)
outreg2 using table9.xlsx, nocon tstat bdec(3) tdec(2) ctitle(snsiscore) keep(ln_snsi l_inFDnumber) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

//Table10 Independent Female Board Representation and Environmental Activities (the Chinese sample).
gen ln_bloomberg=ln(bloomberg+1)
gen ln_invest=ln(invest+1)
gen ln_patent=ln(patent+1)

local dep_vars "ln_bloomberg ln_invest ln_patent ManageDiscl EmissionDiscl AbateDiscl ISO14001 report negative"
foreach var of local dep_vars {
    if "`var'" == "ln_bloomberg" | "`var'" == "ln_invest" | "`var'" == "ln_patent" {
        reghdfe `var' l_inFDnumber $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode)
    }
    else {
        logit `var' l_inFDnumber $control i.year i.IndustryCode, vce(cluster IndustryCode)
    }
    outreg2 using table10.xlsx, nocon tstat bdec(3) tdec(2) append ctitle(`var') keep(`var' l_inFDnumber) ///
        addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
}

foreach var of local dep_vars {
    if  "`var'" == "ln_bloomberg" | "`var'" == "ln_invest" | "`var'" == "ln_patent" {
        reghdfe `var' l_inFD2 $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode)
    }
    else {
        logit `var' l_inFD2 $control i.year i.IndustryCode, vce(cluster IndustryCode)
    }
    outreg2 using table10.xlsx, nocon tstat bdec(3) tdec(2) append ctitle(`var') keep(`var' l_inFD2) ///
        addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
}

//Table11 Heterogeneity: Independent Female Board Representation and Environmental Performance (the Chinese sample).
local vars "l_inFDnumber l_inFD2"
local conditions "polluting state concentrated longyear"
local values "0 1"

foreach var of local vars {
    foreach cond of local conditions {
        foreach val of local values {
            reghdfe ln_snsi `var' $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode) if `cond'==`val'
            outreg2 using table11.xlsx, nocon tstat bdec(3) tdec(2) ctitle(snsiscore) keep(ln_snsi `var') ///
                addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)
        }
    }
}
