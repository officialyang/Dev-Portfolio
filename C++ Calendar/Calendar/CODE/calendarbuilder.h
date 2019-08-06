/*
Author: Jon Shidal
Purpose: declare abstract base class to represent a builder for the calendar. Declare FullCalendarBuilder
which builds all components of the calendar at once.
*/
#pragma once
#include "displayablecomponent.h"
#include <ctime>
#include <memory>

class Calendar;

class CalendarBuilder {
public:
	virtual std::shared_ptr<DisplayableComponent> buildEvent(std::shared_ptr<DisplayableComponent> cal, std::string name, std::tm when, std::string calName) = 0;
	virtual std::shared_ptr<DisplayableComponent> getComponentByDate(std::shared_ptr<DisplayableComponent> cal, std::tm d, std::string granularity) = 0;
	virtual std::shared_ptr<Calendar> buildCalendar(std::string name, size_t years) = 0;
	virtual std::shared_ptr<DisplayableComponent> buildToDo(std::shared_ptr<DisplayableComponent> cal, std::string name, std::tm when) = 0;
	virtual std::shared_ptr<DisplayableComponent> buildTask(std::shared_ptr<DisplayableComponent> cal, std::string name, std::tm when) = 0;
protected:
	// the Calendar object the builder is currently constructing and managing. Each of the above functions 
	// takes a shared_ptr to the calendar as an argument, but let's go ahead and store it anyway
	std::shared_ptr<Calendar> currentCalendar;

	// functions to build components of the calendar
	// these will be used internally only, so keep encapsulated
	virtual std::shared_ptr<DisplayableComponent> buildYear(std::tm d, std::shared_ptr<DisplayableComponent> p) = 0;
	virtual std::shared_ptr<DisplayableComponent> buildDay(std::tm d, std::shared_ptr<DisplayableComponent> p) = 0;
	virtual std::shared_ptr<DisplayableComponent> buildMonth(std::tm d, std::shared_ptr<DisplayableComponent> p) = 0;
};

// Concrete builder class
// builds a full calendar, all at once
class FullCalendarBuilder : public CalendarBuilder {
public:
	virtual std::shared_ptr<DisplayableComponent> buildEvent(std::shared_ptr<DisplayableComponent>, std::string name, std::tm when, std::string calName) override;
	virtual std::shared_ptr<DisplayableComponent> getComponentByDate(std::shared_ptr<DisplayableComponent> cal, std::tm d, std::string granularity) override;
	virtual std::shared_ptr<Calendar> buildCalendar(std::string name, size_t years) override;
	virtual std::shared_ptr<DisplayableComponent> buildToDo(std::shared_ptr<DisplayableComponent> cal, std::string name, std::tm when) override;
	virtual std::shared_ptr<DisplayableComponent> buildTask(std::shared_ptr<DisplayableComponent> cal, std::string name, std::tm when) override;
protected:
	virtual std::shared_ptr<DisplayableComponent> buildYear(std::tm d, std::shared_ptr<DisplayableComponent> p) override;
	virtual std::shared_ptr<DisplayableComponent> buildDay(std::tm d, std::shared_ptr<DisplayableComponent> p) override;
	virtual std::shared_ptr<DisplayableComponent> buildMonth(std::tm d, std::shared_ptr<DisplayableComponent> p) override;
};