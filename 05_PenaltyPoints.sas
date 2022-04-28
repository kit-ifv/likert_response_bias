/*
	Author: Jan Vallee
	Date:	20.03.2020

	0-1 PenaltyPoints for giving the same answer depending on the correlation.
			Every Answer gets Penalty Points depending on the Correlation between the given Item and the previous one in all the answers. 
			High Correlation between answers mean fewer Penalty Points given for that answer and vice versa.
			Correlations above 0.7 shall be rounded to 1. Correlations below 0.3 shall be rounded to 0.
	1   PenaltyPoint for diagonal answering scheme.
	0.5 PenaltyPoints for criss-crossing.

	Correlations between answers have to be inserted manually. Calculating correlations can be done by using "proc corr" in SAS. 
proc corr data=data.p;
	var Item1 -- Item38;
	with Item1 -- Item38;
run;

*/
*Recoding "No answer" from "0" to "6";


Data NoMissing;
	set Data.P_HH;
	array item AutonomyPT1-- ODMevaluation11;
	do over item;
	if item =0 then item =6;
	end;
run;

*Gives one provisional PenaltyPoint if two consecutive Items have the same answer";
data Punkt1;
	set NoMissing;
	array cols{38} AutonomyPT1-- ODMevaluation11;
	array diffs{37} 8.; 
	do i = 2 to 38; 									/*First Item does not have a previous one*/
		diffs{i-1}=cols{i}-cols{i-1}; 					/*Checks if same answer is given*/
      		if diffs{i-1} = 0 then diffs{i-1}=1; 		/*If yes, then give 1 Penalty Point*/
			else diffs{i-1}=0; 							/*else give none*/
  end;
run;

*Checks correlation between subsequent Items and adjusts Penalty Points;
data algMC (drop=i);
	set punkt1; 
	array diffs[37];
	array PenaltyPoints[37];													/*Insert correlation between consecutive Items below. Start with correlation between first and second Item. i-1 values in total */ 
	array correlation[37] _temporary_ ( 0.56854	0.53838	0.37545	0.42525	0	0	0.38533	0.41033	1	0.59259	0.44431	0	0	0	0	0.32405	0.45968	0	0.57317	0.68828	0.60651	0.60136	0.56531	0.59164	0.54778	0	0	0	0	0.33964	0	0.44673	0.40242	0	0.51577	0	0);
	do i = 1 to 37;     
		if correlation[i] =diffs[i] then PenaltyPoints [i] =0; 					*If answering scheme matches correlation, no PenaltyPoint is awarded;
		else if correlation[i]=1 or correlation[i]=0 then PenaltyPoints[i]=1;	*If there is a very high or very low correlation but the answering scheme does not match, one Point is awarded;
		else if diffs[i]=0 then PenaltyPoints[i]=0;								*If answer is not the same as on previous Item and correlation is mediocre no PenaltyPoint is awarded;
		else PenaltyPoints[i]=1-correlation[i];									*If answer is the same as on previous Item and correlation is between 0.3 and 0.7 then 1-correlation PenaltyPoints are awarded;
	end; 		
run;
data algMC2;											*Sum up Penalty Points for Straightlining with Correlation of each participant;
	set algMC;
	array PenaltyPoints {*} PenaltyPoints1 -- PenaltyPoints37;
	sum_allnum1= sum (of PenaltyPoints [*]);
run;

/* 1 Penalty Point if the difference between two consecutive Items is the same as the previous Items (Diagonal Line)*/
data Diagonal;
	set NoMissing;
	array cols{38} AutonomyPT1-- ODMevaluation11;
	array diffs{37} 8.; 
	do i = 2 to 38; 									/*first Item does not have a predecessor*/
		diffs{i-1}=cols{i}-cols{i-1};
  end;
run;

data Diagonal2;
  set Diagonal;
  array diffs{37} diffs1 -- diffs37; 					/* Notation shortened */
  array change{36} 8.;
  do i=2 to 37;  										/* no comparison on first */
    change{i-1}=diffs{i}-diffs{i-1}; 					/*Change = Difference between column i and column i-1*/
      if change{i-1} = 0 and diffs{i}^=0 then change{i-1}=1; /*If change equals 0 and difference of i doesn not then give 1 PenaltyPoint*/
		else change{i-1}=0;
	end;
run;
data Diagonal3;									*Sums up Penalty Points for diagonal answering scheme;
	set Diagonal2;
	array change {*} change1 -- change36;
	sum_allnum2= sum (of change [*]);
run;

/*0.5 Penalty Points, if difference between two Items is the same as between the two predecessors (Criss-Crossing)*/;
data Punkt3;
  set Diagonal;
  array diffs{37} diffs1 -- diffs37; 		/* Note shortened */
  change=0;
	do i=3 to 37;  							/* no comparison on first */
        if diffs{i} ~= 0 and diffs{i-1} + diffs{i} = 0 and diffs{i-2}=diffs{i} then change=change + 0.5;
		else change=change;
	end;
run;
data Punkt4;
	set Punkt3;
	sum_allnum3= sum (of change);
run;

*Adding up all tables*;
proc sort data = algMC2;
	by personid;
run; 
proc sort data = Diagonal3;
	by personid;
run; 
proc sort data = Punkt4;
	by personid;
run; 
data Punkte;
	merge algMC2 (in=a) Diagonal3 (in=b) Punkt4;
	by personid;
	keep personid CityHousehold sum_allnum1 sum_allnum2 sum_allnum3;
run; 

*adding PenaltyPoints*;
data Data.PenaltyPoints;
	set Punkte;
	Sum=(sum_allnum1 + sum_allnum2 + sum_allnum3);
	Sum2=(sum_allnum1 + sum_allnum2 + sum_allnum3)/37;
run;


/*Calculate average of each City*/
proc means data = Data.PenaltyPoints MEAN;
	var Sum2;
	class CityHousehold;
	output out = Pen_MV;
run;
proc export data = Pen_MV
	outfile = "&path_data.\SAS_Export_New\Results.xlsx"
	dbms = xlsx
	replace;
	sheet="Pen_MV_algMC";
run;
