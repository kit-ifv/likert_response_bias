
/*

	Author: Jan Vallee
	Date: 	18.03.2020

	MEAN VALUE per Item and Person

*/


*Calculating mean of each Item*;
data SD_NoMissing;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item = 0 then item = .;
	end;
run;	
proc sort data = SD_NoMissing;
	by PersonID;
run;

proc means data = SD_NoMissing MEAN;
	var AutonomyPT1-- ODMevaluation11;
	output out = mean_item;
	class CityHousehold;
run;
proc export data = mean_item 
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet="Mean_Item";
run;

*4. Calculating mean of each Person*;
data mean_p;
	set SD_NoMissing;
	Sum_p= round(sum(of AutonomyPT1-- ODMevaluation11)/38, 0.01);
run;
proc export data = mean_p
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet="Mean_P";
run;

*4. Calculating mean of all People in a City*;
data Mean_City;
	set SD_NoMissing;
	Mean_City = mean(AutonomyPT1, SocialNormPT1, ExperiencePT2, BicycleOrientation1, ExperiencePT3, CarOrientation1, IntentionPT1, BicycleOrientation2, AutonomyPT2, ExperiencePT1, 
	IntentionPT2, ExperiencePT4, CarOrientation3, PersonalNormPT1, CarOrientation4, AutonomyPT4, BicycleOrientation3, WeatherResistance2, StatusCar1, StatusCar2, StatusCar3, 
	StatusCar7, StatusCar8, StatusCar12, StatusCar13, StatusCar14, StatusCar15, ODMevaluation1, ODMevaluation2, ODMevaluation3, ODMevaluation4, ODMevaluation5, ODMevaluation6, 
	ODMevaluation7, ODMevaluation8, ODMevaluation9, ODMevaluation10, ODMevaluation11);
run;
proc means data = Mean_City MEAN;
	var Mean_City;
	class CityHousehold;
	output out = City;
run;
proc univariate data = Mean_City;
	var Mean_City;
	class CityHousehold;
run;
proc export data = City
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet="Mean_City";
run;


