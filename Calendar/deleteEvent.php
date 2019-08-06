<?php
    require 'database.php';
    ini_set("session.cookie_httponly", 1);
    session_start(); 

    $token = $_POST['token'];

    //Passed in data
    $title = $mysqli->real_escape_string($_POST['title']);
    $date = $mysqli->real_escape_string($_POST['date']);
    $time = $mysqli->real_escape_string($_POST['time']);
    $username = $mysqli->real_escape_string($_SESSION['username']);

    if(!hash_equals($_SESSION['token'], $_POST['token'])){
	    die("Request forgery detected");
    }

    if(!isset($_SESSION['username'])) { //Abuse of Functionality check
        echo "failure";
        exit;
    }


    $stmt = $mysqli->prepare("DELETE FROM events where event_username = '$username' AND title='$title' AND date='$date' AND time='$time'");
    if(!$stmt){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }
    
    $stmt->execute();
    $stmt->close();


    $stmt2 = $mysqli->prepare("DELETE FROM events where title='$title' AND date='$date' AND time='$time' AND isGroup = 1;");
    if(!$stmt2){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }
    
    $stmt2->execute();
    $stmt2->close();
    echo "success";

    
?>