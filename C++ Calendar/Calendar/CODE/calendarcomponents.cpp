/*
Author: Jon Shidal
Purpose: Define Calendar component classes.
*/

#include "stdafx.h"
#include "calendarcomponents.h"
#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

// from <ctime>
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
//

// static class variables
const std::vector<string> CalendarComponent::daysoftheweek = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
const std::vector<string> CalendarComponent::months = { "January", "February", "March", "April", "May", "June", "July", "August","September", "October", "November","December" };
const std::vector<int> CalendarComponent::days = { 31,28,31,30,31,30,31,31,30,31,30,31 };
const int CalendarComponent::DAYSINAWEEK = 7;
const int CalendarComponent::MONTHS = 12;
const int CalendarComponent::BASEYEAR = 1900;
const int CalendarComponent::DAYSINAYEAR = 365;

bool DCD::isComplete;



// CalendarComponent
CalendarComponent::CalendarComponent(std::tm d, std::shared_ptr<DisplayableComponent> p) : DisplayableComponent(p), dateInfo(d) {}


// Day
DisplayableDay::DisplayableDay(std::tm d, std::shared_ptr<DisplayableComponent> p) : CalendarComponent(d, p), numEvents(0), singletonToDo(false) {
	for (int i = 0; i < 20; i++) {
		children.push_back(nullptr);
	}
}

void DisplayableDay::display() {
	std::cout << "\t\t\t" << daysoftheweek[dateInfo.tm_wday] << " ";
	std::cout << dateInfo.tm_mon + 1 << "/" << dateInfo.tm_mday << "/" << dateInfo.tm_year + CalendarComponent::BASEYEAR << endl;
	for (size_t i = 0; i < children.size(); i++) {
		if (children[i] != nullptr) {
			children[i]->display();
		}
	}
}

std::shared_ptr<DisplayableComponent> DisplayableDay::addComponent(std::shared_ptr<DisplayableComponent> comp) {
	// try to dynamically cast comp to a pointer to an Event, will fail if the DisplayableComponent is not an event
	DisplayableEvent* d = dynamic_cast<DisplayableEvent *>(comp.get()); // can only cast regular pointers, not shared_ptrs
	if (d == nullptr) { // the cast failed, so try casting to DisplayableToDoList
		DisplayableToDoList* t = dynamic_cast<DisplayableToDoList *>(comp.get());
		if (t == nullptr) { //both casts failed
			return nullptr;
		}
		else {
			cout << numEvents << endl;
			children[numEvents] = comp;
			cout << children[numEvents] << endl;
			cout << "event should be at index " << numEvents << endl;
			t->index = numEvents;
			return comp;
		}
	}
	else {//it is a displayableEvent so, continue
		// if we have a todo list
		if (singletonToDo) {
			DisplayableToDoList* list = dynamic_cast<DisplayableToDoList*> (children[numEvents].get());
			children[numEvents + 1] = children[numEvents];
			list->index += 1;
		}
		children[numEvents] = comp;
		int currentIndex = 0;
		DisplayableEvent* prev = dynamic_cast<DisplayableEvent*> (children[currentIndex].get());
		prev->index = currentIndex;
		while (currentIndex < numEvents) {
			if (prev->dateInfo.tm_hour < d->dateInfo.tm_hour) { // if the one we are inserting is later than the one we are looking at
				prev = dynamic_cast<DisplayableEvent*> (children[currentIndex + 1].get()); // move over to the next slot for comparison
				currentIndex++;
				d->index = currentIndex;
			}
			else { // if the one we are inserting is earlier than the one we are looking at
				for (int i = numEvents; i > currentIndex; i--) { // go through and shift everything over one
					children[i] = children[i - 1];
					// update their index
					DisplayableEvent* toMove = dynamic_cast<DisplayableEvent*> (children[i].get());
					toMove->index = i;
				}
				children[currentIndex] = comp; // place the current one in the right spot
				// and update its index
				DisplayableEvent* current = dynamic_cast<DisplayableEvent*> (children[currentIndex].get());
				current->index = currentIndex;
				break;
			}
		}
		numEvents++;
	}
	return comp;
}

