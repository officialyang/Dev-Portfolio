/*
lab4.cpp
By: Matthew Yang (matthewyang@wustl.edu)Pratyay Bishnupuri (pbishnupuri@wustl.edu)

This file checks the command line argument and plays the appropriate game. If 
the command line arguments are incorrect, it prints out a usage message.

*/

#include "stdafx.h"
#include "Games.h"
#include <memory>
#include <iomanip>


int main(int argc, char * argv[])
{
	auto obj = GameBase::game(argc, argv);
	if (obj == 0) {
		string message = "Command Line Arguments: \'ProgramName.exe\' \'GameName\'";
		return usageMessage(argv[values(programNameIndex)], message);
	}
	else {
		shared_ptr<GameBase> sp(obj);
		return sp->play();
	}
}
