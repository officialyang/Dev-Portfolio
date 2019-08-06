#pragma once
/*
Author: Jon Shidal
Purpose:
This file contains declarations for various components used in a Calendar, as well as the Calendar itself.
All components inherit from DisplayableComponent and have a member variable that is a std::tm object, representing
its date and time.
*/
#include "displayablecomponent.h"
#include<ctime>
#include<string>

// here is the layout of the tm struct, it is declared in <ctime>

//struct tm {
//	int tm_sec;   // seconds of minutes from 0 to 61
//	int tm_min;   // minutes of hour from 0 to 59
//	int tm_hour;  // hours of day from 0 to 24
//	int tm_mday;  // day of month from 1 to 31
//	int tm_mon;   // month of year from 0 to 11
//	int tm_year;  // year since 1900
//	int tm_wday;  // days since sunday
//	int tm_yday;  // days since January 1st
//	int tm_isdst; // hours of daylight savings time
//}

// forward declarations needed to avoid circular includes, used to declare friends only
class FullCalendarBuilder;
class CalendarInterface;

class CalendarComponent : public DisplayableComponent {
	friend FullCalendarBuilder;
	friend CalendarInterface;
public:
	// inherited
	virtual void display() = 0;
	// stores date/time associated with this component
	// see struct tm details above
	std::tm dateInfo;
protected:
	std::string state;

	// constructor, protected is ok. Builder class is a friend
	CalendarComponent(std::tm, std::shared_ptr<DisplayableComponent>);

	// some static constants to use in place of hardcoded calendar values
	static const std::vector<std::string> daysoftheweek;
	static const std::vector<std::string> months;
	static const std::vector<int> days;
	static const int DAYSINAWEEK;
	static const int MONTHS;
	static const int BASEYEAR;
	static const int DAYSINAYEAR;
};


class DisplayableTask : public CalendarComponent {
	friend class DisplayableToDoList;
private:
	//bool isComplete;
public:
	int index;
	std::string name;
	DisplayableTask(std::tm, std::shared_ptr<DisplayableComponent>, std::string name);
	virtual void display() override;
	//void displayHelper(bool isComplete);
};


class DisplayableToDoList : public CalendarComponent {
	friend class DisplayableDay;
public:
	std::string state;
	int index;
	int numItems;
	std::string name;
	DisplayableToDoList(std::tm, std::shared_ptr<DisplayableComponent>, std::string name);
	virtual void display() override;
	virtual std::shared_ptr<DisplayableComponent> addComponent(std::shared_ptr<DisplayableComponent>) override;
	void displayTasks();
	void markComplete(unsigned int);
};

class DCD :public DisplayableComponent {
	static bool isComplete;
	friend class CompleteDecorator;
	friend class ToDoDecorator;
protected:
	std::shared_ptr<DisplayableComponent> component;
	//bool isComplete;
public:
	DCD(std::shared_ptr<DisplayableComponent> dc);
	std::shared_ptr<DisplayableComponent> getChild(unsigned int index);
};

class CompleteDecorator : public DCD {
	friend class DCD;
public:
	CompleteDecorator(std::shared_ptr<DisplayableComponent> dc);
	void display();
};

class ToDoDecorator : public DCD {
	friend class DCD;
public:
	ToDoDecorator(std::shared_ptr<DisplayableComponent> dc);
	void display();
	//bool isComplete;
};

class CalNameDecorator : public DCD {
public:
	std::string calName;
	CalNameDecorator(std::shared_ptr<DisplayableComponent> dc, std::string name);
	void display();
};

class DisplayableDay : public CalendarComponent {
	friend class DisplayableMonth;
	friend FullCalendarBuilder;
	friend CalendarInterface;
private:
	bool singletonToDo;
public:
	int numEvents;
	// 1st argument = start date/timeof the day, 2nd argument = its parent
	DisplayableDay(std::tm, std::shared_ptr<DisplayableComponent>);
	virtual void display() override;
	virtual std::shared_ptr<DisplayableComponent> addComponent(std::shared_ptr<DisplayableComponent>) override;
	virtual std::shared_ptr<DisplayableComponent> removeComponent(unsigned int) override;
	void addNameToEvent(unsigned int x, std::string name);
};

class DisplayableEvent : public CalendarComponent{
	friend DisplayableDay;
public:
	std::string name;
	int index;
	std::string calName;
	DisplayableEvent(std::tm, std::shared_ptr<DisplayableComponent>, std::string name);
	virtual void display() override;
};

class DisplayableMonth : public CalendarComponent {
	friend class DisplayableYear;
	friend FullCalendarBuilder;
	friend CalendarInterface;
public:
	// arguments = date/time info, its parent, name of the month, days in the month
	DisplayableMonth(std::tm, std::shared_ptr<DisplayableComponent>, std::string monthname, unsigned int numdays);
	virtual void display() override;
protected:
	std::string name;
	unsigned int numberOfDays;
	// Month contains days, so it is a composite object. override addComponent accordingly
	virtual std::shared_ptr<DisplayableComponent> addComponent(std::shared_ptr<DisplayableComponent>) override;
	void printDates();
	std::string trunkate(std::string, int);
};

class Calendar;

class DisplayableYear : public CalendarComponent {
	friend Calendar;
	friend FullCalendarBuilder;
	friend CalendarInterface;
public:
	// arguments: date/time info, parent, leap year or no?
	DisplayableYear(std::tm, std::shared_ptr<DisplayableComponent>, bool);
	virtual void display() override;
protected:
	bool leap;
	// year contains months - override accordingly
	virtual std::shared_ptr<DisplayableComponent> addComponent(std::shared_ptr<DisplayableComponent>) override;
	void printDates(tm d, int endDate, int numSpaces);
};

class Calendar : public CalendarComponent {
	// friends
	friend FullCalendarBuilder;
	friend CalendarInterface;
protected:
	std::string name;
	size_t yearsToHold;
	std::tm currentDate; // current date and time
						 // dateInfo is the start date and time

						 // Calendar contains years, so override accordingly
	virtual std::shared_ptr<DisplayableComponent> addComponent(std::shared_ptr<DisplayableComponent>) override;
public:
	// arguments: name of the calendar, length of the calendar in years
	Calendar(std::string n, size_t y);
	// inherited methods
	virtual void display() override;
};

