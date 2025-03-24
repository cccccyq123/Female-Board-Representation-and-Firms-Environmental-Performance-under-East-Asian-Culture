//Endogeneity Concern Table1 By Region: Board Gender Diversity and Environmental Performance (the international sample).
use "intetnational female sample data.dta",clear
gen ln_escore=ln(escore+1)
gen l_size=ln(l_asset+1)
gen l_lnsale=ln(l_sale+1)
local control "l_size l_lnsale l_roa l_debt l_boardsize l_independent"
gen region=1
replace region=2 if NATION =="UNITED STATES"
replace region=3 if NATION =="CHINA"|NATION =="JAPAN"|NATION =="SOUTH KOREA"
reghdfe ln_escore l_FD $control, vce(cluster IndustryCode) absorb(i.year i.id),if region==2
outreg2 using Endogeneity_table1.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Firm FE, Yes,Year FE, Yes)
reghdfe ln_escore l_FD $control, vce(cluster nationcode) absorb(i.year i.id),if region==1
outreg2 using Endogeneity_table1.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Firm FE, Yes,Year FE, Yes)
reghdfe ln_escore l_FD $control, vce(cluster nationcode) absorb(i.year i.id),if region==3
outreg2 using Endogeneity_table1.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore) keep(ln_escore l_FD) addtext(Controls,Yes,Firm FE, Yes,Year FE, Yes)