std::shared_ptr<DisplayableComponent> DisplayableDay::removeComponent(unsigned int index) {
	// go ahead and define a default implementation here, this should be good enough for derived classes(leaf or composite).
	if (index < children.size()) { // leaf objects will have size of 0
		shared_ptr<DisplayableComponent> removed = children[index];
		children[index] = nullptr;
		for (size_t i = index; i < children.size() - 1; i++) {
			children[i] = children[i + 1];
			DisplayableEvent* e = dynamic_cast<DisplayableEvent*>(children[i].get());
			if (e != nullptr) {
				e->index = (int)i;
			}
			else {
				break;
			}
		}
		numEvents--;
		return removed; // pointer to the removed component if successful
	}
	return nullptr; // nullptr is remove fails
}


// Month
DisplayableMonth::DisplayableMonth(std::tm d, std::shared_ptr<DisplayableComponent> p, string monthname, unsigned int numdays) : CalendarComponent(d, p), name(monthname), numberOfDays(numdays) {
	// initialize children vector, one spot for each day
	for (size_t i = 0; i < numberOfDays; ++i) {
		children.push_back(nullptr);
	}
}

void DisplayableMonth::display() {
	std::cout << "\t\t\t" << name << ":" << endl;
	std::cout << "\n\t" << "Sunday     Monday     Tuesday    Wednesday  Thursday   Friday     Saturday\n" << endl;
	printDates();
}


void DisplayableMonth::printDates() {
	std::string start = "\t";
	for (int i = 0; i < dateInfo.tm_wday; i++) {
		start += "           ";
	}
	int endLineDate = 0;
	int startLineDate = 1;
	for (size_t i = 1; i <= numberOfDays; i++) {
		if (i < 10) {
			start += to_string(i) + "          ";
		}
		else {
			start += to_string(i) + "         ";
		}
		if ((i) % 7 == 7 - dateInfo.tm_wday || (dateInfo.tm_wday == 0 && i % 7 == 0) || i == numberOfDays) {
			endLineDate = (int)i;
			std::cout << start << endl;
			start = "\t";
			if (i < 7) {
				for (int i = 0; i < dateInfo.tm_wday; i++) {
					start += "           ";
				}
			}
			int eventCount = 0;
			while (eventCount < 4) {
				for (int i = startLineDate; i <= endLineDate; i++) {
					DisplayableDay* currentDay = dynamic_cast<DisplayableDay*>(children[i - 1].get());
					DisplayableEvent* e = dynamic_cast<DisplayableEvent*>(currentDay->children[eventCount].get());
					if (e != nullptr) {
						start += trunkate(e->name, 11);
					}
					else {
						if (i < 10) {
							start += "            ";
						}
						else {
							start += "           ";
						}
					}
				}
				eventCount++;
				std::cout << start << endl;
				start = "\t";
			}
			startLineDate = endLineDate + 1;
			start = "\t";
		}
	}
}

string DisplayableMonth::trunkate(string s, int size) {
	string trunkated = "";
	int stringLength = (int)s.size();
	for (int i = 0; i < size; i++) {
		if (i < stringLength) {
			trunkated += s.at(i);
		}
		else {
			trunkated += " ";
		}
	}
	return trunkated;
}


shared_ptr<DisplayableComponent> DisplayableMonth::addComponent(shared_ptr<DisplayableComponent> comp) {
	// try to dynamically cast comp to a pointer to a DisplayableDay, will fail if the DisplayableComponent is not a day
	DisplayableDay* d = dynamic_cast<DisplayableDay *>(comp.get()); // can only cast regular pointers, not shared_ptrs
	if (d == nullptr) { // the cast failed
		return nullptr;
	}
	// otherwise, add the day to the correct location
	int dayOfMonth = d->dateInfo.tm_mday - 1;
	if (children[dayOfMonth] == nullptr) { // day does not already exist
		children[dayOfMonth] = comp;
		return comp;
	}
	else {  // day already exist, return existing day
		return children[dayOfMonth];
	}
}

// Year
DisplayableYear::DisplayableYear(std::tm d, std::shared_ptr<DisplayableComponent> p, bool l) : CalendarComponent(d, p), leap(l) {
	for (size_t i = 0; i < CalendarComponent::MONTHS; ++i) {
		children.push_back(nullptr);
	}
}

