
/*

	Author:	Jan Vallee
	Date: 18.03.2020

	DEVIATION PREVIOUS

	Description: Calculates the hotizontal distances between the answers. Calculates sum of distances and divides by number of Items-1. Score can range from 0 to 5
	
*/

*2. Recoding "No answer" from 0 to 6 to include it in the analysis*;
Data DevPrev;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
		if item =0 then item =6;
	end;
run;
data DevPrev2;
  set DevPrev;
  array cols{38} AutonomyPT1-- ODMevaluation11; 				/* creating arrays to simplify code*/
  array diffs{37} 8.;
  do i=2 to 38; 												/* no comparison on first */
    diffs{i-1}=cols{i}-cols{i-1};
      if diffs{i-1} < 0 then diffs{i-1}=diffs{i-1}*(-1);
  end;
run;
 data DevPrev3;
	set DevPrev2;
	array diff {*} diffs1 -- diffs37;
		sum_allnum= sum (of diff [*]);
run;
 data DevPrev4;
	set DevPrev3;
	DevPrev = round(sum_allnum/37, 0.01);
run;

/*Average of personal score by city*/
proc means data = DevPrev4 MEAN;
	var DevPrev;
	class CityHousehold;
	output out = DevPrev_MW;
run;
proc export data = DevPrev_MW
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet="DevPrev_MW";
run;

*Identification of people with a very low score -> Danger of straightlining;
proc print data=DevPrev4;
	where CityHousehold = 1 AND DevPrev < 0.1;
run;

data test;
	set DevPrev4;
	where CityHousehold = 8 AND DevPrev < 0.1;
run;


