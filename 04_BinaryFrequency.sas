/*

	Author: Jan Vallee
	Date: 18.03.2020

	BINARY FREQUENCY

	Description: 	Calculates the frequency in each category, from 1 = yes, I agree to 5 = No, I disagree
					Acquiescence: 			Category 1
					Near Acquiescence:		Category 1 + Category 2
					Central Tendency:		Category 3
					Near Central Tendency:	Category 2 + Category 3 + Category 4
					Disacquiescence:		Category 5
					Near Disacquiescence:	Category 4 + Category 5
					Non Response:			Category 99

*/


*/ACQUIESCENCE/*;

*Array for 38 variables, if Item=1 then ->1, else 0*;
Data BinFreq;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=1 then item=1;
	else item=0;
	end;
run;
*row total*;
data BinFreq2;
	set BinFreq;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data BinFreq3;
	set BinFreq2;
	Ac= round(sum_allnum/38, 0.01);
run; 


*/NEAR ACQUIESCENCE/*;
*Array for 38 variables, if Item=1 or Item=2 then ->1, else 0*;
Data NAC;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=1 OR item=2 then item=1;
	else item=0;
	end;
run;
*row total*;
data NAC2;
	set NAC;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data NAC3;
	set NAC2;
	NAc= round(sum_allnum/38, 0.01);
run; 



*/CENTRAL TENDENCY/*;

*Array for 38 variables, if Item=3 then ->1, else 0*;
Data CT;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=3 then item=1;
	else item=0;
	end;
run;
*row total*;
data CT2;
	set CT;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data CT3;
	set CT2;
	Ct= round(sum_allnum/38, 0.01);
run; 



*/NEAR CENTRAL TENDENCY/*;

*Array for 38 variables, if Item=2 or Item=3 or Item=4 then ->1, else 0*;
Data NCT;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=2 OR item=3 OR item=4 then item=1;
	else item=0;
	end;
run;
*row total*;
data NCT2;
	set NCT;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data NCT3;
	set NCT2;
	NCt= round(sum_allnum/38, 0.01);
run; 


*/DISACQUIESCENCE/*;

*Array for 38 variables, if Item=5 then ->1, else 0*;
Data D;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=5 then item=1;
	else item=0;
	end;
run;
*row total*;
data D2;
	set D;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data D3;
	set D2;
	D= round(sum_allnum/38, 0.01);
run; 



*/NEAR DISACQUIESCENCE/*;

*Array for 38 variables, if Item=4 or Item=5 then ->1, else 0*;
Data ND;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=4 OR item=5 then item=1;
	else item=0;
	end;
run;
*row total*;
data ND2;
	set ND;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data ND3;
	set ND2;
	ND= round(sum_allnum/38, 0.01);
run; 



*/NON RESPONSE/*;

*Array for 38 variables, if Item=0 then ->1, else 0*;
Data NR;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item=0 then item=1;
	else item=0;
	end;
run;
*row total*;
data NR2;
	set NR;
	sum_allnum=sum (of AutonomyPT1-- ODMevaluation11);
run;
*Share of row total over all 38 Items*;
data NR3;
	set NR2;
	NR= round(sum_allnum/38, 0.01);
run; 



