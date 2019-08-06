==================================================================================
		Katrina Ragbeer (GITHUB: knragbeer, ID: 450491) 
		Pratyay Bishnupuri(GITHUB: pbishnupuri, ID: 455637) 
		Matthew Yang(GITHUB: matthewyang21, ID: 456925)
==================================================================================


Lab 5 Readme.
Overview:
Lab 5 dealt with creating a calendar interface in which a user can interact with it in many different ways. This lab tested most aspects of object-oriented programming and made use of separation of concern. The interface contains levels from years, to months, to days, and to events/todo lists, and the user can select which display they would like to see. The user can also commit actions including adding events, saving the calendar, and restoring it back. This lab deals with object-oriented principles like class hierarchy and design principles like Builder pattern, Decorator pattern and more.


Errors/Warnings During Code Writing:
-size_t vs. int warning - the solution was to adjust all the places where we assigned variables of type int to type size_t. 

1>c:\users\pbishnupuri\source\repos\lab5-ragbeer\lab5\lab5\calendarinterface.cpp(133): warning C4267: 'initializing': conversion from 'size_t' to 'int', possible loss of data
1>  calendarcomponents.cpp
1>c:\users\pbishnupuri\source\repos\lab5-ragbeer\lab5\lab5\calendarcomponents.cpp(121): warning C4267: '=': conversion from 'size_t' to 'int', possible loss of data
1>c:\users\pbishnupuri\source\repos\lab5-ragbeer\lab5\lab5\calendarcomponents.cpp(164): warning C4267: '=': conversion from 'size_t' to 'int', possible loss of data
1>c:\users\pbishnupuri\source\repos\lab5-ragbeer\lab5\lab5\calendarcomponents.cpp(201): warning C4267: 'initializing': conversion from 'size_t' to 'int', possible loss of data
1>  calendarbuilder.cpp
1>c:\users\pbishnupuri\source\repos\lab5-ragbeer\lab5\lab5\calendarbuilder.cpp(17): warning C4267: '+=': conversion from 'size_t' to 'int', possible loss of data

Cases Ran:
Creating an Event - with invalid criteria
Invalid date:
Event Name: Event
Date: (MM/DD/YYYY): 1233421312

Please enter a valid day from 1-30.

Invalid entries:
Creating an Event
index? (0-30)
9
                        Monday 10/20/2020
                        0: Evennt 2 at 10:10 am
Creating an Recurring Event (10/20/2020 repeat every 2 days for 4 times)
                        October:

        Sunday     Monday     Tuesday    Wednesday  Thursday   Friday     Saturday

                                         1          2          3          4




        5          6          7          8          9          10         11
                                                                    event 1



        12         13         14         15         16         17         18




        19         20         21         22         23         24         25
                   Evennt 2              Evennt 2              Evennt 2



        26         27         28         29         30         31
        Evennt 2

Option for ToDo only in day view
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
in
index? (0-30)
25
                        Sunday 10/26/2020
                        0: Evennt 2 at 10:10 am

zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
make todo list: todo
jump
Enter the date you would like to jump to (MM/DD/YYYY): 10/25/2020

Type 'month' for month view, 'day' for day view: day
                        Saturday 10/25/2020

zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
make todo list: todo

Creating a ToDo List
Enter the date you would like to jump to (MM/DD/YYYY): 10/25/2020

Type 'month' for month view, 'day' for day view: day
                        Saturday 10/25/2020
                        0: To Do List

Option for ToDo disappears after ToDo List is created
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge

Creating a repeat ToDo list
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
todo
Error. You already have a to do list on this day!

Zoom In
	Works

Zoom out
	Works

Jump
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
jump
Enter the date you would like to jump to (MM/DD/YYYY): 12/12/2020

Type 'month' for month view, 'day' for day view: day
                        Friday 12/12/2020

Saving 
	zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
