/*

	Author:	Jan Vallee
	Date:	18.03.2020

	INITIALISATION 

*/

%let path_Data = FAKEPATH;


/*
	SAS creates new folder in case it does not exist yet
*/

OPTIONS dlcreatedir;

/*
	Integrate Libary
*/
libname Data "&path_Data.";;


