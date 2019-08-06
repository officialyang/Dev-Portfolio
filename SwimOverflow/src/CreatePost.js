import React, { Component } from 'react';
import fire from './config/Fire';

class CreatePost extends Component{
    constructor(props){
        super(props);
        this.state = {
            title:"",
            username: props.username,
            post_text:"",
            new_category_text: "",
            categories: [],
            justLoadedCategories: false,
            displayOther: false,
        }
      }

    setCategoryText = (categoryText) =>{
        this.setState({new_category_text: categoryText})
    }

    handleChange = (e) =>{
        this.setState({[e.target.name]: e.target.value});
    }

    timeToCreatePost = (e) =>{
        e.preventDefault();
        let f = document.getElementById("category_dropdown");
        let selectedValue = f.options[f.selectedIndex].value;
        let title = this.state.title;
        let username = this.state.username;
        let post_text = this.state.post_text;
        let date = new Date();
        let categoryAlreadyExists = false;
        if (username !== "guest"){
            if (title==="" || post_text===""){
                document.getElementById("error_message5").innerHTML = "Please fill in all inputs";
            }
            else if(selectedValue === "-- Select One --"){
                document.getElementById("error_message5").innerHTML = "Please select a category";
            }

            else if (selectedValue === "Other"){
                selectedValue = this.state.new_category_text;
                let x = this;
                let docRef = fire.firestore().collection("categories");
                docRef.get().then(function(collection){
                    collection.forEach(function(doc){
                        if (doc.id === selectedValue){
                            categoryAlreadyExists = true;
                        }
                    })
                    if (!categoryAlreadyExists){
                        fire.firestore().collection("categories").doc(selectedValue).set({totalviews: 0});
                    }

                    //proceed to post to database
                    fire.firestore().collection("posts").doc(title).set({
                        author_username: username,
                        comments: [],
                        post_text: post_text,
                        date: date,
                        category: selectedValue,
                        views: 0,
                    })
                    x.props.updateDisplayPosts(title);

                })
            }

            else{
                //Valid entry --> Post into database
                let x = this;
                fire.firestore().collection("posts").doc(title).set({
                    author_username: username,
                    comments: [],
                    post_text: post_text,
                    date: date,
                    category: selectedValue,
                    views: 0,
                })
                x.props.updateDisplayPosts(title);
            }
        }
        else{
            document.getElementById("error_message5").innerHTML = "Only logged in users can create posts";
        }

    }

    cancel = (e) =>{
        this.props.cancelCreatePost(e);
    }

    loadCategories = () =>{
        if (!this.state.justLoadedCategories){
            let collectionRef = fire.firestore().collection('categories');
            let x = this;
            collectionRef.get().then(function(collection){
                collection.forEach(function(data){
                    x.state.categories.push(data.id);
                    x.setState({justLoadedCategories: true})
                })
            })
        }
    }

    handleDropdownChange = (e) =>{
        e.preventDefault();
        let selectedValue = e.target.value;
        if (selectedValue === "Other"){
            this.setState({displayOther: true})
            console.log("other is selected");
        }
        else{
            this.setState({displayOther: false})
        }
    }

    render(){
        return(
            <div>
                <h2>Create Post</h2>
                <button onClick = {this.cancel}>Cancel</button>
                <br/><br/><br/>
                <form>
                    <label class = "bold">Title: </label><input type = "text" name = "title" value = {this.state.title} onChange = {this.handleChange}/>
                    <p><span class = "bold">Author: </span>{this.state.username}</p>
                    <label class = "bold">Post: </label><input type = "textarea" name = "post_text" value = {this.state.post_text} onChange = {this.handleChange}/>
                    <br/><br/>
                    {this.loadCategories()}
                    <label class = "bold">Category: </label>
                    
                        <select onChange = {this.handleDropdownChange} id ="category_dropdown">
                            <option selected = "selected">-- Select One --</option>
                            {this.state.categories.map(i =>{
                                return <option value = {i}>{i}</option>
                            })}
                            <option>Other</option>
                            
                        </select>
                        {this.state.displayOther ? <DisplayOther setCategoryText={this.setCategoryText}/>: null}
                        {/* <option value = "College">College</option>*/}

                    
                    <br/><br/>
                    <button type = "submit" onClick = {this.timeToCreatePost}>Create Post</button>
                </form>
                <p id = "error_message5"></p>
            </div>
        )
    }
}


class DisplayOther extends Component{
    constructor(props){
        super(props);
        this.state = {
            // otherInput: "",
        }
    }
    handleChange = (e) =>{
        // this.setState({[e.target.name]: e.target.value});
        this.props.setCategoryText(e.target.value);
    }

    render(){
        return (
            <div>
                <label class = "bold">New Category: </label>
                <input type = 'text' id = "categoryText" name = "categoryText" value = {this.state.otherInput} onChange={this.handleChange}/>
            </div>
        )
    }
}

export default CreatePost;