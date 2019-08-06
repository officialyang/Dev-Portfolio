#include "stdafx.h"
#include "CalendarInterface.h"
#include "calendarcomponents.h"
#include <iostream>
#include <sstream>
#include <algorithm>
#include <fstream>

using namespace std;

CalendarInterface::CalendarInterface(std::string builderType, size_t years) : builder(nullptr), cal(nullptr), currentDisplay(nullptr) {
	if (builderType == "full") {
		builder = make_shared<FullCalendarBuilder>();
		cal = builder->buildCalendar("test", years);
		currentDisplay = cal;
		isError = false;
		numEvents = 0;
	}
}

void CalendarInterface::display() {
	if (isError == false) {
		currentDisplay->display();
	}
	isError = false;
	DisplayableToDoList* myList = dynamic_cast<DisplayableToDoList*>(currentDisplay.get());
	if (myList != nullptr) {
		myList->displayTasks();
		cout << endl;
		cout << "zoom out: out   zoom in: in   quit: q   add event: add   search event: search\njump to date: jump   save to file: save   restore file: restore" << endl;
		cout << "new list item: new   mark complete: complete" << endl;
	}
	else {
		cout << endl;
		cout << "zoom out: out   zoom in: in   quit: q   add event: add   search event: search\njump to date: jump   save to file: save   restore file: restore   merge calendars: merge" << endl;
	}
	DisplayableEvent* e = dynamic_cast<DisplayableEvent*>(currentDisplay.get());
	if (e != nullptr) {
		cout << "edit event: edit   " << endl;
	}
	DisplayableDay* dayView = dynamic_cast<DisplayableDay*>(currentDisplay.get());
	if (dayView != nullptr) {
		if (dayView->singletonToDo == false) {
			cout << "make todo list: todo" << endl;
		}
	}
	string in;
	cin >> in;
	makeLowercase(in);
	if (in == "in") {
		DisplayableDay* d = dynamic_cast<DisplayableDay*>(currentDisplay.get());
		if (d != nullptr) { // if we are currently looking at a day
			if (d->singletonToDo == true) {
				cout << "index? (0-" << d->numEvents << ")" << endl;
			}
			else {
				cout << "index? (0-" << d->numEvents - 1 << ")" << endl;
			}
		}
		else {
			cout << "index? (0-" << currentDisplay->children.size() - 1 << ")" << endl;
		}
		int index = 0;
		cin >> index;
		zoomIn(index);
		display();
	}
	else if (in == "out") {
		zoomOut();
		display();
	}
	else if (in == "q") {
		return;
	}
	else if (in == "add") {
		string name = "";
		int recurrFor = 0;
		int recurrEvery = 0;
		int consecDays = 0;
		tm startDate = getEventInfo(name, recurrEvery, recurrFor, consecDays);
		tm originalStart = startDate;

		if (recurrEvery == 0 && recurrFor == 0 && consecDays == 0) {
			shared_ptr<DisplayableComponent> createdEvent = builder->buildEvent(cal, name, startDate, cal->name); // build the event at the current day
			CalendarInterface::eventMap.insert(pair<string, shared_ptr<DisplayableComponent>>(name, createdEvent)); // place it in the map
			numEvents++;
		}
		else {
			// looping through and adding events to all of the days that it's supposed to recur at
			// ex. if recur every 3 days 6 times, it'll loop 6 times and add events every 3 days
			for (int i = 0; i < recurrFor; i++) {
				shared_ptr<DisplayableComponent> createdEvent = builder->buildEvent(cal, name, startDate, cal->name); // build the event at the current day
				CalendarInterface::eventMap.insert(pair<string, shared_ptr<DisplayableComponent>>(name, createdEvent)); // place it in the map
				numEvents++;
				tm updated = updateDate(startDate, recurrEvery); // update the current day to be the one x days away
				startDate = updated; // this might be unnecessary; could combine this line w the one above
			}

			// now we're dealing with the multiday situation
			int filledconsec = 0;  // the number of consecutive days that we've currently filled
			if (recurrFor == 0) { recurrFor = 1; } // if recurrFor is 0 set it to 1 so it does it one time for each thing (could just auto set to 1 in the getDate func)
			while (filledconsec < consecDays) { // while we have more consecutive days to add
				if (recurrEvery > 0) { // if we have a situation of both recurring events and multiday events
					filledconsec++; // start it at 1 so that we don't readd the events from the first day
				}
				tm newStart = updateDate(originalStart, filledconsec); // update our start to be one next to the original start
				if (newStart.tm_mon == originalStart.tm_mon && newStart.tm_mday == originalStart.tm_mday && newStart.tm_year == originalStart.tm_year && filledconsec != 0) {
					cout << "Date out of bounds!" << endl;
					break;
				}
				// this is so that the first loop will go through and fill, for example, an event every 4 days
				// but now we will start at the day after the first and continue to fill every 4 days
				for (int i = 0; i < recurrFor; i++) { // so this is the same as the above, it's just filling in events at the proper recurrEvery distance
					shared_ptr<DisplayableComponent> createdevent = builder->buildEvent(cal, name, newStart, cal->name);
					CalendarInterface::eventMap.insert(pair<string, shared_ptr<DisplayableComponent>>(name, createdevent));
					numEvents++;
					tm updated = updateDate(newStart, recurrEvery);
					newStart = updated;
				}
				filledconsec++; // update how many consecutive thingies we've handled
			}
		}
		display();
	}
	else if (in == "search") {
		string eventName;
		cout << "Enter the name of the event you are looking for: ";
		cin.get();
		getline(cin, eventName);
		multimap<string, const shared_ptr<DisplayableComponent>>::const_iterator values =
			eventMap.find(eventName);
		if (values != eventMap.end()) {
			int numFound = eventMap.count(eventName);
			vector<DisplayableEvent*> foundEvents;
			for (int i = 0; i < numFound; i++) {
				DisplayableEvent* e = dynamic_cast<DisplayableEvent*>(values->second.get());
				cout << i + 1 << ". " << e->name << " on " << makeDateString(e->dateInfo) << endl;
				foundEvents.push_back(e);
				++values;
			}
			cout << "Select the number of the event you wish to display (1-" << numFound << "): ";
			int index;
			cin >> index;
			while (index > numFound || index < 1) {
				cout << "Invalid index. Select the number of the event you wish to display (1-" << numFound << "): ";
				cin >> index;
			}
			currentDisplay = builder->getComponentByDate(cal, foundEvents.at(index - 1)->dateInfo, "day");
			display();
		}
		else {
			cout << "This event doesn't exist!" << endl;
			isError = true;
			display();
		}
	}
	else if (in == "jump") {
		string jumpDate, granularity;
		cout << "Enter the date you would like to jump to ";
		int month, day, year;
		verifyDate(month, day, year);
		cout << "Type 'month' for month view, 'day' for day view: ";
		cin.get();
		getline(cin, granularity);
		if (granularity == "day" || granularity == "month") {
			tm jumpDateInfo;
			jumpDateInfo.tm_year = year - 2018;
			jumpDateInfo.tm_mday = day - 1;
			jumpDateInfo.tm_mon = month - 1;
			currentDisplay = builder->getComponentByDate(cal, jumpDateInfo, granularity);
			display();
		}
		else {
			cout << "Invalid granularity." << endl;
			isError = true;
			display();
		}
	}
	else if (in == "save") {
		cout << "Enter the filename that you would like to save your calendar to: ";
		string filename;
		cin >> filename;
		ofstream out(filename + ".txt");
		out << numEvents << "\n" << cal->name << "\n";
		for (std::multimap<string, const shared_ptr<DisplayableComponent>>::iterator it = eventMap.begin(); it != eventMap.end(); ++it) {
			write(out, (*it).second);
			out << "\n";
		}
		out.close();
		display();
	}
	else if (in == "restore") {
		cout << "Enter the filename that you would like to restore: ";
		string filename;
		cin >> filename;
		ifstream in(filename + ".txt");
		if (in.fail()) {
			cout << "Invalid filename." << endl;
			isError = true;
		}
		else {
			// delete every event in the current calendar
			for (std::multimap<string, const shared_ptr<DisplayableComponent>>::iterator it = eventMap.begin(); it != eventMap.end(); ++it) {
				shared_ptr<DisplayableComponent> eventParent = it->second->getParent().lock();
				DisplayableEvent* currEvent = dynamic_cast<DisplayableEvent*>(it->second.get());
				eventParent->removeComponent(currEvent->index);
			}
			eventMap.clear();
			numEvents = 0;
			string events, calName;
			getline(in, events);
			getline(in, calName);
			cal->name = calName;
			for (int i = 0; i < stoi(events); i++) {
				read(in, calName);
			}
			in.close();
		}
		display();
	}
	else if (in == "edit") {
		if (e == nullptr) {
			isError = true;
			display();
		}
		cout << "Do you want to delete the event? Y/N ";
		cin >> in;
		makeLowercase(in);
		if (in == "y") {
			// delete the old event at that date from the map
			typedef multimap<string, const shared_ptr<DisplayableComponent>>::iterator iterator;
			std::pair<iterator, iterator> iterpair = eventMap.equal_range(e->name);
			iterator it = iterpair.first;
			for (; it != iterpair.second; ++it) {
				if (it->second == currentDisplay) {
					eventMap.erase(it);
					break;
				}
			}
			shared_ptr<DisplayableComponent> eventParent = currentDisplay->getParent().lock();
			eventParent->removeComponent(e->index);
			// now update all of the indexes of the events after it
			currentDisplay = eventParent;
		}
		else if (in == "n") {
			cout << "edit name: name   edit date: date   edit time: time" << endl;
			cin >> in;
			makeLowercase(in);
			if (in == "name") {
				cout << "Current Name: " << e->name << endl;
				cout << "New Name: ";
				cin >> in;
				e->name = in;
			}
			else if (in == "date") {
				cout << "Current Date: " << makeDateString(e->dateInfo) << endl;
				cout << "New Date ";
				int month, day, year;
				verifyDate(month, day, year);
				e->dateInfo.tm_mon = month - 1;
				e->dateInfo.tm_mday = day - 1;
				e->dateInfo.tm_year = year - 2018;
				// delete the  old event at that date
				typedef multimap<string, const shared_ptr<DisplayableComponent>>::iterator iterator;
				std::pair<iterator, iterator> iterpair = eventMap.equal_range(e->name);
				iterator it = iterpair.first;
				for (; it != iterpair.second; ++it) {
					if (it->second == currentDisplay) {
						eventMap.erase(it);
						break;
					}
				}
				// make a new one and put it in the map
				shared_ptr<DisplayableComponent> createdEvent = builder->buildEvent(cal, e->name, e->dateInfo, cal->name); // build the event at the current day
				CalendarInterface::eventMap.insert(pair<string, shared_ptr<DisplayableComponent>>(e->name, createdEvent)); // place it in the map

				// delete it from the children array
				shared_ptr<DisplayableComponent> eventParent = currentDisplay->getParent().lock();
				eventParent->removeComponent(e->index);

				// now update all of the indexes of the events after it
				currentDisplay = eventParent;
			}
			else if (in == "time") {
				cout << "Old Time: " << makeTimeString(e->dateInfo) << endl;
				string amOrPm;
				int hour, min;
				verifyTime(hour, min, amOrPm);

				e->dateInfo.tm_min = min;

				if (amOrPm == "am" && hour == 12) {
					e->dateInfo.tm_hour = hour - 12;
				}
				else if (amOrPm == "pm" && hour == 12 || amOrPm == "am") { //pm
					e->dateInfo.tm_hour = hour;
				}
				else {
					e->dateInfo.tm_hour = hour + 12;
				}
			}
			else {
				cout << "Invalid entry." << endl;
				isError = true;
			}
		}
		else {
			cout << "Invalid input. " << endl;
			isError = true;
		}
		display();
	}
	else if (in == "todo") {
		if (dayView == nullptr) {
			isError = true;
			display();
		}
		tm addDate = dayView->dateInfo;
		addDate.tm_year -= 118;
		addDate.tm_mday -= 1;
		builder->buildToDo(cal, "To Do List", addDate);
		display();
	}
	else if (in == "new") {
		if (myList == nullptr) {
			isError = true;
			display();
		}
		string task;
		cout << "Task details: ";
		cin.get();
		getline(cin, task);
		cout << "got line" << endl;
		builder->buildTask(currentDisplay, task, myList->dateInfo);
		display();
	}
	else if (in == "complete") {
		if (myList == nullptr) {
			isError = true;
			display();
		}
		int index;
		cout << "Enter the index of the completed task: ";
		cin >> index;
		myList->markComplete(index);
		display();
	}
	else if (in == "merge") {
		cout << "Enter the filename that you would like to restore: ";
		string filename;
		cin >> filename;
		ifstream in(filename + ".txt");
		if (in.fail()) {
			cout << "Invalid filename." << endl;
			isError = true;
		}
		else {
			string events, calName;
			getline(in, events);
			getline(in, calName);
			cal->name = calName;
			for (int i = 0; i < stoi(events); i++) {
				read(in, calName);
			}
			in.close();
		}
		display();
	}
	else {
		isError = true;
		display();
	}
}

