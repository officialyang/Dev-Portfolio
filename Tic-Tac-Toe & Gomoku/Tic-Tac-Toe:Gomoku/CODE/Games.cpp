#include "stdafx.h"
#include "Games.h"
#include <iomanip>

/*

Games.cpp
By: Matthew Yang (matthewyang@wustl.edu)
Pratyay Bishnupuri (pbishnupuri@wustl.edu)


This is the cpp file for Games.h. This file declares TicTacToe, Gomoku, and many of its 
functions. As well as the insertion operators.

*/


TicTacToeGame::TicTacToeGame()
{
	displayVec.resize(36);
	xCoord = 5;
	yCoord = 5;
	setUpVector();
	isTicTacToeGame = true;
}

Gomoku::Gomoku()
{
	displayVec.resize(505);
	xCoord = 20;
	yCoord = 20;
	setUpVector();
	xTurn = !xTurn;
	isTicTacToeGame = false;
}

void Gomoku::print()
{
	cout << *this << endl;
}

bool Gomoku::done()
{
	/*
	Checks to see if there are any win cases by checking each possible win scenario. If there exists at least one, returns true.
	If B or W hasn't won yet, return false.
	*/
	for (int i = Gomoku::yCoord; i >= 0; i--) {
		for (int j = 0; j <= Gomoku::xCoord; j++) {

			if (displayVec[(Gomoku::xCoord)*i + j] == "B") {
				//Case of vertical win.
				if (displayVec[(Gomoku::xCoord)*(i + 1) + j] == "B") {
					if (displayVec[(Gomoku::xCoord )*(i + 2) + j] == "B" && displayVec[(Gomoku::xCoord)*(i + 3) + j] == "B" && displayVec[(Gomoku::xCoord)*(i + 4) + j] == "B") {
						return true;
					}
				}

				
				//Case of left diagonal win.
				if (displayVec[Gomoku::xCoord*(i - 1) + (j + 1)] == "B") {
					if (displayVec[Gomoku::xCoord*(i - 2) + (j + 2)] == "B" && displayVec[Gomoku::xCoord*(i - 3) + (j + 3)] == "B" && displayVec[Gomoku::xCoord*(i - 4) + (j + 4)] == "B") {
						return true;
					}
				}


				//Case of right diagonal win.
				if (displayVec[(xCoord)*(i + 1) + (j + 1)] == "B") {
					if (displayVec[(xCoord)*(i + 2) + (j + 2)] == "B" && displayVec[(xCoord)*(i + 3) + (j + 3)] == "B" && displayVec[(xCoord)*(i + 4) + (j + 4)] == "B") {
						return true;
					}
				}


				//Case of horizontal win.
				if (displayVec[Gomoku::xCoord*i + (j +1)] == "B") {
					if (displayVec[Gomoku::xCoord*i + (j + 2)] == "B" && displayVec[Gomoku::xCoord*i + (j + 3)] == "B" && displayVec[Gomoku::xCoord*i + (j + 4)] == "B") {
						return true;
					}
				}
			}
			

			if (displayVec[Gomoku::xCoord*i + j] == "W") {
				//Case of vertical win.
				if (displayVec[(Gomoku::xCoord)*(i + 1) + j] == "W") {
					if (displayVec[(Gomoku::xCoord)*(i + 2) + j] == "W" && displayVec[(Gomoku::xCoord)*(i + 3) + j] == "W" && displayVec[(Gomoku::xCoord)*(i + 4) + j] == "W") {
						return true;
					}
				}


				//Case of left diagonal win.
				if (displayVec[Gomoku::xCoord*(i - 1) + (j + 1)] == "W") {
					if (displayVec[Gomoku::xCoord*(i - 2) + (j + 2)] == "W" && displayVec[Gomoku::xCoord*(i - 3) + (j + 3)] == "W" && displayVec[Gomoku::xCoord*(i - 4) + (j + 4)] == "W") {
						return true;
					}
				}


				//Case of right diagonal win.
				if (displayVec[(xCoord)*(i + 1) + (j + 1)] == "W") {
					if (displayVec[(xCoord)*(i + 2) + (j + 2)] == "W" && displayVec[(xCoord)*(i + 3) + (j + 3)] == "W" && displayVec[(xCoord)*(i + 4) + (j + 4)] == "W") {
						return true;
					}
				}


				//Case of horizontal win.
				if (displayVec[Gomoku::xCoord*i + (j + 1)] == "W") {
					if (displayVec[Gomoku::xCoord*i + (j + 2)] == "W" && displayVec[Gomoku::xCoord*i + (j + 3)] == "W" && displayVec[Gomoku::xCoord*i + (j + 4)] == "W") {
						return true;
					}
				}
			}
		}
	}


	//After iterating through the all the spots, if there are no wins, return false to indicate that the game is not done.
	return false;
}

