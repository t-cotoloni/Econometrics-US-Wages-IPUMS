********************************************************************************
*                           Econometrics                                      *
*                           Group Projects                                    *
********************************************************************************

/* NOTE FOR STUDENTS:
   - Fill in: group number and main path.
   - Write your code ONLY in the proper section below.
   - For final submission, submit also a final log file.
*/

********************************************************************************
*** Do not touch this
********************************************************************************
local REPL = "$REPL_MODE"
if "`REPL'" == "" local REPL "0"

********************************************************************************
*** Insert only your group number and main path
********************************************************************************
if "`REPL'" == "0" {

    *** Clear everything
    cscript

    *** Insert your group number
    global groupn   "12"

    *** Insert your information
    if c(username) == "Acer" { 	// name of your PC: dis "`c(username)'"  
    global main "C:\Users\Acer\Desktop\group_12"     		// path where the main work folder is located	
    }

    *** Set current directory
    cd "${main}"
	
    *** Load your raw dataset
	use "${main}/data_group_$groupn.dta",replace
	
}

********************************************************************************
*** Project: write your code
********************************************************************************

clear all
use "C:\Users\Acer\Desktop\group_12\data_group_12.dta" 
describe

*****************************************************************************
* RESTRICTIONS ON THE DATA                                                  *
*****************************************************************************
drop educd

* We only want to study immigrants 
keep if yrimmig > 0   

* We generate a variable that is the number of years lived in the US 
gen years_in_us = 2023 - yrimmig

* Create categorical variable for yrimmig
gen period_cat = .
replace period_cat = 1 if yrimmig >= 1937 & yrimmig <= 1945  // "The Great Depression" (1929-1945) 
replace period_cat = 2 if yrimmig >= 1946 & yrimmig <= 1973  // "The Golden Age" (1945-1973)
replace period_cat = 3 if yrimmig >= 1974 & yrimmig <= 1994  // "Economic Stagnation" (1973-1994)
replace period_cat = 4 if yrimmig >= 1995 & yrimmig <= 2007  // "Globalization" (1994-2007)
replace period_cat = 5 if yrimmig >= 2008 & yrimmig <= 2019  // "The Great Recession" (2007-2019)
replace period_cat = 6 if yrimmig >= 2020                    // "The Pandemic" (2020-2023)
drop yrimmig

* Create categorical variable for speakeng
gen speakeng_cat = .
replace speakeng_cat = 1 if speakeng == 1                  // Does not speak english
replace speakeng_cat = 2 if speakeng == 6                  // Speaks not well
replace speakeng_cat = 3 if speakeng == 4 | speakeng == 5  // Speaks well
replace speakeng_cat = 4 if speakeng == 3                  // Speaks only english

* Create dummy for citizen
gen citizen_dummy = .
replace citizen_dummy = 0 if citizen == 3 | citizen == 4  // Not citizen 
replace citizen_dummy = 1 if citizen == 1 | citizen == 2  // Citizen
drop if !(citizen_dummy == 0 | citizen_dummy == 1)
drop citizen

* Create categorical variable for educ
gen educ_cat = . 
replace educ_cat = 0 if educ == 00 | educ == 01 | educ == 02  // N/A, Nursey school to grade 4, Grade 5-8 
replace educ_cat = 1 if educ == 03 | educ == 04               // Grade 9-10 (14-16 years)
replace educ_cat = 2 if educ == 05 |educ == 06                // Grade 11-12 (16-18 years)
replace educ_cat = 3 if educ == 07 | educ == 08 | educ == 10  // 1-4 Years of college 
replace educ_cat = 4 if educ == 11                            // 5+ Years of college
drop if educ_cat == 0
drop educ

* Create dummy for sex
gen sex_dummy = .
replace sex_dummy = 0 if sex == 1  // Male
replace sex_dummy = 1 if sex == 2  // Female
drop sex

