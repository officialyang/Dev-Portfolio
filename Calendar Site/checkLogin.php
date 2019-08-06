<?php
    require 'database.php';
    ini_set("session.cookie_httponly", 1);
    session_start(); 

    //Passed in data
    $username_input = $mysqli->real_escape_string($_POST['username1']);
    $password_input = $mysqli->real_escape_string($_POST['password1']);

    if( !preg_match('/^[\w_\-]+$/', $username_input) ){
        echo "failure";
        exit;
    }

    $stmt = $mysqli->prepare("select username, password from users");
    if(!$stmt){
        printf("Query Prep Failed: %s\n", $mysqli->error);
        exit;
    }   

    $stmt->execute();

    $stmt->bind_result($username, $password);


    while($stmt->fetch()){
            if ($username === $username_input){ //username exists in the database
                if (password_verify($password_input, $password)){ //password matches the username
                    $_SESSION['username'] = $username;
                    $_SESSION['token'] = bin2hex(random_bytes(32));
                    echo json_encode(array(
                        "success" => true,
                        "token" => htmlentities($_SESSION['token'])
                    ));          
                    exit;
                }
                // else{ //Username exists but password incorrect
                //     echo json_encode(array(
                //         "success" => false,
                //         "incorrect_password" => true
                //     ));  
                    
                //     exit;
                // }
            }
    }
    $stmt ->close();
    echo json_encode(array(
        "success" => false,
        "user_DNE" => true
    ));  

?>