void DisplayableYear::display() {
	cout << "\tYear " << dateInfo.tm_year + CalendarComponent::BASEYEAR << ":" << endl;
	for (size_t i = 0; i < children.size(); ++i) {
		if (children[i] != nullptr) {
			DisplayableMonth* m = dynamic_cast<DisplayableMonth*>(children[i].get());
			cout << i << ". " << m->name << endl;
			cout << "\n\t" << "S   M   T   W   T   F   S\n" << endl;
			printDates(m->dateInfo, days[i], 3);
		}
	}
}

void DisplayableYear::printDates(tm d, int endDate, int numSpaces) {
	std::string start = "\t";
	string spacing = "";
	string oneLessSpace = "";
	for (int i = 0; i < numSpaces; i++) {
		spacing += " ";
		if (i < numSpaces - 1) {
			oneLessSpace += " ";
		}
	}
	for (int i = 0; i < d.tm_wday; i++) {
		start += " " + spacing;
	}
	for (int i = 1; i <= endDate; i++) {
		if (i < 10) {
			start += to_string(i) + spacing;
		}
		else {
			start += to_string(i) + oneLessSpace;
		}
		if ((i) % 7 == 7 - d.tm_wday || (d.tm_wday == 0 && i % 7 == 0) || i == endDate) {
			start += "\n";
			std::cout << start << endl;
			start = "\t";
		}
	}
}


shared_ptr<DisplayableComponent> DisplayableYear::addComponent(shared_ptr<DisplayableComponent> comp) {
	// try to dynamically cast comp to a pointer to a DisplayableMonth
	DisplayableMonth * m = dynamic_cast<DisplayableMonth *>(comp.get());
	if (m == nullptr) { // if the cast fails, return nullptr
		return nullptr;
	}
	// otherwise, add the month to the correct location
	int monthOfYear = m->dateInfo.tm_mon;
	if (children[monthOfYear] == nullptr) { // month does not already exist
		children[monthOfYear] = comp;
		return comp;
	}
	else {  // month already exist, return existing month
		return children[monthOfYear];
	}
}

// Calendar
Calendar::Calendar(string n, size_t y) : CalendarComponent(tm(), nullptr), name(n), yearsToHold(y) { // just initialize with a default tm for now.
	time_t now = time(0); // get the current time
	tm now_tm;
	gmtime_s(&now_tm, &now); // create a struct tm(now_tm) from the current time
	currentDate = now_tm;    // set Calendar's date and time to now
	dateInfo = now_tm; // setup dateInfo to represent January 1st of the current year, start time of the calendar
	dateInfo.tm_sec = 0;
	dateInfo.tm_min = 0;
	dateInfo.tm_hour = 0;
	dateInfo.tm_mday = 1;
	dateInfo.tm_mon = 0;
	// calculate and set day of the week to that of January 1st, 2018. Very sloppy, I know
	dateInfo.tm_wday = (now_tm.tm_wday + CalendarComponent::DAYSINAWEEK - (now_tm.tm_yday % CalendarComponent::DAYSINAWEEK)) % CalendarComponent::DAYSINAWEEK;
	dateInfo.tm_yday = 0;
	dateInfo.tm_isdst = 0;
	// intialize calendar to hold __ years
	for (size_t i = 0; i < yearsToHold; ++i) {
		children.push_back(nullptr);
	}
}

void Calendar::display() {
	cout << "Calendar: " << name << endl;
	for (size_t i = 0; i < children.size(); ++i) { // forward request to all children
		if (children[i] != nullptr) {
			/*children[i]->display();*/
			DisplayableYear* y = dynamic_cast<DisplayableYear*>(children[i].get());
			cout << i << ": " << y->dateInfo.tm_year + 1900 << endl;
		}
	}
}


shared_ptr<DisplayableComponent> Calendar::addComponent(std::shared_ptr<DisplayableComponent> comp) {
	DisplayableYear* y = dynamic_cast<DisplayableYear *>(comp.get());
	if (y == nullptr) { // if the cast fails, return nullptr
		return nullptr;
	}
	int calendarYear = CalendarComponent::BASEYEAR + dateInfo.tm_year;
	int yearAdding = CalendarComponent::BASEYEAR + y->dateInfo.tm_year;
	unsigned int index = yearAdding - calendarYear; // which child?
	if (index >= 0 && index < children.size() && children[index] == nullptr) {
		children[index] = comp;
		return comp;
	}
	else {
		return nullptr;
	}
}