tm CalendarInterface::updateDate(tm current, int increment) {
	tm newDate = current;
	newDate.tm_mday += increment;
	int maxDay = CalendarComponent::days[current.tm_mon];
	if (newDate.tm_mday > maxDay - 1) {
		newDate.tm_mday = newDate.tm_mday % maxDay;
		if (newDate.tm_mon == 11) {
			newDate.tm_mon = 0;
			if (newDate.tm_year == 2) {
				return current;
			}
			else {
				newDate.tm_year++;
			}
		}
		else {
			newDate.tm_mon++;
		}
	}
	newDate.tm_wday = (current.tm_wday + increment) % maxDay;
	return newDate;
}

string CalendarInterface::makeDateString(tm d) {
	string parsed = "";
	parsed += std::to_string(d.tm_mon + 1) + "/" + std::to_string(d.tm_mday + 1) + "/" + std::to_string(d.tm_year + 2018);
	return parsed;
}

std::string CalendarInterface::makeTimeString(tm dateInfo) {
	string parsed = "";
	if (dateInfo.tm_hour == 0) {
		parsed += "12:";
	}
	else {
		parsed += to_string(dateInfo.tm_hour % 12) + ":";
	}
	if (dateInfo.tm_min < 10) {
		parsed += "0";
	}
	if (dateInfo.tm_hour >= 12) {
		parsed += to_string(dateInfo.tm_min) + " pm";
	}
	else {
		parsed += to_string(dateInfo.tm_min) + " am";
	}
	return parsed;
}

