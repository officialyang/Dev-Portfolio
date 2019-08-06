<?php
    require 'database.php';
    ini_set("session.cookie_httponly", 1);
    session_start(); 

    $username = $mysqli->real_escape_string($_SESSION['username']);
    $title = $mysqli->real_escape_string($_POST['title']);
    $date = $mysqli->real_escape_string($_POST['date']);
    $time = $mysqli->real_escape_string($_POST['time']);
    $tag = $mysqli->real_escape_string($_POST['tag']);

    $token = $_POST['token'];

    if(!hash_equals($_SESSION['token'], $token)){
	    die("Request forgery detected");
    }

    if(!isset($_SESSION['username'])) { //Abuse of Functionality check
        echo "failure";
        exit;
    }

    $stmt = $mysqli->prepare("insert into events set event_username = '$username', title='$title', date='$date', time='$time', tag = '$tag';");
    if(!$stmt){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }
    echo "success"; 

    $stmt->execute();

    $stmt->close();

    

?>