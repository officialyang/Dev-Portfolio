/*

Games.h
By: Matthew Yang (matthewyang@wustl.edu)
	Pratyay Bishnupuri (pbishnupuri@wustl.edu)


This is the header file that is included in the main source file "Games.cpp."
In this header file, we have declared the GameBase class and the TicTacToeGame and Gomoku games
subclasses.

*/


#pragma once
#include <vector>
#include <string>
#include <iostream>
#include <sstream>
#include "Header.h"

using namespace std;


class GameBase {
	//friend ostream & operator<< (ostream & outputStream, TicTacToeGame const & gameClass);
public:
	GameBase();
	void setUpVector();
	virtual void print() = 0;
	virtual bool done() = 0;
	virtual bool draw() = 0;
	virtual int prompt(unsigned int & coordX, unsigned int & coordY);
	virtual int turn() = 0;
	int play();
	static GameBase * game(int argc, char* argv[]);
protected:
	bool isTicTacToeGame;
	vector<string> displayVec;
	vector<string> coordinatesOfX;
	vector<string> coordinatesOfO;
	int numOfTurns;
	bool xTurn;
	int xCoord;
	int yCoord;
	int longestStrLength; //this will ensure columns of our board are aligned when printed
};

class TicTacToeGame : public GameBase {
	friend ostream & operator<< (ostream & outputStream, TicTacToeGame const & gameClass);
public:
	TicTacToeGame();
	virtual void print();
	virtual bool done();
	virtual bool draw();
	virtual int turn();
};

class Gomoku : public GameBase {
	friend ostream & operator<< (ostream & outputStream, Gomoku const & gameClass);
public:
	Gomoku();
	virtual void print();
	virtual bool done();
	virtual bool draw();
	virtual int turn();

};
