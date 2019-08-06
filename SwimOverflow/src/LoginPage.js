import React, { Component } from 'react';
import fire from './config/Fire';

import './App.css';
import { firestore } from 'firebase';

class LoginPage extends Component{
    constructor(props){
        super(props);
        this.state = {
            isLogin: true,
        }
    }

    setLogin = () => {
        this.setState({ isLogin: !this.state.isLogin });
    }

    render() {
        console.log(this.props);
        const { changeUsername } = this.props;
        return (
          <div>
        {this.state.isLogin ? 
            (<Login changeUsername={this.props.changeUsername} 
            isLogin = {this.state.isLogin} 
            setLogin={this.setLogin} />) 
            : 
            (<CreateAccount setLogin = {this.setLogin}
            changeUsername = {this.props.changeUsername}/>)}
          </div>
        );
      }

    
}


class Login extends Component{
    constructor(props){
      super(props);
      this.state = {
          username: "",
          email: "",
          password:"",
    };
        this.login = this.login.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.updateLogin = this.updateLogin.bind(this);
        this.handleClick = this.handleClick.bind(this);
    }
    
    login(e){
        e.preventDefault();
        if (this.state.email != "" && this.state.password!=""){
            
            fire.auth().signInWithEmailAndPassword(this.state.email.trim(), this.state.password).then((u)=>{
                let docRef = fire.firestore().collection('users').doc(this.state.email);
                let x = this;
                docRef.get().then(function(doc){
                    if (doc.exists){
                        // x.setState({username: doc.data().username});
                        // x.state.username = doc.data().username;

                        if (doc.data().username!==""){
                            x.updateLogin(doc.data().username);
                        }
                        console.log("Document data: ", doc.data().username);
                    }
                    else{
                        console.log("no data :(");
                    }
                }).catch(function(error){
                    console.log("Error getting data...", error);
                });

            }).catch((error) =>{
                let errorMessage = error;
                if (error == "Error: The password is invalid or the user does not have a password."|| error == "Error: There is no user record corresponding to this identifier. The user may have been deleted."){
                    errorMessage = "Invalid Username/Password";
                }
                else if(error == "Error: The email address is badly formatted."){
                    errorMessage = "Input formatted incorrectly.";
                }
                document.getElementById('error_message').innerHTML = errorMessage;
            });
            
        }
        else{
            document.getElementById('error_message').innerHTML = "Please fill in all the inputs.";
        }   
    }

    loginGuest = () =>{
        this.setState({
            username: "username",
        })

        fire.auth().signInWithEmailAndPassword("guest@guest.com", "guestpassword").then((u)=>{
            this.updateLoginGuest(); //Change the display name to be guest
        }).catch((error) =>{
            let errorMessage = error;
            if (error == "Error: The password is invalid or the user does not have a password."|| error == "Error: There is no user record corresponding to this identifier. The user may have been deleted."){
                errorMessage = "Invalid Username/Password";
            }
            else if(error == "Error: The email address is badly formatted."){
                errorMessage = "Input formatted incorrectly.";
            }
            document.getElementById('error_message').innerHTML = errorMessage;
        });
        
    }
        


    handleChange(e){
        this.setState({[e.target.name]: e.target.value});
    }

    updateLogin(firebaseUsername){
        // this.setState({
        //     username: firebaseUsername,
        // })
        console.log("UPDATE LOGIN" + firebaseUsername);
        // this.props.changeUsername(this.state.username);
        this.props.changeUsername(firebaseUsername);
    }

    updateLoginGuest = () =>{
        this.props.changeUsername("guest");
    }

