import React, { Component } from 'react';
import fire from './config/Fire';
 

class PostView extends Component{
    constructor(props){
        super(props);
        this.state = {
            username: props.username,
            title: props.selected_title,
            author: "",
            category: "",
            comments: [],
            date: new Date(0),
            post_text: "",
            views: -1,
            loaded: false,
            viewsUpdated:false,
            categoryViews:-1,
            categoryLoaded: false,
        }
    }
 
    loadPost = () => {
        let x = this;
        fire.firestore().collection("posts").doc(x.state.title).get().then(function(doc){
            let author = doc.data().author_username;
            let category = doc.data().category;
            let comments = doc.data().comments;
            let date = doc.data().date.toDate();
            let post_text = doc.data().post_text;
            let views = doc.data().views;
 
            x.setState({
                author: author,
                category: category,
                comments: comments,
                date: date,
                post_text: post_text,
                views: views + 1,
                loaded: true,
               
            });

            if(x.state.category !== ""){
                fire.firestore().collection("categories").doc(x.state.category).get().then(function(doc){
                    let categoryViews = doc.data().totalviews;
                    x.setState({
                        categoryViews:categoryViews + 1,
                        categoryLoaded:true
                    })

                    let categoryDoc = fire.firestore().collection("categories").doc(x.state.category).set({
                        totalviews:x.state.categoryViews
                    }).catch(function(error){
                        console.log(error);
                    })
                }).catch(function(error){
                    console.log(error);
                });
            }

            x.updateFireStore();
        });
        
    }
 
    displayPost = () =>{
        let commentsMap = [];
        for(let i=0; i<this.state.comments.length; i=i+2){
            let tempArray = this.state.comments[i] + ": " + this.state.comments[i+1];
            commentsMap = commentsMap.concat(tempArray); 
        }
        console.log(commentsMap);
        console.log(this.state.comments);
        return (
            <div>
                <p>By: {this.state.author}</p>
                <p>Category: {this.state.category}</p>
                <p>Date: {this.state.date.toDateString()}</p>
                <p>Views: {this.state.views}</p>
                <h3>Post</h3>
                <br/>
                <p id = "post_text">{this.state.post_text}</p>
                <br/><br/>
                <p>Comments: </p>
                {commentsMap.map((i) =>{
                    return <li>{i}</li>
                })}
            </div>
        )
    }
 
    goBack = () =>{
        this.props.updateDisplayPosts(this.state.title);
    }
 

    updateFireStore = () => {
        let postRef = fire.firestore().collection("posts").doc(this.state.title);
        let x = this;
        console.log("updating firestore ", this.state.views);
        postRef.set({
            author_username:x.state.author,
            category: x.state.category,
            comments:x.state.comments,
            date: x.state.date,
            post_text:x.state.post_text,
            views: x.state.views
        });
    }

    newComment = (newComment) =>{
        let x=this;
        let docRef =fire.firestore().collection("posts").doc(this.state.title);
        docRef.get().then(function(doc){
            x.setState({comments:doc.data().comments.concat(newComment)})
            x.updateFireStore();
        })
    }

    refresh = () =>{
        let x = this;
        fire.firestore().collection("posts").doc(this.state.title).get().then(function(doc){
            let author = doc.data().author_username;
            let category = doc.data().category;
            let comments = doc.data().comments;
            let date = doc.data().date.toDate();
            let post_text = doc.data().post_text;
            let views = doc.data().views;
 
            x.setState({
                author: author,
                category: category,
                comments: comments,
                date: date,
                post_text: post_text,
                views: views,
                loaded: true,
               
            });

            if(x.state.category !== ""){
                fire.firestore().collection("categories").doc(x.state.category).get().then(function(doc){
                    let categoryViews = doc.data().totalviews;
                    x.setState({
                        categoryViews:categoryViews,
                        categoryLoaded:true
                    })
                });
            }
        })
    }

    componentDidMount() {
        this.interval = setInterval(() => this.refresh(), 10000);
        //Every 10 seconds, refresh the page to get most recent update
      }

    componentWillUnmount() {
        clearInterval(this.interval);
    }

    deletePost = () =>{
        let confirm = window.confirm("Are you sure you want to delete this post?");

        if(confirm){
            let x = this;
            fire.firestore().collection("posts").doc(this.state.title).delete().then(function () {
                x.goBack();
            })
        }
    }

    render(){
        return(
            <div>
                <h2>{this.state.title}</h2>
                <button onClick = {this.goBack}>Back</button>
                <button onClick = {this.refresh}>Refresh</button>
                {this.state.username === this.state.author ? <button onClick = {this.deletePost}>Delete</button> : null}
                {!this.state.loaded ? this.loadPost(): null}
                {this.state.loaded ? this.displayPost() : null}
                {this.state.username==="guest" ? null: <CommentBox username={this.state.username} newComment = {this.newComment}/>}
            </div>
        )
    }
}

class CommentBox extends Component{
    constructor(props){
        super(props);
        this.state={
            inputComment: "",
            username:props.username,
            
        }
    }

    handleChange = (e) =>{
        this.setState({[e.target.name]: e.target.value});
    }

    handleClick = () =>{
        if (this.state.inputComment === ""){
            document.getElementById('error_message6').innerHTML = "Please enter an input.";
        }
        else{
            //Firebase
            document.getElementById('error_message6').innerHTML ="";
            let newComment = [this.state.username, this.state.inputComment];
            this.props.newComment(newComment);
            this.setState({inputComment:""});
        
        }
    }

    render(){
        return(
            <div>
                <input type = "textarea" name ="inputComment" value ={this.state.inputComment} onChange={this.handleChange}/>
                <button onClick ={this.handleClick}>Post Comment</button>
                <p id ="error_message6"></p>
            </div>
        )
    }
}
 
export default PostView;