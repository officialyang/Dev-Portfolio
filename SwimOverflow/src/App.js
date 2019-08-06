import React, { Component } from 'react';
import fire from './config/Fire';
import LoginPage from './LoginPage';
import Home from './Home';

import './App.css';

class App extends Component {
  constructor(props){
    super();
    this.state = {
      user:{},
      username: "",
      email: "",
    }
  }

  changeUsername(username){
    this.setState({username: username});
    // alert(this.state.username);
  }

  componentDidMount(){
    this.authListener();
  }

  authListener(){
    fire.auth().onAuthStateChanged((user)=> {
      console.log(user);
      if (user){
        this.setState({user:user, username: null});
        // localStorage.setItem('user', user.uid);
      }
      else{
        this.setState({user:null, username: null});
        // localStorage.removeItem('user');
      }
    });
  }

  render() {
    return (
      <div className = "App">
      <link href="https://fonts.googleapis.com/css?family=Karla" rel="stylesheet"></link>
      {/* Is the user logged in? Yes -> render home; No -> render login */}
      {this.state.username ? (<Home username={this.state.username} />) : (<LoginPage changeUsername={this.changeUsername.bind(this)}/>)}
    {/* {this.state.user ? (<Home username={this.state.username} email = {this.state.email}/>) : (<Login changeUsernameAndEmail={this.changeUsernameAndEmail.bind(this)}/>)} */}

      </div>
    );
  }
}






export default App;