* We only want to keep people from 18 to 65 years old
keep if age >= 18 & age <= 65

* We only want real value of income and not zero bc is a log lin model
keep if incwage > 0

* We generate the output variable that is the logarithm of income-wage per hour
gen hours_year = uhrswork * wkswork1  // We generate a variable that is "hours worked in a year"
drop wkswork1
drop uhrswork

keep if incwage > 0                   // We onlywanrt real value of income wage, not zero because is a log-lin model 

gen wage_hour = incwage / hours_year  // We generate the variable of the logarithm of income-wage per hour
gen ln_wage_hour = log(wage_hour)
drop incwage
drop hours_year

* Check all the restrictions and count the observations
describe

*****************************************************************************
* DESCRIPTIVE STATISTICS                                                    *
*****************************************************************************
sum ln_wage_hour years_in_us i.period_cat i.speakeng_cat educ_cat citizen_dummy sex_dummy age

reg ln_wage_hour years_in_us i.period_cat i.speakeng_cat educ_cat citizen_dummy sex_dummy age

*****************************************************************************
* CHECK HOMOSKEDASTICITY                                                    *
*****************************************************************************
* Breusch-Pagan / Cook-Weisberg test
estat hettest  // Strong evidence of Heteroskedasticity                       

*****************************************************************************
* CHECK MULTICOLLINEARITY                                                   *
*****************************************************************************
vif               // Strong multicollinearity with variable "years_in_us" 
drop years_in_us  // We only keep "period_cat" to solve multicollinearity problem

*****************************************************************************
* HYPOTESIS TESTING                                                         *
*****************************************************************************
reg ln_wage_hour i.period_cat i.speakeng_cat citizen_dummy educ_cat sex_dummy age, robust

* We are testing multiple exclusion restrictions
testparm i.period_cat i.speakeng_cat citizen_dummy  // Testing the key variables

test educ_cat sex_dummy age                         // Testing control variables
* If the f value > alfa (0.05) we reject the null hypotesis (H_0)

*****************************************************************************
* REGRESSION TABLE                                                          *
*****************************************************************************
ssc install estout
reg ln_wage_hour i.period_cat i.speakeng_cat citizen_dummy educ_cat sex_dummy age, robust
est store REGRESSION
esttab REGRESSION, ///
    cells(b(star fmt(3)) se(par fmt(3))) ///  
    star(* 0.10 ** 0.05 *** 0.01) ///         
    r2 ar2 ///                                
    label ///                                 
    title("REGRESSION_TAB")

*****************************************************************************
* Robustness Check                                                          *
*****************************************************************************
ssc install estout
reg ln_wage_hour i.period_cat i.speakeng_cat citizen_dummy educ_cat sex_dummy age, robust
est store ORIGINAL 

* Robustness Check 1: Restriction on Sample Size ("age" variable = 25-54 years)
reg ln_wage_hour i.period_cat i.speakeng_cat citizen_dummy educ_cat sex_dummy age if age >= 25 & age <= 54, robust
est store RESTRICTED_SAMPLE

* Robustness Check 2: Dummy Semplification of "speakeng_cat" variable
gen speakeng_dummy = .
replace speakeng_dummy = 0 if speakeng == 1                                                
replace speakeng_dummy = 1 if speakeng == 3 | speakeng == 4 | speakeng == 5 | speakeng == 6
reg ln_wage_hour i.period_cat speakeng_dummy citizen_dummy educ_cat sex_dummy age, robust
est store DUMMY_SEMPLIFICATION

* Robustness Check Table
esttab ORIGINAL RESTRICTED_SAMPLE DUMMY_SEMPLIFICATION, ///
cells(b(star fmt(3)) se(par fmt(3))) ///
star(* 0.10 ** 0.05 *** 0.01) ///
r2 ar2 ///
label ///
compress nogaps ///
mtitles("ORIGINAL" "RESTRICTED_SAMPLE" "DUMMY_SEMPLIFICATION")