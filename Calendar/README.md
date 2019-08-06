# Calendar
Link: http://ec2-18-221-106-224.us-east-2.compute.amazonaws.com/~matthewyang/module5/calendar.php

## Login Information
Account 1 (PRIMARY ACCOUNT):
    Username - wustl
    Password - wustl

Account 2:
    Username - matt
    Password - wustl

## Description
For this project, we were tasked to create a calendar website where a user could log into and out of the website, create/edit/delete events that would be updated appropriately on the month display, and interact with the calendar UI by traversing through different months, all without refreshing the page. To do this, we implemented JavaScript for the client side, PHP & mySQL for the server side, HTML/CSS for the basic web structure/design, and AJAX requests to allow these functionalities without reloading the page each time.

## Creative Portion
1. The first creative functionality we implemented was allowing users to create events with certain flags, in particular choosing from 'personal,' 'work,' or 'school.' We added a column to the events database to keep track of these flags. Additionally, we created some checkboxes when the user logs in, so they can update their display each time they select/deselect a flag. For example, deselecting 'personal' while selecting 'work' and 'school' would display only the 'work' and 'school' flagged events. One can also modify these flags in the editing mode!

2. The second creative functionality we brought to life was the ability to share specific events with other users on the calendar website. To do so, just click on the event, then the share button, and type in the user you want to share the event with! We had to create a column in the events table called 'isGroup' to keep track of whether the event is grouped or not, and execute the queries accordingly. The events are linked so if you modify or delete an event on one account, the event on the other account will be likewise modified or deleted. This is a great feature to connect users within the site!

3. The final creative element we integrated was giving the users the ability to write notes for each event. To do so, edit an event like you normally would do, and simply type up a note! We had to create a column for notes in the database. Notes are synced among group events, additionally.
