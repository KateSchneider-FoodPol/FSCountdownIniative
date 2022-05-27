** Iodine Salt coverage:  working with the latest data point for each country  

import excel "/Users/devianadewi/Desktop/iodine_data_clean.xlsx", sheet("Sheet1") firstrow
** Ensure to click “import first row as a variable name”, to include the variable  Year in a numeric variable, otherwise STATA makes the variable as a string

** Get the latest data point for each country
bysort Country: egen highestyear = max(Year)
bysort Country: keep if highestyear == Year 
