/*
Author: Jon Shidal
Purpose: declare the user interface for our calendar
*/
#pragma once
#include "calendarbuilder.h"
#include "calendarcomponents.h"
#include <memory>
#include <string>
#include <map>
#include <fstream>


class CalendarInterface {
	friend CalendarComponent;
	std::shared_ptr<Calendar> cal; // the calendar
	std::shared_ptr<CalendarBuilder> builder; // builder for managing construction of the calendar
	std::shared_ptr<DisplayableComponent> currentDisplay; // which component the user is currently viewing
public:
	std::multimap<std::string, const std::shared_ptr<DisplayableComponent>> eventMap;
	bool isError;
	// constructor
	// arguments: 1 - what type of builder? 2 - how many years to hold? 
	CalendarInterface(std::string builderType, size_t years);
	int numEvents;

	// calendar traversal functions
	void zoomIn(unsigned int index); // zoom in on a child of the current_display
	void zoomOut(); // zoom out to the parent of the current_display
	void display(); // display the current view to the user
	void verifyDate(int & month, int & day, int & year);
	void verifyTime(int & hour, int & min, std::string & amOrPm);
	tm getEventInfo(std::string & name, int& recurrEvery, int& recurrFor, int& consecDays);
	int makeLowercase(std::string& s);
	tm updateDate(tm, int);
	std::string makeDateString(tm);
	std::string makeTimeString(tm);
	void read(std::istream& i, std::string calName);
	void write(std::ostream& o, const std::shared_ptr<DisplayableComponent>& e);
};

