# Econometrics-US-Wages-IPUMS
# Wage and Salary Income Among Immigrants in the US (2019-2023)

## Overview
This repository contains an econometric analysis exploring how arrival timing, English proficiency, and citizenship status affect the hourly wages of immigrants in the United States. The analysis specifically captures the labor market dynamics surrounding the COVID-19 shock (2019-2023). 

This project was developed as part of the Econometrics course during my academic studies and demonstrates proficiency in handling large microdata sets, applying Ordinary Least Squares (OLS) regressions, and conducting robustness checks.

## Research Question
Do immigrants face systematic wage penalties based on their arrival cohort, and how do integration factors (such as English proficiency and citizenship) mitigate these penalties over time?

## Data Source
The empirical analysis utilizes microdata from **IPUMS USA** (Multi-Year American Community Survey, 2019-2023). The final sample includes over 1,000,000 observations of prime-age workers reporting positive wage and salary income.

* **Disclaimer on Data Reproducibility:** Due to IPUMS terms of use and data redistribution policies, the raw `.dta` dataset is not included in this repository. However, the provided STATA `.do` file contains all the necessary data cleaning, variable transformation, and estimation steps to fully replicate the results if you have access to the IPUMS database.

## Methodology & Tools
* **Software:** STATA
* **Model:** Log-linear OLS regression.
* **Econometric Diagnostics:** * Addressed heteroskedasticity using robust standard errors.
  * Assessed multicollinearity (VIF tests), leading to the exclusion of the highly collinear `years_in_us` variable in favor of categorical arrival period dummies.
* **Robustness Checks:** The baseline model was re-estimated by restricting the sample to prime-age workers (25-54) and applying alternative binary restrictions for language proficiency.

## Key Findings
1. **The "Pandemic Penalty":** Recent arrivals, particularly the 2020-2023 pandemic cohort, face a significant wage penalty compared to earlier cohorts, reflecting disrupted job matching during the COVID-19 shock.
2. **Human Capital & Integration:** English proficiency and U.S. citizenship are strongly and positively associated with higher hourly earnings.
3. **Demographics:** Education and age positively impact wages, while a persistent gender wage gap remains among the immigrant workforce.

## Repository Structure
* `/report` : Contains the final project paper (`group_12.pdf`) with theoretical framework, summary statistics, and regression tables.
* `/code` : Contains the STATA `.do` file used for data cleaning and econometric analysis.
* `/results` : Contains the STATA `.log` file with the raw regression outputs.
