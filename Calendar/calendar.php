<?php 
ini_set("session.cookie_httponly", 1);
session_start(); 
require 'database.php';
?>
<!DOCTYPE html>
<html lang="en">
    
 <head>
   <title>Calendar</title>
   <meta charset="utf-8">
   <meta name="viewport" content="initial-scale=1, maximum-scale=1, width=device-width">
   <link href="calendar.css" rel="stylesheet">
   <!-- I DO NOT OWN jQuery UI DIALOG. Source for JQuery Library: jQuery UI Dialog - https://jqueryui.com/dialog/ -->
   <link rel="stylesheet" href="jquery-ui-1.12.1.custom/jquery-ui.min.css">
    <script src="jquery-ui-1.12.1.custom/external/jquery/jquery.js"></script>
    <script src="jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>

   <script>
        function notEmptyInput(isLogin){
            let username = "";
            let password = "";
            let password2 = "";

            if (isLogin){ //It's login
                username = document.getElementById("username1").value;
                password = document.getElementById("password1").value;
            }
            else { //Then it's create user
                username = document.getElementById("username2").value;
                password = document.getElementById("password2").value;
                password2 = document.getElementById("password3").value;
            }
            
            let validInput = true;
            
            if (isLogin){ //It's login
                if (!password.match(/\S/) || !username.match(/\S/)){
                    $("#message1").text("Please enter a username and/or password.");
                    validInput = false;
                }
            }
            else{ //Then it's create user
                if (!username.match(/\S/) || !password.match(/\S/) || !password2.match(/\S/)){
                    $("#message2").css('color', 'red');
                    $("#message2").text("Please enter a username and/or password.");
                    validInput = false;
                }
                if (password!=password2){
                    $("#message2").css('color', 'red');
                    $("#message2").text("Your passwords do not match.");
                    validInput = false;
                }
            }
            return validInput;
        }

        function validLogIn(){
            let username = $("#username1").val();
            let password = $("#password1").val();

            $.ajax({ //Creating Ajax Request
                type: "post",
                url: "checkLogin.php",
                data: { //Passing this data into server code (checkLogin.php)
                    username1: username,
                    password1: password,
                },

                success: function (response){
                    let jsonData = JSON.parse(response);
                    if (jsonData.success){
                        //The user should be logged in now!
                        //Assign token values to the appropriate forms for CSRF checking
                        $("#edit_token").val(jsonData.token);
                        $("#create_token").val(jsonData.token);
                        $("#delete_token").val(jsonData.token);
                        $("#share_token").val(jsonData.token);
                        $("#share_cal_token").val(jsonData.token);
                        
                        //Clear "Log In" & "Create Account"
                        $("#log_in").text("");
                        $("#partition1").text("");
                        $("#create_account").text("");

                        //Setup "Log Out" & "Welcome Message"
                        $("#log_out").text("Log Out");
                        $("#partition2").text(" | "); 
                        $("#welcome_message").text("Welcome " + username + "!");
                        $("#dialog-form1").dialog("close");

                        //Show the "Create Event" button & checkboxes
                        document.getElementById("create_event_button").style.visibility = "visible";
                        document.getElementById("checkboxes").style.visibility = "visible";
                        $("#display_personal").prop("checked", true);
                        $("#display_work").prop("checked", true);
                        $("#display_school").prop("checked", true);

                        //Load Events
                        loadEvents();
                    }
                    else{
                        $("#message1").text("Invalid Login");
                    }
                }
            
            });
            return false;
        }

        function validCreateUser(){
            let username = $("#username2").val();
            let password = $("#password2").val();

            $.ajax({ //Creating AJAX request
                type: "POST",
                url: "checkCreateUser.php",
                data: { //passing this data into server code (checkCreateUser.php)
                    username2: username,
                    password2: password,
                },

                success: function(response){
                    if (response == "success"){
                        $("#message2").css('color', 'green');
                        $("#message2").text("Account successfully created!");
                        
                        return true;
                    }
                    else if (response == "username_exists"){
                        $("#message2").css('color', 'red');
                        $("#message2").text("Username already taken.");
                    }
                }
            })
            return false;
        }

        function createEvent(){
            let token = $("#create_token").val();
            let title = $("#title_input").val();
            let date = $("#date_input").val();
            let time = $("#time_input").val();

            let personal1 = $("#personal:checked").val();
            let work1 = $("#work:checked").val();
            let school1 = $("#school:checked").val();

            let tag = "";

            if (personal1 == 'on'){
                tag = "personal";
            }
            else if (work1 == 'on'){
                tag = "work";
            }
            else if (school1 == 'on'){
                tag = "school";
            }

            if (title == "" || date == "" || time == ""){
                //If any inputs are blank, print usage message
                $("#create_event_usagemessage").text("Please fill in all inputs.");
                $("#create_event_usagemessage").css('color','red');
            }
            else{
                $("#create_event_usagemessage").text("");

                $.ajax({ //Creating AJAX request
                type: "POST",
                url: "addEvent.php",
                data: { //passing this data into server code (addEvent.php)
                    title: title,
                    date: date,
                    time: time,
                    token: token,
                    tag: tag,
                },

                success: function(response){
                    if (response == "success"){
                        //Update Calendar View & print success message
                        $("#create_event_usagemessage").text("Event created!");
                        $("#create_event_usagemessage").css('color','green');
                        updateCalendar();
                    }
                    else{
                        //Error!
                        $("#create_event_usagemessage").text("Error in creating event.");
                        $("#create_event_usagemessage").css('color','red');
                    }
                }
            })
            }
        }

        function deleteEvent(title, date, time){
            let token = $("#delete_token").val();
            $.ajax({ //Creating AJAX request
                type: "POST",
                url: "deleteEvent.php",
                data: { //passing this data into server code (deleteEvent.php)
                    title: title,
                    date: date,
                    time: time,
                    token: token,
                },

                success: function(response){
                    if (response == "success"){
                        //proceed to update view
                        updateCalendar();
                    }
                    else{
                        alert("Unable to delete event.");
                    }
                }
            })
        }

        function saveEdit(afterTitle, afterDate, afterTime, afterTag, afterNotes, beforeTitle, beforeDate, beforeTime, beforeTag, beforeNotes){
            let token = $("#edit_token").val();
            $.ajax({ //Creating AJAX request
                type: "POST",
                url: "saveEdit.php",
                data: { //Passing this data into server code (saveEdit.php)
                    afterTitle: afterTitle,
                    afterDate: afterDate,
                    afterTime: afterTime,
                    afterTag: afterTag,
                    afterNotes: afterNotes,
                    beforeTitle: beforeTitle,
                    beforeDate: beforeDate,
                    beforeTime: beforeTime,
                    beforeTag: beforeTag,
                    beforeNotes: beforeNotes,
                    token: token,
                },

                success: function(response){

                    if (response == "success"){
                        //proceed to update view
                        updateCalendar();
                    }
                    else{
                        alert("Unable to edit event.");
                    }
                }
            })
        }

        function shareWith(title, date, time, tag, notes, username){
            let token = $("#share_token").val();
            $.ajax({
                    type: "POST",
                    url: "shareWith.php",
                    data: {
                        title: title,
                        date: date,
                        time: time,
                        tag: tag,
                        notes: notes,
                        token: token,
                        username_input: username,
                    },
                    success: function(response){
                        if (response == "success"){
                            //if successful, then print green success message
                            $("#share_with_usagemessage").text("Shared successfully!");
                            $("#share_with_usagemessage").css("color", "green");
                        }
                        else if (response == "sameUser"){
                            //this is you!
                            $("#share_with_usagemessage").text("This is you!");
                            $("#share_with_usagemessage").css("color", "red");
                        }
                        else{
                            //else, print red failure message
                            $("#share_with_usagemessage").text("Sharing failed!");
                            $("#share_with_usagemessage").css("color", "red");
                        }
                    }
                    

                });
        }



        function loadEvents(){
            $.ajax({
                type: "POST",
                url: "loadEvents.php",
                success: function (response){
                    if (response == "failure"){
                        
                    }
                    else {
                        //Parse Response if successful
                        let list_of_titles = [];
                        let list_of_dates = [];
                        let list_of_times = [];
                        let list_of_tags = [];
                        let list_of_notes = [];
                        let title = '';
                        let date = '';
                        let time = '';
                        let tag = '';
                        let notes = '';
                        let placeholder = 0;
                        
                        for (i = 0; i < response.length; i++){
                            if(response[i] == ","){ //Parsing Title
                                title = response.substring(placeholder,i);
                                placeholder = i+1;
                                list_of_titles.push(title);
                            }
                            if(response[i] == "."){ //Parsing Date
                                date = response.substring(placeholder,i);
                                placeholder = i+1;
                                list_of_dates.push(date);
                            }
                            if(response[i] == "/"){ //Parsing Time
                                time = response.substring(placeholder,i);
                                placeholder = i+1;
                                list_of_times.push(time);
                            }
                            if (response[i] == "?"){ //Parsing Tag
                                tag = response.substring(placeholder, i);
                                placeholder = i + 1;
                                list_of_tags.push(tag);
                            }
                            if (response[i] == ")"){ //Parsing Notes
                                notes = response.substring(placeholder, i);
                                placeholder = i + 1;
                                if (!notes){
                                    notes = " ";
                                }
                                list_of_notes.push(notes);
                            }
                            
                        }
                        for (i = 0; i < list_of_titles.length; i++){
                            if (list_of_dates[i].substring(0,4) == $("#year").text()){
                                    if (month_array[Number(list_of_dates[i].substring(5,7))-1] == $("#month").text()){
                                        let thisEventTag = "#display_"+list_of_tags[i]+":checked";
                                        if (list_of_tags[i]=="personal"){
                                            thisColor = "darkgreen";
                                        }
                                        else if (list_of_tags[i] == 'work'){
                                            thisColor = "darkblue";
                                        }
                                        else{
                                            thisColor = 'darkred';
                                        }
                                        if ($(thisEventTag).val() == "on"){
                                        //At this point, the event is in this current month & year display. Proceed to populate the display.
                                            $("td").each(function(){
                                                //Checking to see if it's a double digit
                                                if (Number(list_of_dates[i].substring(8,10)) == Number($(this).text().substring(0,2))){
                                                    $(this).html($(this).html() + "<ul class = 'listed_event' id = 'event" + Number(i) + "'>" + list_of_titles[i] + "</ul>");
                                                    $("#event" + Number(i)).css("color", thisColor);
                                                }
                                                //If not, then checking to see if it's a single digit (that's already populated with an event)
                                                else if (Number(list_of_dates[i].substring(8,10)) == Number($(this).text().substring(0,1)) && isNaN($(this).text().substring(1,2))){
                                                    $(this).html($(this).html() + "<ul class = 'listed_event' id = 'event" + Number(i) + "'>" + list_of_titles[i] + "</ul>");
                                                    $("#event"+Number(i)).css("color", thisColor);
                                                }
                                            })
                                    }
                                }
                        }
                    }
                        $(".listed_event").click(function() {
                                //Need to determine which event was selected and set title, date and time values.
                                let selected_id = $(this).attr('id');
                                const n = selected_id.lastIndexOf('t') + 1; //This is the index of start of the event num
                                let event_num = Number(selected_id.substring(n, selected_id.length));

                                $("#event_title").text(list_of_titles[event_num]);
                                $("#event_date").text(list_of_dates[event_num]);
                                $("#event_time").text(list_of_times[event_num]);
                                $("#event_tag").text(list_of_tags[event_num]);
                                
                                $("#event_notes").text(list_of_notes[event_num]);
                                $("#dialog-form3").dialog("open");
                        });
                            
                            
                    }  
                }
            })
            
            
        }

    </script>
 </head>

 <body>
    <h1>MyCalendar</h1>
    <div id = "subheading"><a id = "log_in">Log In</a><span id = "partition1"> | </span><a id = "create_account">Create Account</a></div>
    <div id = "subheading2"><a id = "log_out"></a><span id = "partition2"></span><span id = "welcome_message"></span></div> 
    <br>
    <div id = "create_event"><button id = "create_event_button">Create Event</button></div>
    <br>
    <div id = "checkboxes">
        <input type="checkbox" id="display_personal"><label for="display_personal">Personal</label>
        <input type="checkbox" id="display_work"><label for="display_work">Work</label>
        <input type="checkbox" id="display_school"><label for="display_school">School</label>
    </div>
    <br>
    <div id = "month_and_arrows"><span id = "left_arrow">&larr; </span><span id = "month_and_year"><span id ="month"></span> <span id="year"></span></span><span id = "right_arrow"> &rarr;</span></div>
    <br><br>

    <!-- Layout of the Calendar -->
    <table>
        <tr id = "days_of_the_week">
            <th>SUN</th>
            <th>MON</th>
            <th>TUE</th> 
            <th>WED</th>
            <th>THU</th>
            <th>FRI</th> 
            <th>SAT</th>
         </tr>
         <tr id = "week1">
             <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
        <tr id = "week2">
            <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
        <tr id = "week3">
            <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
        <tr id = "week4">
            <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
        <tr id = "week5">
            <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
        <tr id = "week6">
            <td class = "sun"></td>
             <td class = "mon"></td>
             <td class = "tue"></td>
             <td class = "wed"></td>
             <td class = "thu"></td>
             <td class = "fri"></td>
             <td class = "sat"></td>
        </tr>
    </table>

    <script src="calendar.js"></script>
    <script src="calendar_helper_functions.js"></script>

    <!-- Help from: http://jsfiddle.net/5yhmb/23/ -->
    <script>
