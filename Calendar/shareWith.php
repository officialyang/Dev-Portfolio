<?php
ini_set("session.cookie_httponly", 1);
require 'database.php';
session_start(); 

    $title = $mysqli->real_escape_string($_POST['title']);
    $date = $mysqli->real_escape_string($_POST['date']);
    $time = $mysqli->real_escape_string($_POST['time']);
    $tag = $mysqli->real_escape_string($_POST['tag']);
    $notes = $mysqli->real_escape_string($_POST['notes']);
    $username_input = $mysqli->real_escape_string($_POST['username_input']);

    $token = $_POST['token'];
    $username = $_SESSION['username'];

    if(!hash_equals($_SESSION['token'], $token)){
        die("Request forgery detected");
    }
    if(!isset($_SESSION['username'])) { //Abuse of Functionality check
        echo "failure";
        exit;
    }

    if ($username_input === $username){
        echo "sameUser";
        exit;
    }

    //Check to see if user exists:
    $stmt = $mysqli->prepare("SELECT username FROM users;");
    if(!$stmt){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }   

    $stmt->execute();

    $stmt->bind_result($username_sql);

    //$match = false;

    while($stmt->fetch()){
        if ($username_sql === $username_input){
            //username exists, proceed to create event for them
            $stmt ->close();
            $stmt2 = $mysqli->prepare("insert into events set event_username = '$username_input', title='$title', date='$date', time='$time', tag = '$tag', notes = '$notes';");
            if(!$stmt2){
                printf("Query Prep Failed1: %s\n", $mysqli->error);
                exit;
            }   
            $stmt2->execute();
            $stmt2 ->close();

            //also need to adjust isGroup to 1
            $stmt3 = $mysqli->prepare("UPDATE events SET isGroup = 1 WHERE event_username = '$username_input' AND title='$title' AND date='$date' AND time='$time';");
            if(!$stmt3){
                printf("Query Prep Failed2: %s\n", $mysqli->error);
                exit;
            }   
            $stmt3->execute();
            $stmt3 ->close();

            $stmt4 = $mysqli->prepare("UPDATE events SET isGroup = 1 WHERE event_username = '$username' AND title='$title' AND date='$date' AND time='$time';");
            if(!$stmt4){
                printf("Query Prep Failed3: %s\n", $mysqli->error);
                exit;
            }   
            $stmt4->execute();
            $stmt4 ->close();

            echo "success";
            exit;
        }
    }

    echo "user_DNE";

?>