//Endogeneity Concern Table2 Bartik IV - By Region: Board Gender Diversity and Environmental Performance (the international sample).
foreach r in 1 2 3 {
    di "Processing for region `r'..."
    
    * Filter data by region
    preserve
    keep if region == `r'
    
    * Generate instrumental variables (regional level)
    foreach var of varlist l_FD {
        bysort year regioncode: egen total_`var' = total(`var')
        bysort year regioncode: egen number`var' = count(`var')
        gen d`var' = total_`var' - `var'
        gen mean_`var' = d`var' / (number`var' - 1)
    }

    foreach var of varlist l_FD {
        xtset id year
        gen g_`var' = mean_`var' / l.mean_`var'
        sort id year
        bys id: gen n_`var' = _n
        replace g_`var' = 1 if n_`var' == 1
        bys id: gen `var'_start = `var'[1]
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

    foreach var of varlist l_FD {
        rangestat (product) g_`var', interval(year -5 0) by(id)
        gen iv`var' = `var'_start * product1
        drop product1
    }
    
    drop total_l_FD numberl_FD dl_FD mean_l_FD g_l_FD n_l_FD l_FD_start

    * First-stage regression
    reghdfe l_FD ivl_FD $control , absorb(i.IndustryCode i.year i.nationcode) cluster(nationcode)
    outreg2 using Endogeneity_table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(l_FD_region`r') keep(l_FD ivl_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

    * Second-stage regression
    ivreghdfe ln_escore $control (l_FD = ivl_FD), absorb(i.IndustryCode i.year i.nationcode) cluster(nationcode)
    outreg2 using Endogeneity_table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(ln_escore_region`r') keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

    * Generate instrumental variables (industry level)
    foreach var of varlist l_FD {
        bysort year IndustryCode: egen total_`var' = total(`var')
        bysort year IndustryCode: egen number`var' = count(`var')
        gen d`var' = total_`var' - `var'
        gen mean_`var' = d`var' / (number`var' - 1)
    }

    foreach var of varlist l_FD {
        xtset id year
        gen g_`var' = mean_`var' / l.mean_`var'
        sort id year
        bys id: gen n_`var' = _n
        replace g_`var' = 1 if n_`var' == 1
        bys id: gen `var'_start = `var'[1]
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

    foreach var of varlist l_FD {
        rangestat (product) g_`var', interval(year -5 0) by(id)
        gen iv`var'1 = `var'_start * product1
        drop product1
    }

    drop total_l_FD numberl_FD dl_FD mean_l_FD g_l_FD n_l_FD l_FD_start

    * First-stage regression
    reghdfe l_FD ivl_FD1 $control , absorb(i.IndustryCode i.year i.nationcode) cluster(nationcode)
    outreg2 using Endogeneity_table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(l_FD_region`r') keep(l_FD ivl_FD1) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

    * Second-stage regression
    ivreghdfe ln_escore $control (l_FD = ivl_FD1), absorb(i.IndustryCode i.year i.nationcode) cluster(nationcode)
    outreg2 using Endogeneity_table2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(ln_escore_region`r') keep(ln_escore l_FD) addtext(Controls,Yes,Country FE, Yes,Industry FE, Yes,Year FE, Yes)

    restore
}

//Table S2 By Country: Board Gender Diversity and Environmental Performance (the international sample).
gen region=1
replace region=2 if NATION =="UNITED STATES"
replace region=3 if NATION =="CHINA"
gen region==4 if NATION =="JAPAN"|NATION =="SOUTH KOREA"
foreach r in 1 2 3 4 {
    di "Processing for region `r'..."
    
    * Set clustering variable
    local cluster_var = cond(inlist(`r', 1, 4), "nationcode", "IndustryCode")
    
    * Set country fixed effects inclusion
    local country_fe = cond(inlist(`r', 1, 4), "Yes", "No")
    
    * Run regression
    reghdfe ln_escore l_FD $control, vce(cluster `cluster_var') absorb(i.year i.IndustryCode `=cond(`r'==1 | `r'==4, "i.nationcode", "")') if region==`r'
    
    * Export results
    outreg2 using table_s2.xlsx, nocon tstat bdec(3) tdec(2) ctitle(escore_region`r') keep(ln_escore l_FD) ///
        addtext(Controls,Yes,Country FE, `country_fe',Industry FE, Yes,Year FE, Yes)
}

//Table S3 Board Gender Diversity and Environmental Performance –Quantile Regression (the international sample).
gen region=1
replace region=2 if NATION =="UNITED STATES"
replace region=3 if NATION =="CHINA"|NATION =="JAPAN"|NATION =="SOUTH KOREA"
local quantiles 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9
local regions 1 2 3
foreach r in `regions' {
    foreach q in `quantiles' {
        qreg2 ln_escore l_FD $control i.year i.IndustryCode i.nationcode, cluster(nationcode) quantile(`q') if region == `r'
        outreg2 using table_s3.xlsx, nocon tstat bdec(3) tdec(2) append ///
            ctitle(escore) keep(ln_escore l_FD) ///
            addtext(Region, `r', Controls, Yes, Country FE, Yes, Industry FE, Yes, Year FE, Yes)
    }
}


//Table S4 Female Directors' Characteristics and Environmental Performance (the Chinese sample).
use "Chinese female sample data.dta",clear
gen ln_snsi=ln(snsiscore+1)
gen l_size=ln(l_asset+1)
gen l_lnsale=ln(l_sale+1)
local control "l_size l_lnsale l_roa l_debt l_boardsize l_independent"
foreach var in l_oldFD l_longFD l_conFD l_degreeFD{
    reghdfe ln_snsi `var' $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode) 
    outreg2 using table_s4.xlsx, nocon tstat bdec(3) tdec(2) ctitle(snsiscore) keep(ln_snsi `var') ///
        addtext(Controls, Yes, Industry FE, Yes, Year FE, Yes)
}

//Table S5 Board Gender Diversity and Environmental Activities (the Chinese sample).
gen ln_bloomberg=ln(bloomberg+1)
gen ln_invest=ln(invest+1)
gen ln_patent=ln(patent+1)
local dep_vars "ln_snsi ln_bloomberg ln_invest ln_patent ManageDiscl EmissionDiscl AbateDiscl ISO14001 report negative"
foreach var of local dep_vars {
    if "`var'" == "ln_snsi" | "`var'" == "ln_bloomberg" | "`var'" == "ln_invest" | "`var'" == "ln_patent" {
        reghdfe `var' l_FD $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode)
    }
    else {
        logit `var' l_FD $control i.year i.IndustryCode, vce(cluster IndustryCode)
    }
    outreg2 using table_s5.xlsx, nocon tstat bdec(3) tdec(2) append ctitle(`var') keep(`var' l_FD) ///
        addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
}

foreach var of local dep_vars {
    if "`var'" == "ln_snsi" | "`var'" == "ln_bloomberg" | "`var'" == "ln_invest" | "`var'" == "ln_patent" {
        reghdfe `var' l_FD3 $control, vce(cluster IndustryCode) absorb(i.year i.IndustryCode)
    }
    else {
        logit `var' l_FD3 $control i.year i.IndustryCode, vce(cluster IndustryCode)
    }
    outreg2 using table_s5.xlsx, nocon tstat bdec(3) tdec(2) append ctitle(`var') keep(`var' l_FD3) ///
        addtext(Controls,Yes,Industry FE, Yes,Year FE, Yes)
}
