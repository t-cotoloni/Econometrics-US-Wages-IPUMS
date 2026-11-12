# Wage and Salary Income Among Immigrants in the United States, 2019–2023

**How do arrival timing, English proficiency and citizenship relate to immigrants' hourly wages across the COVID-19 shock?**
An applied microeconometric analysis of more than one million immigrant workers from IPUMS USA microdata.

📄 **Full paper:** [Immigrant_Wages_US_2019-2023.pdf](report/Immigrant_Wages_US_2019-2023.pdf)

---

## Research question

Immigrants do not enter the US labour market on equal footing with native workers: at arrival they may face language barriers, limited knowledge of the local labour market and restricted access to some jobs. As they accumulate host-country experience, these disadvantages should shrink (earnings assimilation; Borjas, 2016). We ask:

* Do recent arrival cohorts, especially those who arrived during the pandemic, earn less than earlier cohorts?
* How are English proficiency and citizenship associated with hourly earnings, conditional on education, age and sex?

## Data

**IPUMS USA**, American Community Survey, multi-year sample covering 2019–2023. The unit of observation is the individual respondent.

* **Sample:** foreign-born individuals aged 18–65 with positive wage and salary income → **1,016,525 observations**.
* **Outcome:** log hourly wage, `ln(wage_hour)`, where `wage_hour = INCWAGE / (UHRSWORK × WKSWORK1)`.
* **Key variables:**
  * `period_cat`: arrival cohort from `YRIMMIG` (1946–1973 Golden Age, 1974–1994 Economic Stagnation, 1995–2007 Globalization, 2008–2019 Great Recession, 2020–2023 Pandemic).
  * `speakeng_cat`: English proficiency in four levels (does not speak English, speaks it poorly, speaks it well, speaks only English).
  * `citizen_dummy`: 1 for US citizens (born abroad of US parents or naturalized), 0 otherwise.
* **Controls:** education (`educ_cat`, four levels), age, sex.

> **The raw data are not included**, because the IPUMS terms of use do not allow redistribution. See *How to reproduce* below to create the extract.

## Methodology

* **Model:** log-linear OLS,

  ```
  ln(wage_hour)_i = β0 + β1·citizen_i + Σ δ_j·D(period_j)_i + Σ γ_k·D(speakeng_k)_i
                    + β2·educ_i + β3·female_i + β4·age_i + ε_i
  ```

  Coefficients are approximate percentage differences in hourly wages (log points).
* **Diagnostics:**
  * Breusch–Pagan test rejects homoskedasticity (χ² = 2,596.4, p < 0.001), so all models use **heteroskedasticity-robust standard errors**.
  * VIF analysis shows strong collinearity between years in the US and the arrival-cohort dummies (VIF up to 29), so `years_in_us` is dropped in favour of the cohort dummies.
* **Joint F-tests:** integration variables (cohort, English, citizenship) F(8, ·) = 1,676.7; controls (education, sex, age) F(3, ·) = 59,744.1. Both are significant at p < 0.001.
* **Robustness:** (i) prime-age workers only (25–54); (ii) a binary English-proficiency variable.

All analysis was carried out in **Stata**.

## Results

Dependent variable: log hourly wage. Robust standard errors in parentheses. Reference groups: arrived 1946–1973; does not speak English.

| | (1) Baseline | (2) Age 25–54 | (3) Binary English |
|---|---|---|---|
| Arrived 1974–1994 | 0.048*** (0.004) | 0.034*** (0.007) | 0.013*** (0.004) |
| Arrived 1995–2007 | 0.022*** (0.004) | 0.033*** (0.007) | −0.028*** (0.004) |
| Arrived 2008–2019 | −0.020*** (0.005) | −0.002 (0.007) | −0.079*** (0.004) |
| **Arrived 2020–2023 (pandemic)** | **−0.156*** (0.007)** | **−0.148*** (0.009)** | **−0.218*** (0.007)** |
| Speaks English poorly | −0.009* (0.005) | −0.006 (0.006) | |
| Speaks English well | 0.183*** (0.005) | 0.197*** (0.006) | |
| Speaks only English | 0.241*** (0.005) | 0.261*** (0.006) | |
| Speaks English (binary) | | | 0.145*** (0.005) |
| US citizen | 0.037*** (0.002) | 0.047*** (0.002) | 0.058*** (0.002) |
| Education | 0.403*** (0.001) | 0.402*** (0.001) | 0.423*** (0.001) |
| Female | −0.245*** (0.002) | −0.255*** (0.002) | −0.247*** (0.002) |
| Age | 0.010*** (0.000) | 0.011*** (0.000) | 0.009*** (0.000) |
| Observations | 1,016,525 | 722,115 | 1,016,525 |
| R² | 0.191 | 0.193 | 0.187 |

*\*\*\* p<0.01, \*\* p<0.05, \* p<0.10.*

### Key findings

* **Pandemic penalty.** Immigrants who arrived in 2020–2023 earn about **15% less per hour** than the 1946–1973 cohort, the largest and most robust cohort effect. This is consistent with earnings assimilation and with adverse entry conditions during COVID-19.
* **Language pays.** Speaking English well is associated with about **18% higher** hourly wages, and speaking only English with about **24% higher**, relative to not speaking English.
* **Citizenship premium.** Citizens earn about **4% more** than non-citizens with the same observable characteristics.
* **Gender gap.** Women earn about **24% less** per hour than men, conditional on the other variables.
* Results are stable when restricting to prime-age workers.

### Limitations

Estimates are **conditional correlations, not causal effects**. The data are repeated cross-sections, so cohort comparisons can be affected by selective return migration and delayed labour-market entry. Unobserved factors (ability, occupation, local labour markets) may correlate with integration measures. Citizenship in particular is not exogenous: it may reflect prior integration.

## How to reproduce

1. **Create the data extract** at [usa.ipums.org](https://usa.ipums.org) (free registration):
   * **Sample:** ACS multi-year file covering 2019–2023.
   * **Variables:** `SEX`, `AGE`, `CITIZEN`, `YRIMMIG`, `SPEAKENG`, `EDUC`, `EDUCD`, `WKSWORK1`, `UHRSWORK`, `INCWAGE`.
   * **Format:** Stata (`.dta`). Save it as `data_group_12.dta`.
2. **Set the path.** In `code/run_group_12.do`, change the folder in the `global main` line (and the `use` line in the project section) to the folder containing `data_group_12.dta`.
3. **Install the table package** (needed once): `ssc install estout`.
4. **Run** `code/run_group_12.do`. The output of the final run is in `result/log_group_12.txt`.

## Repository structure

```
├── code/
│   └── run_group_12.do                   # full analysis (single do-file)
├── report/
│   └── Immigrant_Wages_US_2019-2023.pdf  # project paper
├── result/
│   └── log_group_12.txt                  # log of the final run
└── README.md
```

## Authors

Group project for the course **Econometrics for Individual Data**, University of Bologna:
Olimpia Benelli, Carlotta Cosio, Tommaso Cotoloni.

## References

* Borjas, G. J. (2016). *Immigration Economics*. Harvard University Press.
* Chiswick, B. R. and Miller, P. W. (2007). *The Economics of Language: International Analyses*. Routledge.
* Bratsberg, B., Ragan, J. F. and Nasir, Z. M. (2002). "The Effect of Naturalization on Wage Growth: A Panel Study of Young Male Immigrants." *Journal of Labor Economics*, 20(3): 568–597.
* Ruggles, S. et al. *IPUMS USA*. Minneapolis, MN: IPUMS.