bool Gomoku::draw()
{
	if (done()) {
		return false;
	 }
	else {
		if (numOfTurns == 361) {
			//number of turns to fill up the board
			return true;
		}
	}
	return false;
}

int Gomoku::turn()
{
	/*
	This method calls the prompt() method. If the user has quit the game, then return a quit value.
	Otherwise, it is considered a valid move and the method prints the board out with the just made move, as well as all the moves that player had made before.
	*/
	int promptResult = 0;
	unsigned int x, y = 0;


	//User quit the game

	if (prompt(x, y) == results(programQuit)) {
		return results(programQuit);
	}


	//User entered a valid move
	else {
		if ((xCoord + 1) * (y) + (x) > (displayVec.size()-1)) {
			//Catching bug of user quitting after inputting wrong coordinate.
			return results(programQuit);
		}
		if (xTurn) {
				displayVec[(xCoord-1 + 1) * (y)+(x)] = "B";
				string coordStr = to_string(x) + "," + to_string(y);
				coordinatesOfX.push_back(coordStr);
		}
		else {
				displayVec[(xCoord-1 + 1) * (y)+(x)] = "W";
				string coordStr = to_string(x) + "," + to_string(y);
				coordinatesOfO.push_back(coordStr);
		}

		print();
		numOfTurns++;
	}


	/*
	Prints all the moves made by the player who made the most recent move. If it is B's turn, the print out Player Black's moves,
	Otherwise, it has to be Player White's moves.
	*/
	if (xTurn) {
		cout << "Player Black: ";
		for (size_t i = 0; i < coordinatesOfX.size(); i++) {
			if (i + 1 != coordinatesOfX.size()) {
				cout << coordinatesOfX[i] << "; ";
			}
			else {
				cout << coordinatesOfX[i];
			}
		}
	}
	else {
		cout << "Player White: ";
		for (size_t i = 0; i < coordinatesOfO.size(); i++) {
			if (i + 1 != coordinatesOfO.size()) {
				cout << coordinatesOfO[i] << "; ";
			}
			else {
				cout << coordinatesOfO[i];
			}
		}
	}


	cout << endl;


	xTurn = !xTurn;  //Switches between Player Black and Player White
	return results(success);
}

GameBase::GameBase() :
	numOfTurns(0)
{
}



void TicTacToeGame::print()
{
	//Calls the operator << operator for TicTacToeGame
	cout << *this << endl;
}

