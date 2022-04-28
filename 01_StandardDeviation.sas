/*
	Author: Jan Vallee
	Date: 18.03.2020

	STANDARD DEVIATION (SD)

	Description:	gives the variation of answers -> SD = 0 in case all answers are equal
 
*/


*calculating SD - SD of all Items per Person*;
data SD_NoMissing;	
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;		/* Creating an array of all Items to be tested */
	do over item;
	if item = 0 then item = .;	/*Recoding no answer to "." to not influence the standard deviation */
	end;
run;
data SD;
	set SD_NoMissing;
	sd = std(AutonomyPT1, SocialNormPT1, ExperiencePT2, BicycleOrientation1, ExperiencePT3, CarOrientation1, IntentionPT1, BicycleOrientation2, AutonomyPT2, ExperiencePT1, 
	IntentionPT2, ExperiencePT4, CarOrientation3, PersonalNormPT1, CarOrientation4, AutonomyPT4, BicycleOrientation3, WeatherResistance2, StatusCar1, StatusCar2, StatusCar3, 
	StatusCar7, StatusCar8, StatusCar12, StatusCar13, StatusCar14, StatusCar15, ODMevaluation1, ODMevaluation2, ODMevaluation3, ODMevaluation4, ODMevaluation5, ODMevaluation6, 
	ODMevaluation7, ODMevaluation8, ODMevaluation9, ODMevaluation10, ODMevaluation11); 			/*calculating the SD of given Items*/
run;

proc means data = SD;	/*average of SD*/
	var sd;
	class CityHousehold;
	output out = SD_City;
run;

proc export data = SD_City
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet = "SD";
run;

/*Cut Offs*/
proc sort data = sd;
	by CityHousehold;
run;
data test1;
	set sd;
	where CityHousehold = 8 AND sd = 0;
run;
data test2;
	set sd;
	where CityHousehold = 8 AND sd < 0.1;
run;
data test3;
	set sd;
	where CityHousehold = 8 AND sd < 0.3;
run;
data test4;
	set sd;
	where CityHousehold = 8 AND sd < 0.5;
run;
data test5;
	set sd;
	where CityHousehold = 8 AND sd < 1.0;
run;
