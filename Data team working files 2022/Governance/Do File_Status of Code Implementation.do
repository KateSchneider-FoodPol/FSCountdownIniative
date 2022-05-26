** Status of Code Implementation in Legislation: transforming the categorical value into numerical value 
** Substantially aligned with the Code = 4 
** Moderately aligned with the code = 3
** Some provisions of the Code included = 2 
** No legal measures = 1   

import delimited "/Users/devianadewi/Desktop/code_status.csv", encoding(UTF-8) 
(8 vars, 442 obs)

*Drop value regarding law in 2018 since it is not relevant
drop if year == 2018

*Use the label command in an order from 1 to 4 and assign .a that STATA reads as a missing value 
label define order5 1 "No legal measures" 2 "Some provisions of the Code included" 3 "Moderately aligned with the Code" 4 "Substantially aligned with the Code" .a "No data"

encode value, gen(value2) label(order5) 

*Check the numeric value and missing value at the same time
tab value2, nolabel missing

*STATA reads value2 as a numeric variable but when exporting to CSV file the numbers do not show. We need to make the value2 variable back to string value then encode again in order to show the numbers. 
tostring value2, gen(value3) 
destring value3, gen(value4)

describe value3
describe value4
* value3 is a string variable (in the font red) and value4 is a numeric variable (in the blue font) -- they will show as numbers when exporting to CSV file. 