//LOGIN POP UP
$(function() {
    $("#dialog-form1").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Log In": function() {
                if (notEmptyInput(true)){
                    $("#message1").text("");
                    //User inputted username & passwords. Now need to check (with PHP) that the username & password exist in the database.
                    validLogIn();
                }

            },
            "Cancel": function() {
                $(this).dialog("close");
            }
        }
    });


    $('#log_in').click(function() {
        document.getElementById('password1').value = "";
        $("#message1").text("");
        $("#dialog-form1").dialog("open");
    });

});

//CREATE ACCOUNT POPUP
$(function() {
    $("#dialog-form2").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Create Account": function() {
                if (notEmptyInput(false)){
                    $("#message2").text("");
                    //User inputted username & passwords. Now need to check (with PHP) that the username & password exist in the database.
                    validCreateUser();
                }

            },
            "Cancel": function() {
                $(this).dialog("close");
            }
        }
    });
    $('#create_account').click(function() {
        document.getElementById('password2').value = "";
        document.getElementById('password3').value = "";
        $("#message2").text("");
        $("#dialog-form2").dialog("open");
    });

});


//CREATE NEW EVENT POPUP
$(function() {
    $("#dialog-form4").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Create": function() {
                createEvent();
            },
            "Cancel": function() {
                $("#title_input").val("");
                $("#date_input").val("");
                $("#time_input").val("");
                $("#create_event_usagemessage").text("");
                $(this).dialog("close");
            }
        }
    });
    //Create Event Button is clicked
    $('#create_event_button').click(function(){
        $("#dialog-form4").dialog("open");
        });
});


