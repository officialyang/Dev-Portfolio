/*
Author: Jon Shidal
Purpose: Define builder classes, responsible for building and managing the structure of the calendar
*/
#include "stdafx.h"
#include "calendarbuilder.h"
#include "calendarcomponents.h"
#include <iostream>

using namespace std;

shared_ptr<Calendar> FullCalendarBuilder::buildCalendar(string name, size_t years) {
	currentCalendar = make_shared<Calendar>(name, years);
	// construct each year in a recursive way, add each year as a child of the calendar
	for (size_t i = 0; i < years; ++i) {
		tm y = currentCalendar->dateInfo;
		y.tm_year += i;
		y.tm_wday = (y.tm_wday + CalendarComponent::DAYSINAYEAR * i) % CalendarComponent::DAYSINAWEEK; // calculate day of the week for first day of the year
		currentCalendar->addComponent(buildYear(y, currentCalendar));
	}
	return currentCalendar;
}

// you may decide to define this.
shared_ptr<DisplayableComponent> FullCalendarBuilder::buildEvent(shared_ptr<DisplayableComponent> cal, string name, tm when, string calName) {
	shared_ptr<DisplayableComponent> nextDay = getComponentByDate(cal, when, "day");
	shared_ptr<DisplayableComponent> event = make_shared<DisplayableEvent>(when, nextDay, name);
	nextDay->addComponent(event);
	DisplayableEvent* e = dynamic_cast<DisplayableEvent*>(event.get());
	e->calName = calName;
	DisplayableDay* day = dynamic_cast<DisplayableDay*>(nextDay.get());
	//day->addNameToEvent(e->index, e->calName);
	return event;
}

shared_ptr<DisplayableComponent> FullCalendarBuilder::buildToDo(shared_ptr<DisplayableComponent> cal, string name, tm when) {
	shared_ptr<DisplayableComponent> day = getComponentByDate(cal, when, "day");
	DisplayableDay* today = dynamic_cast<DisplayableDay*>(day.get());
	if (today->singletonToDo == false) { //singleton bool is false
		shared_ptr<DisplayableComponent> toDo = make_shared<DisplayableToDoList>(when, day, name);
		day->addComponent(toDo);
		today->singletonToDo = true;
		return toDo;
	}
	else {
		cout << "Error. You already have a to do list on this day!" << endl;
		return nullptr;
	}
}

std::shared_ptr<DisplayableComponent> FullCalendarBuilder::buildTask(std::shared_ptr<DisplayableComponent> list, std::string name, std::tm when) {
	DisplayableToDoList* listptr = dynamic_cast<DisplayableToDoList*>(list.get());
	shared_ptr<DisplayableTask> newTask = make_shared<DisplayableTask>(when, list, name);
	list->addComponent(newTask);
	return std::shared_ptr<DisplayableComponent>();
}


// you may decide to define this.
shared_ptr<DisplayableComponent> FullCalendarBuilder::getComponentByDate(shared_ptr<DisplayableComponent> cal, tm d, string granularity) {
	if (granularity == "day") {
		shared_ptr<DisplayableComponent> newDay = cal->getChild(d.tm_year)->getChild(d.tm_mon)->getChild(d.tm_mday);
		return newDay;
	}
	if (granularity == "month") {
		shared_ptr<DisplayableComponent> newMonth = cal->getChild(d.tm_year)->getChild(d.tm_mon);
		return newMonth;
	}
	return nullptr;
}

shared_ptr<DisplayableComponent> FullCalendarBuilder::buildDay(std::tm d, std::shared_ptr<DisplayableComponent> p) {
	shared_ptr<DisplayableComponent> day = make_shared<DisplayableDay>(d, p);
	return day;
}

shared_ptr<DisplayableComponent> FullCalendarBuilder::buildMonth(std::tm d, std::shared_ptr<DisplayableComponent> p) {
	int index = d.tm_mon;
	shared_ptr<DisplayableComponent> m = make_shared<DisplayableMonth>(d, p, CalendarComponent::months[index], CalendarComponent::days[index]);
	for (int i = 0; i < CalendarComponent::days[index]; ++i) { // for each day in the month
		m->addComponent(buildDay(d, m)); // construct day and add as a child of the month
		++(d.tm_mday); // increment day of the month
		d.tm_wday = (d.tm_wday + 1) % CalendarComponent::DAYSINAWEEK; // increment weekday, reset to 0 if needed
	}
	return m;
}

shared_ptr<DisplayableComponent> FullCalendarBuilder::buildYear(std::tm d, std::shared_ptr<DisplayableComponent> p) {
	shared_ptr<DisplayableComponent> y = make_shared<DisplayableYear>(d, p, false);
	// construct each month and add it as a child of the year
	for (int i = 0; i < CalendarComponent::MONTHS; ++i) {
		d.tm_mon = i;
		y->addComponent(buildMonth(d, y));
		// set week day of first day of the next month
		d.tm_wday = (d.tm_wday + CalendarComponent::days[i]) % CalendarComponent::DAYSINAWEEK;
	}
	return y;
}