make todo list: todo
Save
Enter the filename that you would like to save your calendar to: save3

Restoring
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
restore
Enter the filename that you would like to restore: save3
test
1
Calendar: test
0: 2018
1: 2019
2: 2020


ToDo List, add task
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore   merge calendars: merge
in
index? (0-0)
0
                        0: To Do List

zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore
new list item: new   mark complete: complete
new
Task details: stuff
got line
in add component
putting in vector
                        0: To Do List
                0: stuff -TODO
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore
new list item: new   mark complete: complete

ToDoList, mark complete 
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore
new list item: new   mark complete: complete
complete
Enter the index of the completed task: 0
                        0: To Do List
                0: stuff -COMPLETE
zoom out: out   zoom in: in   quit: q   add event: add   search event: search
jump to date: jump   save to file: save   restore file: restore
new list item: new   mark complete: complete





Lab 5 writeup:
// answer the following questions
1. Part 2.1: Adding events to the calendar
Think about the separation of concerns in the project. 
What class/classes is responsible for the user interface of the Calendar?
	CalendarInterface deals with all the user-related code. It calls display on the appropriate components, prompts the user, and asks for user 
	input, handling their input accordingly. The method that deals with this in CalendarInterface is display(). This initially prints out all 
	of the options for the Calendar, and from there the user decides what to do. It takes in the user input and matches the appropriate input 
	with the correct else-if statement. 

What class/classes is responsible for managing the representation and construction of the Calendar?
CalendarComponents is responsible for managing the representation and construction of the Calender. It holds all the constructors and methods 
for each elements of a Calendar (year, month, day, events, and todo list, task). 
CalendarBuilder is responsible for building and managing the structure of the calendar. This is where buildEvent, buildMonth, buildYear, 
buildCalendar, buildTask, buildToDo, and buildDay are defined. 



Which class should handle adding an event to the Calendar?
	The CalendarBuilder has a function called buildEvent which is called whenever the user decides they want to add an event. Build events 
	add the event to the Calendar in the appropriate date. 

Briefly discuss your implementation as opposed to other possible implementations. 
Please talk about flexibility and extensibility of your implementation choice.
	With our implementation, we decided to utilize the getComponentByDate() function. This way, we pass in the entire calendar and are 
	returned with the exact day that we wish to add our event to. After that, we create the actual event and add the component to the given 
	day. The addComponent() function deals with properly ordering the events so that they display in time order.





2. Part 2.2 Make the calendar interactive
How did you decide to efficiently search for an event by name?
		We used a multimap. Whenever an event was created, we would insert the event into the map with a key of its name, and the value 
		being the a shared_ptr<DisplayableComponent>. This map was also updated when an event was deleted or edited. Using a map allowed for 
		searching for an event to be easy, since it would just find the event using the event name. If there were multiple events found with 
		the same name, the program will display all of them with their respective dates and ask which one they would like to look at. If 
		it's wrong, then the user will be told that they had an invalid index. Or, if the event doesn't exist, the user will be told that
		as well.

How did you design saving/restoring the calendar to/from a file? 
		Basically, the program will ask the user for the name of the file they wish to save to. Then, it will go through the multimap of events 
		and store them all into the map (name, date, time). It also stores the number of events and the name of the calendar. When restoring 
		the calendar, the program asks the user for the filename they wish to restore, verifies that it's a good file, and goes through the 
		file, adding each event to the day. It also deletes all the events in the current calendar.
		To make these work, I wrote two helper methods, read() and write(). Both take in ostream&/istream& and parse the events appropriately.