//EXISTING EVENT POPUP
$(function() {
    $("#dialog-form3").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Share":function(){
                thisTitle = $("#event_title").text();
                thisDate = $("#event_date").text();
                thisTime = $("#event_time").text();
                thisTag = $("#event_tag").text();
                thisNotes = $("#event_notes").text();
                $(this).dialog("close");
                $("#dialog-form6").dialog("open");
            },
            
            "Edit": function() {
                thisTitle = $("#event_title").text();
                thisDate = $("#event_date").text();
                thisTime = $("#event_time").text();
                thisTag = $("#event_tag").text();
                thisNotes = $("#event_notes").text();
                $(this).dialog("close");
                
                $("#title_edit").val(thisTitle);
                $("#date_edit").val(thisDate);
                $("#time_edit").val(thisTime);
                $("#notes_edit").val(thisNotes);
                if (thisTag == "personal"){
                    $("#personal_edit").prop("checked", true);
                }
                else if (thisTag == "work"){
                    $("#work_edit").prop("checked", true);
                }
                else {
                    $("#school_edit").prop("checked", true);
                }
                
                $("#dialog-form5").dialog("open");

            },
            "Cancel": function() {
                $(this).dialog("close");
            }
        }
    });

});

//EDIT EVENT POPUP
$(function() {
    $("#dialog-form5").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Delete": function() {
                thisTitle = $("#event_title").text();
                thisDate = $("#event_date").text();
                thisTime = $("#event_time").text();
                deleteEvent(thisTitle, thisDate, thisTime);
                $(this).dialog("close");
            },
            "Save": function() {
                afterTitle = $("#title_edit").val();
                afterDate = $("#date_edit").val();
                afterTime = $("#time_edit").val();
                afterNotes = $("#notes_edit").val();

                let selectedValue = $("input[name=tag_edit]:checked", "#editForm").val();
                if (selectedValue == 1){
                    afterTag = "personal";
                }
                else if (selectedValue == 2){
                    afterTag = "work";
                }
                else{
                    afterTag = "school";
                }
      
                
                if (afterTitle != "" && afterDate != "" && afterTime!= ""){
                    $("#dialog-form3").dialog("open");
                    saveEdit(afterTitle, afterDate, afterTime, afterTag, afterNotes, thisTitle, thisDate, thisTime, thisTag, thisNotes);
                    $("#event_title").text(afterTitle);
                    $("#event_date").text(afterDate);
                    $("#event_time").text(afterTime);
                    $("#event_tag").text(afterTag);
                    $("#event_notes").text(afterNotes);
                    $("#dialog-form5").dialog("close");
                    
                }
                else{
                    $("#edit_usagemessage").text("Please input all fields.");
                    $("#edit_usagemessage").css("color", "red");
                }
                
            },
            "Cancel": function() {
                $(this).dialog("close");
                $("#dialog-form3").dialog("open");
                $("#edit_usagemessage").text("");
            }
        }
    });

});

