<?php
    require 'database.php';
    ini_set("session.cookie_httponly", 1);
    session_start(); 

    $username_input = $_POST['username2'];
    $password_input = $_POST['password2'];

    if( !preg_match('/^[\w_\-]+$/', $username_input) ){
        echo "failure";
        exit;
    }

   //Check if username is valid
   $stmt = $mysqli->prepare("select username from users");
   if(!$stmt){
       printf("Query Prep Failed: %s\n", $mysqli->error);
       exit;
   }

   $stmt->execute();

   $stmt->bind_result($username);

   while($stmt->fetch()){
       if ($username === $username_input){
           echo "username_exists";
           exit;
       }
   }

   //At this point, username doesn't exist. Proceed to add username/password to database.
   $stmt->close();


   $stmt = $mysqli->prepare("insert into users (username, password) values (?, ?)");
   if(!$stmt){
       printf("Query Prep Failed: %s\n", $mysqli->error);
       exit;
   }

   //Password Hash
   $password_hash = password_hash($password_input, PASSWORD_DEFAULT);

   $stmt->bind_param('ss', $username_input, $password_hash);

   $stmt->execute();

   $stmt->close();

   echo "success";
   exit;
?>