3. Part 2.3 Updating the display
How a particular component in the calendar should be displayed depends on what the current view of the calendar is.
How did you implement this functionality? 
		As the calendar view and year view just required some rewriting of the display function. I had to make sure that the spacing was
		correct for months that didnt begin on the sunday. I did this by utilizing the tm_wday variable of the tm object. This allowed me to
		see how far from sunday a given day was, and place it appropriately. I would then go to a new line when the modulo of the current
		day was equal to tm_wday for the first row, then simply mod 7 for each concurrent row. This continued for the number of days in a
		given month before printing.
		The same was done for the month view, only I added implementation to also print out the events. This was a bit more challenging, as
		each event needed to be displayed prior to the next row of dates. I made it so that only 5 events would be displayed on a given day
		in order to ensure some consistency in the display of a month. I also added a trunkate method that would make sure that the event
		name was the appropriate size.
		For day, I simply printed out the day information and forwarded the display method for the events in a given day.






Did you make any changes to the interfaces provided? If so, how easy was it to 
refactor the code to match this change? 
		Yes, I added a few helper methods and instance variables in the CalendarInterface. Additionally, I changed some of the information
		stored in the displayableday and added a few methods there. I also added methods in the calendarbuilder. It was really easy to 
		refactor the code, particularly in the interface, because it was as simple as writing the method signature and defining it in the
		source file. For variables, I just ensured that they were instantiated at some point and incremented appropriately if necessary. When
		changing method signatures, I just had to be sure to look for everywhere that I later called the changed method to make sure that I
		was being consistent, but that was still a relatively simple task. 




How does your implementation maintain flexibility and extensibility of the project? Compare this with other designs you considered.
		The display implementation is very extensible because you can add as many years to the calendar and it will still fully function. I
		considered using the State design pattern for this part, and I think that would've been equally as useful, but didn't find it 
		necessary as most of the display changes only needed to happen in one place. Certain aspects of the display are also relatively 
		flexible, like the number of events you wish to display on a given day and the way you want to space everything out.The use of 
		helper methods also makes it more flexible because the programmer has the flexibility to change the method calls to change the 
		sizing, display of things, etc.






Part 3 (only answer the questions pertaining to the functionality you chose to implement)
3.1: Merging calendars
Describe the benefits of the Decorator pattern? If you used the decorator pattern, how was it applied to 
support merging calendars?
		The benefits of the Decorator pattern is that it allows you to go back and change how you want to display things however you want. So
		if instead of displaying the name of the calendar you wanted to have stars or something like that surrounding each event, that 
		could be done so relatively easily. Also, using a Decorator pattern is nice because you can "stack" the decorations if you wanted
		to. If, for instance, we wanted to show the display of an event and whether or not it was an AM event or PM event, you could simply
		add another decorator that would seamlessly display the AM or PM in the month view.
		This was applied to support merging calendars by creating a new Decorator, CalNameDecorator, which was called on every event in the 
		current calendar and every event being added to the calendar. This way, all events were shown with their calendar names. 





If you chose not to use the decorator pattern, how does your design compare with it when 
considering flexibility and extensibility of the design? 
N/A






3.2 ToDo List
Describe your implementation? How does it support easy extensibility of the project in the future?
How is the singleton pattern used to enforce only a single TODO list instance per day?

	To create the ToDo list, we implemented both the singleton and decorator pattern. First we created classes for both the ToDo Lists and 
	Tasks. The ToDo List Class has the addComponent(), markComplete(), and display() methods and the Tasks Class has the display() method. 
	To mark something as complete, we utilized the decorator pattern by creating a parent class called DCD (DisplayableComponentDecorator) 
	in which its child would be the CompleteDecorator. By calling markComplete(), a CompleteDecorator object would be constructed in its 
	place so that its display output would include -COMPLETE. For the singleton pattern, we used a boolean in the ToDo List Class called 
	singletonToDo, initially setting it to false. When a ToDo list was created for a certain day, however, singletonToDo is switched to 
	true and our code doesnt allow further creation of ToDo Lists on that day.






3.3 Incremental Builder
What challenges did you run into while implementing this? Were any changes to the builder interface required? 
How does using the builder pattern contribute to easily being able to change how an object(calendar in this case)
is represented?

