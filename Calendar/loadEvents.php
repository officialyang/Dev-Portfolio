<?php
    require 'database.php';
    ini_set("session.cookie_httponly", 1);
    session_start(); 

    if(!isset($_SESSION['username'])) { //Abuse of Functionality check
        echo "failure";
        exit;
    }

    $username = $mysqli->real_escape_string($_SESSION['username']);
    if ($username == "" || $username == null){
        echo "failure";
        exit;
    }


    $stmt = $mysqli->prepare("select title, date, time, tag, notes from events where event_username='$username' order by time");
    if(!$stmt){
        printf("failure");
        exit;
    }   

    $stmt->execute();

    $stmt->bind_result($title, $date, $time, $tag, $notes);
    while ($stmt -> fetch()){
        if ($notes == NULL){
            $notes = "";
        }
        printf("%s,%s.%s/%s?%s)",
                    htmlspecialchars($title),
                    htmlspecialchars($date),
                    htmlspecialchars($time),
                    htmlspecialchars($tag),
                    htmlentities($notes)
    );
        
    }
    $stmt->close();

?>