bool TicTacToeGame::done()
{
	/*
	Checks to see if there are any win cases by checking each possible win scenario. If there exists at least one, returns true.
	If X or O hasn't won yet, return false.
	*/
	for (int i = TicTacToeGame::yCoord; i >= 0; i--) {
		for (int j = 0; j <= TicTacToeGame::xCoord; j++) {

			if (displayVec[TicTacToeGame::xCoord*i + j] == "X") {
				//Case of vertical win.
				if (displayVec[TicTacToeGame::xCoord*(i + 1) + j + 1] == "X") {
					if (displayVec[TicTacToeGame::xCoord*(i + 2) + j + 2] == "X" || displayVec[TicTacToeGame::xCoord*(i - 1) + j - 1] == "X") {
						return true;
					}
				}


				//Case of left diagonal win.
				if (displayVec[TicTacToeGame::xCoord*(i + 1) + (j - 1) + 1] == "X") {
					if (displayVec[TicTacToeGame::xCoord*(i + 2) + (j - 2) + 2] == "X" || displayVec[TicTacToeGame::xCoord*(i - 1) + (j + 1) - 1] == "X") {
						return true;
					}
				}


				//Case of right diagonal win.
				if (displayVec[(xCoord)*(i + 1) + (j + 1) + 1] == "X") {
					if (displayVec[(xCoord)*(i + 2) + (j + 2) + 2] == "X" || displayVec[(xCoord)*(i - 1) + (j - 1) - 1] == "X") {
						return true;
					}
				}


				//Case of horizontal win.
				if (displayVec[TicTacToeGame::xCoord*i + (j - 1)] == "X") {
					if (displayVec[TicTacToeGame::xCoord*i + (j - 2)] == "X" || displayVec[TicTacToeGame::xCoord*i + (j + 1)] == "X") {
						return true;
					}
				}
			}


			if (displayVec[TicTacToeGame::xCoord*i + j] == "O") {


				//Case of vertical win.
				if (displayVec[TicTacToeGame::xCoord*(i + 1) + j + 1] == "O") {
					if (displayVec[TicTacToeGame::xCoord*(i + 2) + j + 2] == "O" || displayVec[TicTacToeGame::xCoord*(i - 1) + j - 1] == "O") {
						return true;
					}
				}


				//Case of left diagonal win.
				if (displayVec[TicTacToeGame::xCoord*(i + 1) + (j - 1) + 1] == "O") {
					if (displayVec[TicTacToeGame::xCoord*(i + 2) + (j - 2) + 2] == "O" || displayVec[TicTacToeGame::xCoord*(i - 1) + (j + 1) - 1] == "O") {
						return true;
					}
				}


				//Case of right diagonal win.
				if (displayVec[TicTacToeGame::xCoord*(i + 1) + (j + 1) + 1] == "O") {
					if (displayVec[TicTacToeGame::xCoord*(i + 2) + (j + 2) + 2] == "O" || displayVec[TicTacToeGame::xCoord*(i - 1) + (j - 1) - 1] == "O") {
						return true;
					}
				}


				//Case of horizontal win.
				if (displayVec[TicTacToeGame::xCoord*i + (j - 1)] == "O") {
					if (displayVec[TicTacToeGame::xCoord*i + (j - 2)] == "O" || displayVec[TicTacToeGame::xCoord*i + (j + 1)] == "O") {
						return true;
					}
				}
			}
		}
	}


	//After iterating through the all the spots, if there are no wins, return false to indicate that the game is not done.
	return false;

}

bool TicTacToeGame::draw()
{
		/*
		A draw is defined as all the moves on the tic-tac-toe game board made, but neither X nor O has won.
		Therefore if done() returns true, then there is no draw. Otherwise, if all the moves are made, then returns true to indicate a draw.
		*/
		if (done()) {
			return false;
		}
		else {
			/*
			//Checks only the spaces in the tic-tac-toe board to see if there are moves left
			for (int i = 14; i < 28; i = i + 6) {
				if (displayVec[i] == " " || displayVec[i + 1] == " " || displayVec[i + 2] == " ") {
					return false;
				}
			}
			*/
			if(numOfTurns == 9){
				return true;
			}
		}
		return false;
}