DisplayableEvent::DisplayableEvent(std::tm d, std::shared_ptr<DisplayableComponent> p, std::string s) : CalendarComponent(d, p), name(s) {};

void DisplayableEvent::display() {
	if (dateInfo.tm_hour == 0 || dateInfo.tm_hour == 12) {
		cout << "\t\t\t" << index << ": " << name << " at 12" << ":";
	}
	else {
		cout << "\t\t\t" << index << ": " << name << " at " << (dateInfo.tm_hour % 12) << ":";
	}
	if (dateInfo.tm_min < 10) {
		cout << "0";
	}
	if (dateInfo.tm_hour >= 12) {
		cout << dateInfo.tm_min << " pm" << endl;
	}
	else {
		cout << dateInfo.tm_min << " am" << endl;
	}
}


DisplayableToDoList::DisplayableToDoList(std::tm d, std::shared_ptr<DisplayableComponent> p, std::string name) : CalendarComponent(d, p), name("To Do List") {
	for (size_t i = 0; i < 20; i++) { // maximum number of list items is 20
		children.push_back(nullptr);
	}
	numItems = 0;
};


void DisplayableToDoList::display() {
	cout << "\t\t\t" << index << ": " << name << endl;
}

std::shared_ptr<DisplayableComponent> DisplayableToDoList::addComponent(std::shared_ptr<DisplayableComponent> comp) {
	DisplayableTask* task = dynamic_cast<DisplayableTask*>(comp.get());
	if (task == nullptr) {
		return nullptr;
	}
	std::shared_ptr<ToDoDecorator> TD = make_shared<ToDoDecorator>(comp);
	children[numItems] = TD;
	task->index = numItems;
	numItems++;
	return comp;
}

void DisplayableToDoList::displayTasks() {
	for (size_t i = 0; i < children.size(); i++) {
		if (children[i] != nullptr) {
			children[i]->display();
		}
	}
}

void DisplayableToDoList::markComplete(unsigned int x) {
	auto variable = getChild(x);
	if (variable != nullptr) {
		std::shared_ptr<CompleteDecorator> CD = make_shared<CompleteDecorator>(variable);
		children[x] = CD;
	}
}

void DisplayableDay::addNameToEvent(unsigned int x, string name) {
	auto variable = getChild(x);
	if (variable != nullptr) {
		std::shared_ptr<CalNameDecorator> CD = make_shared<CalNameDecorator>(variable, name);
		children[x] = CD;
	}
}

DisplayableTask::DisplayableTask(std::tm d, std::shared_ptr<DisplayableComponent> p, std::string name) : CalendarComponent(d, p), name(name) {}

void DisplayableTask::display() {
	if (index == 0) {
		cout << "\t\t" << index << ": " << name;
	}
	else {
		cout << "\n\t\t" << index << ": " << name;
	}
	
}

CompleteDecorator::CompleteDecorator(std::shared_ptr<DisplayableComponent> dc) : DCD(dc){
	isComplete = false;
}

void CompleteDecorator::display() {
	isComplete = true;
	component->display();
	cout << " -COMPLETE";
	isComplete = false;
}

CalNameDecorator::CalNameDecorator(std::shared_ptr<DisplayableComponent> dc, string name) : DCD(dc), calName(name) {}

void CalNameDecorator::display() {
	cout << calName << "::";
	component->display();
}

DCD::DCD(std::shared_ptr<DisplayableComponent> dc): component(dc) {}

std::shared_ptr<DisplayableComponent> DCD::getChild(unsigned int index) {
	if (index < children.size()) {
		return children[index];
	}
	return nullptr;
}

ToDoDecorator::ToDoDecorator(std::shared_ptr<DisplayableComponent> dc): DCD(dc)
{
}

void ToDoDecorator::display()
{
	component->display();
	if (!DCD::isComplete) {
		cout << " -TODO";
	}
}