tm CalendarInterface::getEventInfo(string & name, int& recurrEvery, int& recurrFor, int& consecDays) {
	bool isRecur;
	tm date;
	int month, day, year;
	cout << "Event Name: ";
	cin.get();
	getline(cin, name);
	cout << "Date: ";
	verifyDate(month, day, year);

	string yesOrNo;
	cout << "Is this a recurring event? (Y/N) ";
	cin >> yesOrNo;
	cout << endl;
	if (yesOrNo == "Y" || yesOrNo == "y") {
		isRecur = true;
		cout << "This event recurs every ____ days: ";
		cin >> recurrEvery;
		cout << "How many times does this event recur? ";
		cin >> recurrFor;
		cout << endl;
	}
	else {
		isRecur = false;
		recurrEvery = 0;
		recurrFor = 0;
	}
	string yesOrNo2;
	cout << "Is this a multi-day event? (Y/N) ";
	cin >> yesOrNo2;
	cout << endl;
	if (yesOrNo2 == "Y" || yesOrNo2 == "y") {
		cout << "This event lasts for how many days? ";
		cin >> consecDays;
		cout << endl;
	}
	else {
		consecDays = 0;
	}
	string amOrPm;
	int hour, min;
	verifyTime(hour, min, amOrPm);

	date.tm_min = min;

	if (amOrPm == "am" && hour == 12) {
		date.tm_hour = hour - 12;
	}
	else if (amOrPm == "pm" && hour == 12 || amOrPm == "am") { //pm
		date.tm_hour = hour;
	}
	else {
		date.tm_hour = hour + 12;
	}
	date.tm_year = year - 2018;
	date.tm_mday = day - 1;
	date.tm_mon = month - 1;
	return date;
}

