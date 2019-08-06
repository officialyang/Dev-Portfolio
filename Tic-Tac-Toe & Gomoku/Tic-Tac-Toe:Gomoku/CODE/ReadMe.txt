========================================================================
    CONSOLE APPLICATION : Lab4 Project Overview
========================================================================
Matthew Yang (GITHUB: matthewyang21) - Refactored Lab 3 code, implemented Gomoku program, and wrote readMe & comments.   
Pratyay Bishnupuri (GITHUB: pbishnupuri) - Hashed out lab concepts, implemented Gomoku program, and solved warnings/errors.

*Extension Granted until Nov. 11 11:59 pm*

Lab 4

Lab 4 dealt with object-oriented programming principles, including inheritance and class hierarchy, in the forms of 
the base class and subclasses TicTacToe and Gomoku. In essence, the user can select which game to play -- TicTacToe or Gomoku -- 
and then play with either X's and O's or Black and White pieces, respectively. 
The user can input their movies via x,y coordinate formate, and play until the game registers a win, draw, or quit. 
This program follow conventional tic-tac-toe and gomoku rules.


Errors/Warnings Encountered During Code Writing:

- c:\users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\lab4\games.cpp(450): warning C4018: '>': signed/unsigned mismatch - to fix this warning, we just casted the arithmatic phrase to 
a size_t datatype to match the comparison to displayVec.size().
- c:\users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\lab4\games.cpp(492): warning C4715: 'GameBase::prompt': not all control paths return a value - this warning is appropriate 
to have in my prompt() method since that method is recursively called -- the user willbe constantly asked for valid coordinates -- 
until they input an actual valid coordinate (returns a success value) quit the game (returns a program quit value).
-"subscript out of range" program fail - this program failure occured after trying to input a piece at a coordinate too early in the vector (e.g. (1,1)).
The solution was to modify our done() method so that it checks upwards (i.e. up the vector) versus downwards. To do this, we also had to enlarge our displayVec so that it could check
upwards at a coordinate like (19,19).


Cases Ran:
-With no command line arguments (other than the program name)
"C:\Users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\Debug\Lab4.exe"
"Usage: Lab4.exe <GameName>
Command Line Arguments: 'ProgramName.exe' 'GameName'"

-With two command line arguments (other than the program name)
"C:\Users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\Debug\Lab4.exe TicTacToe Gomoku" returned
"Usage: Lab4.exe <GameName>
Command Line Arguments: 'ProgramName.exe' 'GameName'"

-With an incorrectly inputted game name
"C:\Users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\Debug\Lab4.exe TicTmo" returned
"Usage: Lab3.exe <GameName>
Command Line Arguments: 'ProgramName.exe' 'GameName'"

-With correctly inputted gamename (TicTacToe)
C:\Users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\Debug>lab4.exe TicTacToe
4
3
2
1
0
 0 1 2 3 4
 
-With correctly inputted gamename (Gomoku)
C:\Users\ppbis\source\repos\lab4-lab4-teammattyay3\lab4\Debug>lab4.exe Gomoku
 19
 18
 17
 16
 15
 14
 13
 12
 11
 10
  9
  8
  7
  6
  5
  4
  3
  2
  1
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Gomoku Testing
1. Vertical win 
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
1,5
 19                                                        W
 18                                                     W
 17                                                  W
 16
 15
 14                                         W
 13
 12
 11
 10
  9
  8
  7
  6
  5  B
  4  B
  3  B
  2  B
  1  B
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Player Black: 1,1; 1,2; 1,3; 1,4; 1,5

Black won!


2. Horizontal Win 
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
5,1
 19                                                        W
 18                                                     W
 17                                                  W
 16
 15
 14
 13                                            W
 12
 11
 10
  9
  8
  7
  6
  5
  4
  3
  2
  1  B  B  B  B  B
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Player Black: 1,1; 2,1; 3,1; 4,1; 5,1

Black won!

3. Right Diagonal Win
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
5,5
 19                                                        B
 18                                                     B
 17                                            B
 16
 15                                            B     B
 14
 13
 12
 11
 10
  9
  8
  7
  6
  5              W
  4           W
  3        W
  2     W
  1  W
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Player White: 1,1; 2,2; 3,3; 4,4; 5,5

White won!

4. Left Diagonal Win
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
1,5
 19                                            W           W
 18                                               W
 17
 16
 15                                            W
 14
 13
 12
 11
 10
  9
  8
  7
  6
  5  B
  4     B
  3        B
  2           B
  1              B
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Player Black: 5,1; 4,2; 3,3; 2,4; 1,5

Black won!


5. Quit
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
5,5
 19
 18
 17
 16
 15
 14
 13
 12
 11
 10
  9
  8
  7
  6
  5              B
  4
  3
  2
  1
  X  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

Player Black: 5,5
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
quit
The game was quit. Number of turns: 1

The game correctly identified the user's desire to quit mid-game. Additionally, it printed out the number of turns the game had been played up to that point.

6. Draw
We did not find it reasonable to check draw by doing 361 turns. So we tested the Draw method by using the concept of it 
and applying it to the smaller size. Since draw checks if 361 turns has been made, meaning that every position in the 
board is full, we lowered the limit of turns to 20 and made 20 turns. The program outputted that the game 
was a draw when 20 turns were made, so it would also apply for 361 turns. 

7. Invalid inputs
Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
hhsakjdhsjkahdfkas

Enter numerical values only. Please try again

Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
"4,4

Enter numerical values only. Please try again

Type 'quit' to end the game or enter a valid coordinate on the board in x,y format.
20,20

Invalid coordinate. Please try again

