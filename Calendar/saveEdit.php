<?php
ini_set("session.cookie_httponly", 1);
require 'database.php';
session_start(); 

//Passed in data
$afterTitle = $mysqli->real_escape_string($_POST['afterTitle']);
$afterDate = $mysqli->real_escape_string($_POST['afterDate']);
$afterTime = $mysqli->real_escape_string($_POST['afterTime']);
$afterTag = $mysqli->real_escape_string($_POST['afterTag']);
$afterNotes = $mysqli->real_escape_string($_POST['afterNotes']);
$beforeTitle = $mysqli->real_escape_string($_POST['beforeTitle']);
$beforeDate = $mysqli->real_escape_string($_POST['beforeDate']);
$beforeTime = $mysqli->real_escape_string($_POST['beforeTime']);
$beforeTag = $mysqli->real_escape_string($_POST['beforeTag']);
$beforeNotes = $mysqli->real_escape_string($_POST['beforeNotes']);


$token = $_POST['token'];
$username = $_SESSION['username'];

if(!hash_equals($_SESSION['token'], $token)){
    die("Request forgery detected");
}
if(!isset($_SESSION['username'])) { //Abuse of Functionality check
    echo "failure";
    exit;
}
if ($beforeNotes == ""){
    $stmt = $mysqli->prepare("UPDATE events SET title = '$afterTitle', date = '$afterDate', time = '$afterTime', tag = '$afterTag', notes = '$afterNotes' WHERE event_username = '$username' AND title = '$beforeTitle' AND date = '$beforeDate' AND time = '$beforeTime' AND tag = '$beforeTag' AND notes is null;");
    if(!$stmt){
        printf("Query Prep Failed1: %s\n", $mysqli->error);
        exit;
    }
    $stmt->execute();
    $stmt->close();
}
else{
    $stmt = $mysqli->prepare("UPDATE events SET title = '$afterTitle', date = '$afterDate', time = '$afterTime', tag = '$afterTag', notes = '$afterNotes' WHERE event_username = '$username' AND title = '$beforeTitle' AND date = '$beforeDate' AND time = '$beforeTime' AND tag = '$beforeTag' AND notes = '$beforeNotes';");
    if(!$stmt){
        printf("Query Prep Failed1: %s\n", $mysqli->error);
        exit;
    }
    $stmt->execute();
    $stmt->close();
}




$stmt2 = $mysqli->prepare("UPDATE events SET title = '$afterTitle', date = '$afterDate', time = '$afterTime', tag = '$afterTag', notes = '$afterNotes' WHERE title = '$beforeTitle' AND date = '$beforeDate' AND time = '$beforeTime' AND isGroup = 1");
if(!$stmt2){
    printf("Query Prep Failed2: %s\n", $mysqli->error);
    exit;
}

$stmt2->execute();
$stmt2->close();

echo "success";
?>