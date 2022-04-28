/*

	Author: Jan Vallee
	Date: 18.03.2020

	IMPORT AND MERGE OF DATA

*/

/*Import of Data*/
proc import
	datafile = "&path_data.\CSV_Data\Household_CN.csv"
	out = Data.HH
	dbms = csv replace;
	delimiter = ';';
run;

proc import 
	datafile = "&path_data.\CSV_Data\Person_CN.csv"
	out = Data.P
	dbms = csv replace;
	delimiter = ';';
run;

/*Combination of Household and Person Data*/
proc sort data = Data.HH;
	by HHID;
run;
proc sort data = Data.P;
	by	HHID;
run;

data Data.P_HH;
	merge Data.P (in=a) Data.HH (in=b);
	by HHID;
run;