int TicTacToeGame::turn()
{
	/*
	This method calls the prompt() method. If the user has quit the game, then return a quit value.
	Otherwise, it is considered a valid move and the method prints the board out with the just made move, as well as all the moves that player had made before.
	*/
	int promptResult = 0;
	unsigned int x, y = 0;


	//User quit the game

	if (prompt(x, y) == results(programQuit)) {
		return results(programQuit);
	}


	//User entered a valid move
	else {
		if ((xCoord + 1) * (y + 1) + (x + 1) > 35) {
			//Catching bug of user quitting after inputting wrong coordinate.
			return results(programQuit);
		}
		if (xTurn) {
			displayVec[(xCoord + 1) * (y + 1) + (x + 1)] = "X";
			string coordStr = to_string(x) + "," + to_string(y);
			coordinatesOfX.push_back(coordStr);
		}
		else {
			displayVec[(xCoord + 1) * (y + 1) + (x + 1)] = "O";
			string coordStr = to_string(x) + "," + to_string(y);
			coordinatesOfO.push_back(coordStr);
		}

		print();
		numOfTurns++;
	}


	/*
	Prints all the moves made by the player who made the most recent move. If it is x's turn, the print out Player X's moves,
	Otherwise, it has to be Player O's moves.
	*/
	if (xTurn) {
		cout << "Player X: ";
		for (size_t i = 0; i < coordinatesOfX.size(); i++) {
			if (i + 1 != coordinatesOfX.size()) {
				cout << coordinatesOfX[i] << "; ";
			}
			else {
				cout << coordinatesOfX[i];
			}
		}
	}
	else {
		cout << "Player O: ";
		for (size_t i = 0; i < coordinatesOfO.size(); i++) {
			if (i + 1 != coordinatesOfO.size()) {
				cout << coordinatesOfO[i] << "; ";
			}
			else {
				cout << coordinatesOfO[i];
			}
		}
	}


	cout << endl;


	xTurn = !xTurn;  //Switches between Player X and Player O
	return results(success);
}



int GameBase::prompt(unsigned int & coordX, unsigned int & coordY)
{
	{
		/*
		This function asks the user to input a valid coordinate, checking if the coordinate is valid or not.
		If it is valid, then it will update the displayVec value at the appropriate index value.
		Otherwise, it should print an error message.
		*/
		string str;
		cout << "Type \'quit\' to end the game or enter a valid coordinate on the board in x,y format." << endl;
		cin >> str;
		makeLowercase(str);
		for (size_t i = 0; i < str.length(); i++) {
			if (str[i] == ',') {
				str[i] = ' ';
			}
		}
		if (str == "quit" || str == "Quit") {
			return results(programQuit);
		}
		//Using an istringstream to parse the two numbers by overlooking spaces, whitespace, etc.
		istringstream iss(str);


		int x = 0;
		int y = 0;
		if (iss >> x) {
			if (iss >> y) {
				if (isTicTacToeGame) {
					//Coordinates beyond the given vertical and horizontal values.
					if ((size_t)((xCoord + 1) * (y + 1) + (x + 1)) > displayVec.size() || x < 1 || y < 1 || x>(xCoord - 2) || y>(yCoord - 2)) {
						cout << endl;
						cout << "Invalid coordinate. Please try again" << endl;
						cout << endl;
					}
					//Valid coordinate
					else if (displayVec[(xCoord + 1) * (y + 1) + (x + 1)] == " " && (x != 0 || x != (xCoord - 1)) && (y != 0 || y != (yCoord - 1))) {
						coordX = x;
						coordY = y;
						return results(success);
					}
				}
				else {
					//Gomoku Game
					if ((size_t)((xCoord + 1) * (y) + (x)) > displayVec.size() || x < 1 || y < 1 || x > xCoord-1 || y > yCoord-1) {
						cout << endl;
						cout << "Invalid coordinate. Please try again" << endl;
						cout << endl;
					}
					//Valid coordinate
					else if (displayVec[(xCoord + 1) * (y) + (x)] == " "/* && (x != 0 || x != (xCoord)) && (y != 0 || y != (yCoord - 1))*/) {
						coordX = x;
						coordY = y;
						return results(success);
					}

				}
			}
		}
		else {
			//If the user inputs non-numerical moves, then this specific error message is printed out.
			cout << endl;
			cout << "Enter numerical values only. Please try again" << endl;
			cout << endl;
			coordX, coordY = 0;
		}


		//If the extraction is unsuccessful, then prompt the user again.
		prompt(coordX, coordY);
	}

}