    handleClick (){
        console.log(this.props);
        this.props.setLogin();
    }
    
  
    render(){
      return(
        <div>
        <Title/>
        <form>
              <fieldset>
                  <legend>Log In:</legend> 
                  {/* <label>Username
                  <input type = "text" name = "username" id = "username_input" value = {this.state.username} onChange = {this.handleChange}/>
                  </label>
                  <br/> */}
                  <label>Email
                  <input type = "email" name = "email" id = "email_input" value = {this.state.email} onChange = {this.handleChange}/>
                  </label>
                  <br/>
                  <label htmlFor = "password_input">Password</label>
                  <input type = "password" name = "password" id = "password_input" value = {this.state.password} onChange = {this.handleChange}/>
                  <br/>
                  <p id = "error_message"></p>
                  <br/>
                  <a onClick ={this.handleClick}>New? Create an account!</a>
                  <br/>
                  <a onClick={this.loginGuest}>Continue as guest</a>
                  <br/>
              <button type = "submit" onClick = {this.login}>Login</button>
              {/* <button type = "submit" onClick = {this.signup}>Signup</button> */}
              </fieldset>
              <img id = "login_pic" src = "https://cdn.vox-cdn.com/uploads/chorus_image/image/50365629/usa-today-9450036.0.jpg"/>
              <img id = "login_pic2" src = "https://cdn.vox-cdn.com/uploads/chorus_image/image/50365629/usa-today-9450036.0.jpg"/>
              
        </form>
        </div>
      );
  
    }
  }

  class Title extends Component{
      render(){
          return(
              <div>
                <h1>Welcome to <img id = "logo" src = "http://ec2-54-159-226-175.compute-1.amazonaws.com/~kevin.vancleave/swimoverflow.png" height = "40" width = "200"/></h1>
                <p>A community for all fans of swimming</p>
            </div>
          );
      }
  }

  class CreateAccount extends Component{
    constructor(props){
      super(props);
      this.state = {
        username: "",
        email: "",
        password:"",
        password2: "",
      };
  
      this.handleChange = this.handleChange.bind(this);
      this.updateLogin = this.updateLogin.bind(this);
    }
  
    handleChange(e){
        this.setState({[e.target.name]: e.target.value});
    }

    handleClick = () =>{
        this.props.setLogin();
    }

    updateLogin(firebaseUsername){
        this.state.username = firebaseUsername;
        console.log("UPDATE LOGIN" + firebaseUsername);
        this.props.changeUsername(this.state.username);
    }

    CreateAccount = (e) =>{
        e.preventDefault();
        if (this.state.password != this.state.password2){
            document.getElementById('error_message2').innerHTML = "Passwords do not match.";
        }
        else{
            if (this.state.email != "" && this.state.password!="" && this.state.username!="" && this.state.password2!=""){
                fire.auth().createUserWithEmailAndPassword(this.state.email.trim(), this.state.password).then((u)=>{
                    fire.auth().currentUser.sendEmailVerification().then(function() {
                        // Email sent.
                        console.log("email sent");
                      }).catch(function(error) {
                        // An error happened.
                        console.log(error);
                      });
                    let x= this;
                    fire.firestore().collection("users").doc(this.state.email).set({
                        username: this.state.username,
                    }).then (function(){
                        if (x.state.username!=""){
                            x.updateLogin(x.state.username);
                        }
                        console.log("success");
                    })
                    .catch(function(e){
                        console.log(e);
                    })
                })
                .catch((error)=>{
                    let printError = error;
                    if (error = "Error: The email address is badly formatted."){
                        printError = "Input formatted incorrectly.";
                    }
                    document.getElementById('error_message2').innerHTML = printError;
                })
            }
            else{
                document.getElementById('error_message2').innerHTML = "Please fill in all the inputs.";
            }
        }
    }   
  
    render(){
      return(
          <div>
        <Title/>
        <form>
              <fieldset>
                  <legend>Create Account:</legend>
                  <label htmlFor = "username_input_create">Username</label>
                  <input type = "text" id = "username_input_create" name = "username" value = {this.state.username} onChange = {this.handleChange}/>
                  <br/>
                  <label>Email
                  <input type = "email" name = "email" id = "email_input" value = {this.state.email} onChange = {this.handleChange}/>
                  </label>
                  <br/>
                  <label htmlFor = "password_input_create">Password</label>
                  <input type = "password" id = "password_input_create" name = "password" value = {this.state.password} onChange = {this.handleChange}/>
                  <br/>
                  <label htmlFor = "password_input_create2">Confirm Password</label>
                  <input type = "password" id = "password_input_create2" name = "password2" value = {this.state.password2} onChange = {this.handleChange}/>
                  <br/>
                  <p id = "error_message2"></p>
                  <br/>
                  <a onClick ={this.handleClick}>Already have an account? Log in!</a>
                  <br/>
                  <button type = "submit" onClick = {this.CreateAccount}>Create Account</button>
              </fieldset>
            </form>

            <img id = "login_pic" src = "https://cdn.vox-cdn.com/uploads/chorus_image/image/50365629/usa-today-9450036.0.jpg"/>
              <img id = "login_pic2" src = "https://cdn.vox-cdn.com/uploads/chorus_image/image/50365629/usa-today-9450036.0.jpg"/>
            
            </div>
      );
  
    }
  }


  export default LoginPage;