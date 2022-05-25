import delimited using "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\InformalEmployment.csv", clear
describe
foreach v in ref_area indicator source sex time {
	tab `v'
}
ren ref_area country_code
unique country_code // data for 99 countries

preserve
	import delimited using "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\World Bank Classifications CSV FILE.csv", clear
	drop if country_code==""
	unique country_code
	tempfile wbclass
	save `wbclass', replace
restore
merge m:1 country_code using `wbclass'
tab country_code if _merge==2
lab var obs_value "Percent informal employment (thousands)"
tab time
unique country_code if obs_value!=., by(time)
drop if time==.
drop _merge source note_indicator note_source _Unique obs_status
* Keep only agriculture and total
keep if classif1=="ECO_AGGREGATE_AGR" | classif1=="ECO_AGGREGATE_TOTAL"
encode classif1, gen(econactivity)
drop classif1

tab time // 2019 most recent with best coverage

tab sex
encode sex, gen(sex_num)
tab sex_num
drop if inlist(sex_num,3,4)
lab def sex_num 1 "Female" 2 "Male", modify
lab val sex_num sex_num
lab var sex "Sex"

encode incgrp, gen(incomegroup_num)
tab incomegroup_num
tab incomegroup_num, nolabel
describe incomegroup_num
labellist incomegroup_num
recode incomegroup_num (1=5)
lab def incomegroup_num 5 "High income", modify
tab incomegroup_num

lab var wb_region "Region"
lab var incomegroup_num "Income group"

tab econactivity
lab def econactivity 1 "Agriculture" 2 "Total", modify
lab val econactivity econactivity

reshape wide obs_value, i(country_code sex_num time) j(econactivity) 
gen aginfpct=(obs_value1/obs_value2)*100
lab var aginfpct "Percentage of total informal employment in agricultural sector"

graph box aginfpct if time==2019, over(sex_num, label(labsize(vsmall))) over(incomegroup_num, label(labsize(vsmall) angle(45))) asyvars ytitle("% Informal Workforce") title("Percent of all informal employment working in agriculture, by country income level and sex", size(small)) subtitle("2019", size(vsmall)) legend(position(2) ring(-5) col(1) symxsize(.75) symysize(.5) )
graph export "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\aginf_bysex-region.png", replace
	
save "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\aginformal", replace