int GameBase::play()
{
	/*
	Repeatedly calls the turn(), done(), and draw() methods
	until the program reaches the return statements to exit the play() method.
	*/
	print();
	while (true) {
		if (turn() == results(programQuit)) {
			cout << "The game was quit. Number of turns: " << numOfTurns << endl;


			//Resets the number of turns in the game to 0.
			numOfTurns = 0;
			return results(programQuit);
		}
		if (done()) {
			cout << endl;
			if (xCoord == 5) { //TicTacToe
				if (!xTurn) {
					cout << "X won!" << endl;
				}
				else {
					cout << "O won!" << endl;
				}
				return results(success);
			}
			else { //Gomoku
				if (!xTurn) {
					cout << "Black won!" << endl;
				}
				else {
					cout << "White won!" << endl;
				}
				return results(success);
			}
		}

		if (draw()) {
			cout << "The game is a draw! Number of turns: " << numOfTurns << endl;
			return results(drawGame);
		}
	}


}

GameBase * GameBase::game(int argc, char * argv[])
{
	if (argc == values(expectedCommandArgs)) {
		if (((string)argv[values(fileNameIndex)]).compare("TicTacToe") == 0) {
			//Matches that it's TicTacToe
			TicTacToeGame * tttg = new TicTacToeGame();
			return &*tttg;
		}
		else if (((string)argv[values(fileNameIndex)]).compare("Gomoku") == 0) {
			//Matches that it's Gomoku
			Gomoku * gm = new Gomoku();
			return &*gm;
		}
		else {
			return nullptr;
		}
	}
	return nullptr;
}
	


ostream & operator<<(ostream & outputStream, TicTacToeGame const & gameClass)
{
	/*
	Overloaded function that prints out the game board specifically for GameBase objects.
	*/
	for (int i = gameClass.yCoord; i >= 0; i--) {
		//Starts at the top most row and goes down until it hits the bottom most row.
		for (int j = 0; j <= gameClass.xCoord; j++) {
			//Starts at the left most column and moves right until it hits the right most column.

			//Blank space at coordinate (0,0)
			if (i == 0 && j == 0) {
				cout << " ";
			}

			else if (j == 0) {
				cout << i - 1;
			}
			else if (i == 0) {
				cout << j - 1 << " ";
			}
			else if (gameClass.displayVec[(gameClass.xCoord + 1)*i + j] == "") {
				cout << " ";
			}
			else {
				cout << gameClass.displayVec[(gameClass.xCoord + 1)*i + j] << " ";
			}
			//Prints out all the game pieces on the same row on the same print line.
		}
		cout << endl;
		//Ends the print line after the last game piece of each row.
	}
	return outputStream;
}

ostream & operator<<(ostream & outputStream, Gomoku const & gameClass)
{
	/*
	Overloaded function that prints out the game board specifically for GameBase objects.
	*/
	for (int i = gameClass.yCoord-1; i >= 0; i--) {
		//Starts at the top most row and goes down until it hits the bottom most row.
		for (int j = 0; j <= gameClass.xCoord-1; j++) {
			//Starts at the left most column and moves right until it hits the right most column.

			//Blank space at coordinate (0,0)
			if (i == 0 && j == 0) {
				cout << setw(3)<< "X";
			}

			else if (j == 0) {
				cout << setw(3)<< i;
			}
			else if (i == 0) {
				cout << setw(3) << j;
			}
			else if (gameClass.displayVec[(gameClass.xCoord-1 + 1)*i + j] == "") {
				cout << setw(3);
			}
			else {
				cout <<setw(3)<<gameClass.displayVec[(gameClass.xCoord-1 + 1)*i + j];
			}
			//Prints out all the game pieces on the same row on the same print line.
		}
		cout << endl;
		//Ends the print line after the last game piece of each row.
	}
	return outputStream;
}

void GameBase::setUpVector() {
	/*
	Since vectors are dynamically sized, it is important to input spaces in the display vector until
	all 36 spaces are filled with spaces. That way I can input either X's or O's at specific places in the vector
	to represent different places on the tic-tac-toe board.
	*/
	for (size_t i = 0; i < displayVec.size(); i++) {
		displayVec[i] = " ";
	}
}