//SHARE EVENT w/ USER
$(function() {
    $("#dialog-form6").dialog({
        autoOpen: false,
        modal: true,
        buttons: {
            "Share": function() {
                thisTitle = $("#event_title").text();
                thisDate = $("#event_date").text();
                thisTime = $("#event_time").text();
                thisTag = $("#event_tag").text();
                thisNotes = $("#event_notes").text();
                shareWith(thisTitle, thisDate, thisTime,thisTag, thisNotes, $("#share_with").val());
            },
            "Cancel": function() {
                $(this).dialog("close");
                $("#share_with").val("");
                $("#share_with_usagemessage").text("");
                $("#dialog-form3").dialog("open");
            }
        }
    });

});


//"LOG OUT" IS CLICKED
$('#log_out').click(function(){
    //Log out by destroying session
    $.ajax({
        type: "POST",
        url: "destroySession.php"
    });

    //Set up "log in" & "create account"
    $("#log_in").text("Log In");
    $("#partition1").text (" | ");
    $("#create_account").text("Create Account");

    //Clear "log out" & "welcome message"
    $("#log_out").text("");
    $("#partition2").text("");
    $("#welcome_message").text("");

    //Hide "Create Event" button
    document.getElementById("create_event_button").style.visibility = "hidden";
    document.getElementById("checkboxes").style.visibility = "hidden";
    updateCalendar();


    })

    </script>

    <div id="dialog-form1" title="Log In">
          <p class="validateTips">All form fields are required.</p>
          <form method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
         <label for="name">Username</label>
          <input type="text" name="username1" id="username1">
         <label for="password">Password</label>
          <input type="password" name="password1" id="password1" value="">
        </fieldset>
        <p id = "message1"></p>
        </form>
    </div>  

    <div id="dialog-form2" title="Create New User">
          <p class="validateTips">All form fields are required.</p>
          <form method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
         <label for="name">Username</label>
          <input type="text" name="username2" id="username2">
         <label for="password">Password</label>
          <input type="password" name="password2" id="password2" value="">
          <label for="password">Password Again</label>
          <input type="password" name="confirmpassword2" id="password3" value="">
        </fieldset>
        <p id = "message2"></p>
        </form>
    </div> 

    <div id="dialog-form3" title="Event Details">
          <form method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
            <span class = "bold">Event Name: </span><span id = "event_title"></span>
            <br><br>
            <span class = "bold">Date: </span><span id = "event_date"></span>
            <br><br>
            <span class = "bold">Time: </span><span id = "event_time"></span>
            <br><br>
            <span class = "bold">Tag: </span><span id = "event_tag"></span>
            <br><br>
            <span class = "bold">Notes: </span><span id = "event_notes"></span>
            <br>
        </fieldset>
        <input type="hidden" name="token" value="" id = "delete_token"/>
        </form>
    </div>

    <div id="dialog-form4" title="Create New Event">
          <p class="validateTips">All form fields are required.</p>
          <form method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
         <label for="event_title">Title</label>
          <input type="text" name="event_title" id="title_input">
         <label for="date">Date</label>
          <input type="date" name="date" id="date_input">
          <label for="time">Time</label>
          <input type="time" name="time" id="time_input">
          <br>
          <input type="radio" id="personal" name="tag"><label for="personal">Personal</label>
          <input type="radio" id="work" name="tag"><label for="work">Work</label>
          <input type="radio" id="school" name="tag"><label for="school">School</label>
        </fieldset>
        <p id = "create_event_usagemessage"></p>
        <input type="hidden" name="token" value="" id = "create_token"/>
        </form>
    </div> 

    <div id="dialog-form5" title="Edit Event">
          <p class="validateTips">All form fields are required.</p>
          <form id = "editForm" method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
         <label for="event_title">Title</label>
          <input type="text" name="event_title" id="title_edit" value = "">
         <label for="date">Date</label>
          <input type="date" name="date" id="date_edit" value = "">
          <label for="time">Time</label>
          <input type="time" name="time" id="time_edit" value = ""><br>
          <input type="radio" id="personal_edit" name="tag_edit" value = 1><label class = "small" for="personal_edit">Personal</label>
          <input type="radio" id="work_edit" name="tag_edit" value = 2><label class = "small" for="work_edit">Work</label>
          <input type="radio" id="school_edit" name="tag_edit" value = 3><label class = "small" for="school_edit">School</label>
          <label for = "notes_edit">Notes</label><input type='text' id = "notes_edit">
        </fieldset>
        <p id = "edit_usagemessage"></p>
        <input type="hidden" name="token" value="" id = "edit_token"/>
        </form>
    </div> 

    <div id="dialog-form6" title="Share Event">
          <p class="validateTips">All form fields are required.</p>
          <form method = "POST" action="<?php echo htmlentities($_SERVER['PHP_SELF']); ?>">
         <fieldset>
         <label for="share_with">Share With:</label>
          <input type="text" name="share_with" id="share_with" value = "">
        </fieldset>
        <p id = "share_with_usagemessage"></p>
        <input type="hidden" name="token" value="" id = "share_token"/>
        </form>
    </div> 


