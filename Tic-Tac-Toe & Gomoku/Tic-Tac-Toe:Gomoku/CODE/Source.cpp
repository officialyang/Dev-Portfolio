/*
Source.cpp
By: Matthew Yang (matthewyang@wustl.edu)	Pratyay Bishnupuri (pbishnupuri@wustl.edu)

This is the source file that defines two key helper functions that are called upon in "Tic-Tac-Toe.cpp" and "Lab3.cpp".
These include the ussageMessage() and makeLowercase() functions.

*/


#include "stdafx.h"
#include "Header.h"
#include <iostream>
#include <vector>


int usageMessage(const string & ref, string message) {
	/*
	This is the usageMethod function that is called when there is a wrong number of command line arguments.
	This will let the user know of the problem through a helpful printed out statement.
	*/
	cout << "Usage: " << ref << " <GameName>" << endl;
	cout << message << endl;
	return results(numArgumentsFailure);
}


void makeLowercase(string & str) {
	/*
	Using ASCII values to check to see if each letter in the string are uppercase or not. If it is, then add 32 to its ASCII value
	rendering it lowercase.
	*/
	for (size_t i = 0; i < str.length(); i++) {
		if (str[i] >= 65 && str[i] <= 90) {
			str[i] = str[i] + 32;
		}
	}
}
