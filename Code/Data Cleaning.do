*==============================================================================*
* Date: May 20 2022
* Project: Accounting for the Correlation between Perceived Risks & Rewards to Crime
*
* Files are located: C:\Users\rbucc\OneDrive - Harvard University\TESS
*==============================================================================*

*==============================================================================*

/*Hypotheses based on the affect heuristic

H1: When monetary rewards are greater (smaller), average perceptions of risk will be smaller (greater).
H2: When social rewards are greater (smaller), average perceptions of risk will be smaller (greater).
H3: When risks are greater (smaller), average perceptions of reward will be smaller (greater).

*/

cd "C:\Users\rbucc\OneDrive - Harvard University\TESS\Correlation Between Perceived Risks and Rewards to Crime"

local date %tdNNDDYY date(c(current_date), "DMY")
display `date'

use "NORC Amerispeak TESS Data\TESS103 Bucci_Final Data_5Apr22\TESS103 Bucci_FinalData_5Apr22.dta" 

gen highrisk = .
replace highrisk = 1 if P_VERSION==1 | P_VERSION==2  | P_VERSION==3  | P_VERSION==4  | P_VERSION==9  | P_VERSION==10  | P_VERSION==11  | P_VERSION==12
replace highrisk = 0 if P_VERSION==5 | P_VERSION==6  | P_VERSION==7  | P_VERSION==8  | P_VERSION==13  | P_VERSION==14  | P_VERSION==15  | P_VERSION==16

gen highreward = .
replace highreward = 1 if  P_VERSION==1  | P_VERSION==3  | P_VERSION==5  | P_VERSION==7  | P_VERSION==9  | P_VERSION==11  | P_VERSION==13  | P_VERSION==15
replace highreward = 0 if  P_VERSION==2  | P_VERSION==4  | P_VERSION==6  | P_VERSION==8  | P_VERSION==10  | P_VERSION==12  | P_VERSION==14  | P_VERSION==16




