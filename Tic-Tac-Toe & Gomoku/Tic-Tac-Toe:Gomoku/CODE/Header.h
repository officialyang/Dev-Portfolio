#pragma once

/*

Header.h
By: Matthew Yang (matthewyang@wustl.edu)


This is the header file that is included in the main source file "Lab3.cpp" and the "Source.cpp" file.
In this header file, I have declared two key functions (usageMessage() and makeLowercase()) and created
two enums that are referred to throughout the program.

*/


#pragma once
#include <string>


using namespace std;


int usageMessage(const string & ref, string message);
void makeLowercase(string & str);


/*
These enums act to hold commonly referred to values throughout the program.
The enum type values is primarily used in the main function, whereas the enum type results is used primarily in the
prompt(), turn(), draw(), and play() functions.
*/


enum values {
	programNameIndex = 0,
	fileNameIndex = 1,
	expectedCommandArgs = 2,
};


//Only values 0, 4, 8, 9 are used in this application.
enum results {
	success = 0,
	readDimensionsFailure = 1,
	readGamePiecesFailure = 2,
	readFileFailure = 3,
	numArgumentsFailure = 4,
	printPiecesFailure = 5,
	readLineFailure = 6,
	mainFuncReadDimensionsFailure = 7,
	programQuit = 8,
	drawGame = 9,
};