<script>
    const month_array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    let visibleDate = new Date();
    let currentMonth = new Month(visibleDate.getFullYear(), visibleDate.getMonth());
    let visibleMonthNum = visibleDate.getMonth();
    let visibleMonthString = month_array[visibleMonthNum];
    let visibleYearNum = visibleDate.getFullYear();

       
    $("#month").text(visibleMonthString);
    $("#year").text(visibleYearNum);


         //Right arrow and left arrow adjust visibleDate
         $("#left_arrow").click(function(){
            visibleMonthNum -= 1; //decrements visibleMonthNum to change visibleDate
            if (visibleMonthNum == -1){
                visibleMonthNum = 11;
                visibleYearNum -=1; //decrements year when going from January to December
                visibleDate.setYear(visibleYearNum);
            }
            visibleDate.setMonth(visibleMonthNum);
            let visibleMonthString = month_array[visibleMonthNum];
            $("#month").text(visibleMonthString);
            $("#year").text(visibleYearNum);
            currentMonth = currentMonth.prevMonth();
            updateCalendar();
        });

         $("#right_arrow").click(function(){
            visibleMonthNum += 1; //increments visibleMonthNum to change visibleDate
            if (visibleMonthNum == 12){
                visibleMonthNum = 0;
                visibleYearNum +=1; //increments year when going from December to January
                visibleDate.setYear(visibleYearNum);
            }
            visibleDate.setMonth(visibleMonthNum);
            let visibleMonthString = month_array[visibleMonthNum];
            $("#month").text(visibleMonthString);
            $("#year").text(visibleYearNum);
            currentMonth = currentMonth.nextMonth();
            updateCalendar();
        });

        $("#display_personal").change(function() {
            updateCalendar();
        });
        $("#display_work").change(function() {
            updateCalendar();
        });
        $("#display_school").change(function() {
            updateCalendar();
        });

        //Update Calendar when document loads & destroy session
        $(function(){
            $.ajax({
                type: "POST",
                url: "destroySession.php"
            });
            $("#personal").prop("checked", true);
            document.getElementById("checkboxes").style.visibility = "hidden";
            updateCalendar();
        });

       

        //UPDATE CALENDAR UDPATES DATES IN MONTH VIEW AND CALLS loadEvents() TO DISPLAY EVENTS IN CURRENT MONTH DISPLAY.
        //CALLED BY LEFT/RIGHT ARROW AND WHEN DOCUMENT LOADS
        function updateCalendar(){
            $.getScript('calendar_helper_functions.js', function(){

                $("td").each(function(){
                    //resets color each time
                    $(this).css("color", "black");
                })
                    
                    let weeks = currentMonth.getWeeks();
                    let numWeeks = weeks.length;
                    
                    //Showing/hiding based on number of weeks
                    if (numWeeks == 6){
                        document.getElementById("week6").style.visibility = "visible";
                        document.getElementById("week5").style.visibility = "visible";
                    }
                    else if (numWeeks == 5){
                        document.getElementById("week6").style.visibility = "hidden";
                        document.getElementById("week5").style.visibility = "visible";
                    }
                    else{ //numWeeks == 4 --> RARE but possible
                        document.getElementById("week5").style.visibility = "hidden";
                        document.getElementById("week6").style.visibility = "hidden";
                    }
                
                    for(var w in weeks){
                    
                    let days = weeks[w].getDates();
                    let whichWeekNum = Number(w)+Number(1);
                    let whichWeek = "week"+whichWeekNum;
                    let whichWeekId = "#" + whichWeek;

                    let daysOfWeek = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"];
                    
                    //days contains normal JavaScript Date objects.
                               
                    for(var d in days){
                        let whichDayInWeek = whichWeekId + " ." + daysOfWeek[d];
                        let displayedDay = Number(days[d].getDate());
                        if (days[d].getMonth() == visibleMonthNum){
                            $(whichDayInWeek).text(displayedDay);
                        }
                        else{ //Not in this current month
                            $(whichDayInWeek).text("");
                        }
                    }

                }
                loadEvents(); //Load the events onto the display
        });
    }

    </script>

    
 </body>
 </html>