void CalendarInterface::verifyTime(int & hour, int & min, string & amOrPm) {
	string strTime;
	bool validTime = false;
	bool firstTime = true;//hard code bug fix so that if a user incorrectly inputs a time, the program doesn't screw up.

	while (!validTime) {
		cout << "Time (HH:MM AM/PM): ";
		if (firstTime) {
			cin.get();
			firstTime = false;
		}
		getline(cin, strTime);
		cout << endl;
		if (strTime.length() != 8 || !isdigit(strTime[0]) || !isdigit(strTime[1]) || !isdigit(strTime[3]) || !isdigit(strTime[4]) || !isalpha(strTime[6]) || !isalpha(strTime[7])) {
			cout << "Please enter the time in the correct format. " << endl;
			strTime = "";
		}
		else {
			hour = stoi(strTime.substr(0, 2));
			min = stoi(strTime.substr(3, 2));
			amOrPm = strTime.substr(6, 2);
			makeLowercase(amOrPm);

			if (hour < 1 || hour > 12) {
				cout << "Please enter a valid hour from 1-12." << endl;
			}
			else if (min < 0 || min > 59) {
				cout << "Please enter a valid minute from 0-59." << endl;
			}
			else if (!(amOrPm.compare("am") == 0) && !(amOrPm.compare("pm") == 0)) {
				cout << "Please enter AM or PM." << endl;
			}
			else {
				validTime = true;
			}
		}
	}
}

