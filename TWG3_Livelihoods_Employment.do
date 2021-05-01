/* 
Title: Code employment in agri-food figure for livelihoods working group
Project: FSCR2030, 2021 manuscript
Author: Kate Schneider
Created: 1 May 2021
Last modified: 1 May 2021
*/

* Working directory
global data "C:\Users\kates\OneDrive - Johns Hopkins\FS Countdown Data Team\1_Raw data"
global saveto "C:\Users\kates\OneDrive - Johns Hopkins\FS Countdown Data Team\2_Working folder_Data & analysis\TWG_3"
clear

* Part 1: Number of workers
// Import data
import delimited using "$data\Thurlow_2021_AgEmp_Numbers"

// Label variables
lab var tot "Total economy/employment"
lab var afs "Agri-food system"
lab var agr "Primary agriculture"
lab var prc "Agro-processing (food, beverages, tobacco, cotton yarn, timber products)"
lab var inp "Domestic input supply"
lab var inp_agr "Inputs used in primary agriculture"
lab var inp_prc "Inputs used in agro-processing"
lab var trd "Trade and transport services"
lab var trd_agr "Trade and transport of primary agricultural products"
lab var trd_prc "Trade and transport of primary agroprocessing products"
lab var hfs "Hotels and food services"
lab var ind "Industrial sectors (incl. manufacturing)"
lab var man "Manufacturing sectors"
lab var srv "Services"

// Convert from thousands to millions
foreach v of varlist tot-srv {
	replace `v'=`v'/1000
	}

// Inspect data
sum 
egen worldtotal=sum(tot)
egen worldafs=sum(afs)
sum world*
distinct country_name
tab region
tab country_code, sum(year)
tab year
tab2 region year if year<2015

	/* Data note:
		98 countries: total workforce of 2.9 billion
		Total agri-food: 1.1 billion
	* Number of countries by region:
		East Asia & Pacific: 18 
		East and Central Asia: 33 **China not included
		Latin America & Carribbean: 10
		Middle East & North Africa: 8
		North America: 2
		South Asia: 7
		Sub-Saharan Africa: 20
	* Year of data: most 2015 (67%), 14% older, 18% more recent
		86% of data are from 2015 and later
		N countries with old data by region:
			East Asia & Pacific: 2012 (2), 2014 (1)
			Latin America: 2012 (1)
			South Asia: 2011 (2), 2014 (2)
			Sub-Saharan Africa: 2006 (1), 2007 (3), 2012 (1), 2014 (1)
	*/
	
// Reshape agri-food sectors to long
ren (agr prc inp_agr inp_prc trd_agr trd_prc hfs) (workers#), addnumber(1)
reshape long workers, i(country_code) j(subsector)
lab var workers "Number of workers, millions"
lab var tot "Total economy/employment (millions)"
lab var afs "Total agri-food workforce (millions)"
lab def subsector ///
	1 "Primary agriculture" ///
	2 "Agro-processing (incl. non-food)" ///
	3 "Inputs: prim. ag." ///
	4 "Inputs: agro-proc." ///
	5 "Trade & transport: prim. ag" ///
	6 "Trade & transport: agro-proc." ///
	7 "Hotels & food services", replace
lab val subsector subsector
lab var subsector "Agri-food system subsector"

// Renumber income groups to sort by income
ren incomegroup inc2
encode inc2, gen(incomegroup)
tab incomegroup
recode incomegroup (1=4) (2=1) (3=2) (4=3)
lab def inc 1 "Low-income" 2 "Lower-middle income" ///
	3 "Upper-middle income" 4 "High-income"
lab val incomegroup inc
lab var incomegroup "Country Income Group"

// Collapse to total over all countries per subsector
collapse (sum) workers tot afs, by(subsector incomegroup)

// Bar graph
graph bar workers, over(subsector) over(incomegroup, label(labsize(small))) ///
	stack asyvars ytitle("Millions of workers (total by income group)", margin(0 5 0 0)) ///
	legend(tstyle(size(vsmall)) symxsize(*.5) col(3)) name(empnum, replace)
graph export "$saveto/TWG3Fig_Num.png", replace
clear

* Part 2: Share of workforce (average)
// Import data
import delimited using "$data\Thurlow_2021_AgEmp_Share"

// Label variables
lab var tot "Total economy/employment"
lab var afs "Agri-food system"
lab var agr "Primary agriculture"
lab var prc "Agro-processing (food, beverages, tobacco, cotton yarn, timber products)"
lab var inp "Domestic input supply"
lab var inp_agr "Inputs used in primary agriculture"
lab var inp_prc "Inputs used in agro-processing"
lab var trd "Trade and transport services"
lab var trd_agr "Trade and transport of primary agricultural products"
lab var trd_prc "Trade and transport of primary agroprocessing products"
lab var hfs "Hotels and food services"
lab var ind "Industrial sectors (incl. manufacturing)"
lab var man "Manufacturing sectors"
lab var srv "Services"

// Reshape agri-food sectors to long
ren (agr prc inp_agr inp_prc trd_agr trd_prc hfs) (share#), addnumber(1)
reshape long share, i(country_code) j(subsector)
lab var share "Share of workforce (%)"
lab def subsector ///
	1 "Primary agriculture" ///
	2 "Agro-processing (incl. non-food)" ///
	3 "Inputs: prim. ag." ///
	4 "Inputs: agro-proc." ///
	5 "Trade & transport: prim. ag" ///
	6 "Trade & transport: agro-proc." ///
	7 "Hotels & food services", replace
lab val subsector subsector
lab var subsector "Agri-food system subsector"

// Renumber income groups to sort by income
ren incomegroup inc2
encode inc2, gen(incomegroup)
tab incomegroup
recode incomegroup (1=4) (2=1) (3=2) (4=3)
lab def inc 1 "Low-income" 2 "Lower-middle income" ///
	3 "Upper-middle income" 4 "High-income"
lab val incomegroup inc
lab var incomegroup "Country Income Group"

// Collapse to mean share over all countries per subsector
collapse (mean) share tot afs, by(subsector incomegroup)

// Bar graph
graph bar share, over(subsector) over(incomegroup, label(labsize(small))) ///
	stack asyvars ytitle("Mean Share of Workforce (%) by income group", margin(0 5 0 0)) ///
	legend(off) name(empshare, replace)
graph export "$saveto/TWG3Fig_share.png", replace

/* Legend notes
Data shown for 98 countries 
	2.9 billion total workers 
	1.1 billion in agri-food systems
Number of countries by region
	East Asia & Pacific: 18 
	East and Central Asia: 33 **China not included
	Latin America & Carribbean: 10
	Middle East & North Africa: 8
	North America: 2
	South Asia: 7
	Sub-Saharan Africa: 20
85% of the data are from 2015 or later
	Number of countries with old data by region:
		East Asia & Pacific: 2012 (2), 2014 (1)
		Latin America: 2012 (1)
		South Asia: 2011 (2), 2014 (2)
		Sub-Saharan Africa: 2006 (1), 2007 (3), 2012 (1), 2014 (1)
Source: Thurlow 2021, compilation of ILO data
