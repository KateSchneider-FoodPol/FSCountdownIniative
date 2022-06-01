import delimited using "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\LowPay.csv", clear
describe
foreach v in ref_area indicator source sex time {
	tab `v'
}
ren ref_area country_code
unique country_code
	* Note, only have data for 68 countries
preserve
	import delimited using "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\World Bank Classifications CSV FILE.csv", clear
	drop if country_code==""
	unique country_code
	tempfile wbclass
	save `wbclass', replace
restore
merge m:1 country_code using `wbclass'
tab country_code if _merge==2

lab var obs_value "Proportion of total employment earning low pay (less than two-thirs of median hourly earnings)"
tab time
unique country_code if obs_value!=., by(time)
drop if time==.
drop _merge source note_indicator note_source _Unique
reshape wide obs_value, i(country_code sex) j(time)

gen lowpay_mostrecent=.
replace lowpay_mostrecent=obs_value2020 if lowpay_mostrecent==. & obs_value2020!=.
replace lowpay_mostrecent=obs_value2019 if lowpay_mostrecent==. & obs_value2019!=.
replace lowpay_mostrecent=obs_value2018 if lowpay_mostrecent==. & obs_value2018!=.
replace lowpay_mostrecent=obs_value2017 if lowpay_mostrecent==. & obs_value2017!=.
replace lowpay_mostrecent=obs_value2016 if lowpay_mostrecent==. & obs_value2016!=.
replace lowpay_mostrecent=obs_value2015 if lowpay_mostrecent==. & obs_value2015!=.
replace lowpay_mostrecent=obs_value2014 if lowpay_mostrecent==. & obs_value2014!=.
replace lowpay_mostrecent=obs_value2013 if lowpay_mostrecent==. & obs_value2013!=.
replace lowpay_mostrecent=obs_value2012 if lowpay_mostrecent==. & obs_value2012!=.
replace lowpay_mostrecent=obs_value2011 if lowpay_mostrecent==. & obs_value2011!=.
replace lowpay_mostrecent=obs_value2010 if lowpay_mostrecent==. & obs_value2010!=.
reshape long obs_value, i(country_code sex) j(time)

unique country_code if lowpay_mostrecent!=. // 65 countries have data point 2010 or later
gen mostrecent_tag=0
replace mostrecent_tag=1 if lowpay_mostrecent==obs_value & obs_value!=.
tab time if mostrecent_tag==1
unique country_code sex if mostrecent_tag==1
tab sex
encode sex, gen(sex_num)
tab sex_num
drop if sex_num==3
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

* Summary stat tables - exported to excel manually:
tabstat lowpay_mostrecent if lowpay_mostrecent!=., stats(mean p50 sd) by(wb_region)
	// N countries:
	unique country_code if lowpay_mostrecent!=., by(wb_region)
tabstat lowpay_mostrecent if lowpay_mostrecent!=., stats(mean p50 sd) by(incomegroup_num)
	// N countries:
	unique country_code if lowpay_mostrecent!=., by(incomegroup_num)
	tab country_code if incomegroup_num==. & lowpay_mostrecent!=.

* Boxplots by sex
graph box lowpay_mostrecent, over(sex_num, label(labsize(vsmall))) over(wb_region, label(labsize(tiny) angle(45)))  ytitle("% Population") title("Percent of the population earning low pay, by sex") subtitle("Low pay defined (by ILO) as two-thirds median hourly wage or below") note("Data come from 2010-2020, single most recent data point per country included.", size(tiny) position(7)) asyvars legend(size(vsmall) position(2) ring(-5) col(1) symxsize(.75) symysize(.5))
graph export "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\lowpay_bysex-region.png", replace
	
save "C:\Users\kates\OneDrive - Johns Hopkins\FSCI\Data team\Data Analysis Workstream\lowpay", replace

