*==============================================================================*
* Date: January 24, 2023
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

local date %tdNNDDYY date(c(current_date), "DMY")
display `date'

use "C:\Users\rbucc\OneDrive - Harvard University\TESS\Correlation Between Perceived Risks and Rewards to Crime\NORC Amerispeak TESS Data\TESS103 Bucci_Final Data_5Apr22\TESS103 Bucci_FinalData_5Apr22.dta", clear


*Generate Vignette categories

gen highriskA = .
replace highriskA = 1 if P_VERSION==1 | P_VERSION==2  | P_VERSION==3  | P_VERSION==4 
replace highriskA = 0 if P_VERSION==5 | P_VERSION==6  | P_VERSION==7  | P_VERSION==8

gen highriskB = .
replace highriskB = 1 if P_VERSION==9 | P_VERSION==10 | P_VERSION==11  | P_VERSION==12
replace highriskB = 0 if P_VERSION==13 | P_VERSION==14 | P_VERSION==15  | P_VERSION==16

gen highrewardC = .
replace highrewardC = 1 if P_VERSION==1 | P_VERSION==5 | P_VERSION==9 | P_VERSION==13 
replace highrewardC = 0 if P_VERSION==2 | P_VERSION==6 | P_VERSION==10 | P_VERSION==14 

gen highrewardD = .
replace highrewardD = 1 if P_VERSION==3 | P_VERSION==7 | P_VERSION==11 | P_VERSION==15
replace highrewardD = 0 if P_VERSION==4 | P_VERSION==8 | P_VERSION==12 | P_VERSION==16



*For all combos just any high risk and any high reward
gen highrisk = .
replace highrisk = 1 if P_VERSION==1 | P_VERSION==2  | P_VERSION==3  | P_VERSION==4  | P_VERSION==9  | P_VERSION==10  | P_VERSION==11  | P_VERSION==12
replace highrisk = 0 if P_VERSION==5 | P_VERSION==6  | P_VERSION==7  | P_VERSION==8  | P_VERSION==13  | P_VERSION==14  | P_VERSION==15  | P_VERSION==16
label define highrisk 0 "Low Risk" 1 "High Risk"
label values highrisk highrisk 


gen highreward = .
replace highreward = 1 if  P_VERSION==1  | P_VERSION==3  | P_VERSION==5  | P_VERSION==7  | P_VERSION==9  | P_VERSION==11  | P_VERSION==13  | P_VERSION==15
replace highreward = 0 if  P_VERSION==2  | P_VERSION==4  | P_VERSION==6  | P_VERSION==8  | P_VERSION==10  | P_VERSION==12  | P_VERSION==14  | P_VERSION==16
label define highreward 0 "Low Reward" 1 "High Reward"
label values highreward highreward 




*Generate control variables/demographics

gen male = GENDER
recode male 2=0
label define male 0 "Female" 1 "Male"
label values male male

clonevar agecont = AGE

clonevar educ = EDUC5

gen raceeth = RACETHNICITY
recode raceeth 3=4 4=3 5=4 6=4
label define raceeth 1 "Non-Hispanic White" 2 "Non-Hispanic Black" 3 "Hispanic" 4 "Other Race"
label values raceeth raceeth

clonevar region = REGION4

gen maritalcat = MARITAL
recode maritalcat 3=2 4=2 5=3 6=4
label define maritalcat 1 "Married" 2 "Widowed, Divorced, Seperated" 3 "Never Married" 4 "Cohabitating"
label values maritalcat maritalcat

clonevar householdinc = INCOME4
label var householdinc "Household Income"

gen employedworking = EMPLOY
recode employedworking 2=1 3=0 4=0 5=0 6=0 7=0

gen time = duration
label var time "Duration of Survey (minutes)"

******************************************************************
*Create Focal Measures

foreach l in "A" "B" "C" "D" {
clonevar risk`l' = Q`l'1
recode risk`l' 998=.
}

foreach l in "A" "B" "C" "D" {
clonevar reward`l' = Q`l'2
recode reward`l' 998=.
}

foreach l in "A" "C" "D" {
clonevar socialcost`l' = Q`l'3
recode socialcost`l' 98=.
}

foreach l in "B" {
clonevar monetaryreward`l' = Q`l'3
recode monetaryreward`l' 98=.
}

foreach l in "A" "B" "C" "D" {
clonevar thrill`l' = Q`l'4
recode thrill`l' 98=.
}

foreach l in "A" "B" "C" "D" {
clonevar willingness`l' = Q`l'5
recode willingness`l' 98=.
}

foreach l in "A" "B" "C" "D" {
clonevar timespent`l' = DISPLAY_`l'_TOTALTIME
clonevar timespent`l'1 = Q`l'1_TOTALTIME
clonevar timespent`l'2 = Q`l'2_TOTALTIME
clonevar timespent`l'3 = Q`l'3_TOTALTIME
clonevar timespent`l'4 = Q`l'4_TOTALTIME
clonevar timespent`l'5 = Q`l'5_TOTALTIME
}


foreach l in "A" "B" "C" "D" {
gen riskrewarddistance`l' = risk`l'-reward`l'
}



*Descriptives
sum male agecont educ raceeth region maritalcat householdinc

sum male agecont educ raceeth region maritalcat householdinc if highrisk==1
sum male agecont educ raceeth region maritalcat householdinc if highrisk==0

sum male agecont educ raceeth region maritalcat householdinc if highreward==1
sum male agecont educ raceeth region maritalcat householdinc if highreward==0

bysort highrisk: sum male agecont 

prop educ raceeth region maritalcat householdinc, over(highrisk)


*Main

bysort highriskA: sum riskA rewardA socialcostA thrillA willingnessA
bysort highriskB: sum riskB rewardB monetaryrewardB thrillB willingnessB

bysort highrewardC: sum riskC rewardC socialcostC thrillC willingnessC
bysort highrewardD: sum riskD rewardD socialcostD thrillD willingnessD


gen C = rewardC
recode C 0/25=1 26/50=2 51/75=3 76/100=4


gen testC = rewardC
recode testC 0=0 1/10=1 11/20=2 21/30=3 31/40=4 41/50=5 51/60=6 61/70=7 71/80=8 81/90=9 91/100=100



ttest riskA, by(highriskA)
ttest rewardA, by(highriskA)
ttest socialcostA, by(highriskA)
ttest thrillA, by(highriskA)
ttest willingnessA, by(highriskA)
ttest riskrewarddistanceA, by(highriskA)


ttest riskB, by(highriskB)
ttest rewardB, by(highriskB)
ttest monetaryrewardB, by(highriskB)
ttest thrillB, by(highriskB)
ttest willingnessB, by(highriskB)
ttest riskrewarddistanceB, by(highriskB)


ttest riskC, by(highrewardC)
ttest rewardC, by(highrewardC)
ttest socialcostC, by(highrewardC)
ttest thrillC, by(highrewardC)
ttest willingnessC, by(highrewardC)
ttest riskrewarddistanceC, by(highrewardC)


ttest riskD, by(highrewardD)
ttest rewardD, by(highrewardD)
ttest socialcostD, by(highrewardD)
ttest thrillD, by(highrewardD)
ttest willingnessD, by(highrewardD)
ttest riskrewarddistanceD, by(highrewardD)