void CalendarInterface::verifyDate(int& month, int& day, int& year) { //helper method
	string strDate;
	cout << "(MM/DD/YYYY): ";
	cin >> strDate;
	cout << endl;
	bool validDate = false;

	while (!validDate) {
		if (strDate.length() != 10) {
			cout << "Please enter the date in the correct format." << endl;
			cin >> strDate;
		}
		else {
			month = stoi(strDate.substr(0, 2));
			day = stoi(strDate.substr(3, 2));
			year = stoi(strDate.substr(6, 4));

			if (month < 1 || month > 12) {
				cout << "Please enter a valid month from 1-12." << endl;
				cin >> strDate;
			}
			else if (day < 1 || day > CalendarComponent::days[month - 1]) {
				cout << "Please enter a valid day from 1-30." << endl;
				cin >> strDate;
			}
			else if (year < 2018 || year > 2020) {
				cout << "Please enter a valid year from 2018-2020." << endl;
				cin >> strDate;
			}
			else {
				validDate = true;
			}
		}
	}
}

void CalendarInterface::zoomIn(unsigned int index) {
	shared_ptr<DisplayableComponent> temp = currentDisplay->getChild(index);
	if (temp != nullptr) {
		currentDisplay = temp;
	}
}
void CalendarInterface::zoomOut() {
	if (currentDisplay->getParent().lock() != nullptr) {
		currentDisplay = currentDisplay->getParent().lock();
	}
}

// function to make any string lowercase
int CalendarInterface::makeLowercase(string& s) {
	if (s.empty()) {
		return -1;
	}
	else {
		transform(s.begin(), s.end(), s.begin(), ::tolower);
	}
	return 0;
}

void CalendarInterface::read(std::istream& i, string calName) {
	string name;
	tm dateInfo;
	i >> name >> dateInfo.tm_mon >> dateInfo.tm_mday >> dateInfo.tm_year >> dateInfo.tm_hour >> dateInfo.tm_min;
	shared_ptr<DisplayableComponent> createdevent = builder->buildEvent(cal, name, dateInfo, calName);
	CalendarInterface::eventMap.insert(pair<string, shared_ptr<DisplayableComponent>>(name, createdevent));
	numEvents++;
}

void CalendarInterface::write(std::ostream& o, const std::shared_ptr<DisplayableComponent>& e) {
	DisplayableEvent* event = dynamic_cast<DisplayableEvent*>(e.get());
	o << event->name << "\n" << event->dateInfo.tm_mon << "\n" << event->dateInfo.tm_mday << "\n";
	o << event->dateInfo.tm_year << "\n" << event->dateInfo.tm_hour << "\n" << event->dateInfo.tm_min;
}
