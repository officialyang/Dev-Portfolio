import React, { Component } from 'react';
import fire from './config/Fire';
import Search from './Search';
import AllPosts from './AllPosts';
import Popular from './PopularPosts';
import Conversations from './Messages';
import CreatePost from './CreatePost';
import PostView from './postView';

class Home extends Component{
    constructor(props){
      super(props);

      this.state = {
        user: {},
        username: props.username,
        currentSection: 0,
        createPostSelected: false,
        displayPostSelected: false,
        selected_title: "",
      };
      this.logout = this.logout.bind(this);
    }

    logout(){
        fire.auth().signOut();
    }

    handleClick = (e) =>{
      let clickedIndex = e.currentTarget.dataset.id;
      this.setState({createPostSelected: false})
      if (clickedIndex == 0){
        console.log("popular");
        document.getElementById("selected_nav").id = "";
        document.getElementById("0").parentElement.id = "selected_nav";
        this.setState({currentSection: 0,displayPostSelected: false})
      }
      else if (clickedIndex == 1){
        console.log("all posts");
        document.getElementById("selected_nav").id = "";
        document.getElementById("1").parentElement.id = "selected_nav";
        this.setState({currentSection: 1,displayPostSelected: false})
      }
      else if (clickedIndex == 2){
        console.log("messages");
        document.getElementById("selected_nav").id = "";
        document.getElementById("2").parentElement.id = "selected_nav";
        this.setState({currentSection: 2,displayPostSelected: false})
      }
      else if (clickedIndex == 3){
        console.log("search");
        document.getElementById("selected_nav").id = "";
        document.getElementById("3").parentElement.id = "selected_nav";
        this.setState({currentSection: 3,displayPostSelected: false})
      }
    }

    updateCreatePost = (e) =>{
      //compose post image is pressed or cancel pressed
      e.preventDefault();
      this.setState({createPostSelected: true, displayPostSelected: false})
    }

    cancelCreatePost = (e) =>{
      //compose post image is pressed or cancel pressed
      e.preventDefault();
      this.setState({createPostSelected: false, displayPostSelected: false})
    }

    updateDisplayPosts = (title)=>{
      this.setState({displayPostSelected: !this.state.displayPostSelected, selected_title: title})
    }
    

    render(){
      return(
        <div>
          {/* {this.getUsernameFromDatabase()} */}
          <img id = "logo" src = "http://ec2-54-159-226-175.compute-1.amazonaws.com/~kevin.vancleave/swimoverflow.png" height = "40" width = "200"/>
            <h1>Welcome {this.state.username}!</h1>
            <button onClick={this.logout}>Logout</button>
            <br/><br/>
            {/* Sections: Popular, All Posts, Direct Message, Search */}
            <ul class = "navbar_ul">
              <li class = "navbar_list" id = "selected_nav"><a class = "navbar_link" id = "0" data-id="0" onClick = {this.handleClick}>Popular</a></li>
              <li class = "navbar_list" id = ""><a class = "navbar_link"  id = "1" data-id = "1"onClick = {this.handleClick}>All Posts</a></li>
              <li class = "navbar_list" id = ""><a class = "navbar_link" id = "2" data-id = "2" onClick = {this.handleClick}>Messages</a></li>
              <li class = "navbar_list" id = ""><a class = "navbar_link" id = "3" data-id = "3" onClick = {this.handleClick}>Search</a></li>
              <li id = "compose_icon_li"><div id = "compose_background"><img  onClick = {this.updateCreatePost} src = "https://image.flaticon.com/icons/svg/1159/1159633.svg" id = "compose_icon"></img></div></li>
            </ul>
            {(this.state.currentSection==0 && !this.state.createPostSelected && !this.state.displayPostSelected) ? (<Popular updateDisplayPosts={this.updateDisplayPosts}/>): (null)}
            {(this.state.currentSection==1 && !this.state.createPostSelected && !this.state.displayPostSelected)? (<AllPosts updateDisplayPosts={this.updateDisplayPosts}/>): (null)}
            {(this.state.currentSection==2 && !this.state.createPostSelected && !this.state.displayPostSelected)? (<Conversations username = {this.state.username}/>): (null)}
            {(this.state.currentSection==3 && !this.state.createPostSelected && !this.state.displayPostSelected)? (<Search updateDisplayPosts={this.updateDisplayPosts}/>): (null)}
            {(this.state.createPostSelected && !this.state.displayPostSelected) ? (<CreatePost cancelCreatePost = {this.cancelCreatePost} updateCreatePost= {this.updateCreatePost} username = {this.state.username} updateDisplayPosts={this.updateDisplayPosts}/>): (null)}
            {this.state.displayPostSelected ? (<PostView updateDisplayPosts= {this.updateDisplayPosts} selected_title={this.state.selected_title} username={this.state.username}/>): null}
        </div>
      );
  
    }
  }


  export default Home;