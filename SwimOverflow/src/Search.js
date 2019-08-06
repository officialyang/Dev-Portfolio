import React, { Component } from 'react';
import fire from './config/Fire';

class Search extends Component{
    constructor(props){
      super(props);
      this.state = {
        search_input: "",
        search_results: [],
        num_search_results: 0,
        done_loading: false,
      };
    }

    handleChange = (e) =>{
        this.setState({[e.target.name]: e.target.value});
    }

    searchPressed = () =>{
        this.setState({search_results: [], num_search_results:0})//clearing out display search results
        let search_input = this.state.search_input;
        let search_input_lc = search_input.toLowerCase();
        let x = this;
        if (search_input_lc != ""){
            document.getElementById("error_message3").innerHTML = "";
            let collectionRef = fire.firestore().collection('posts').orderBy("views", "desc");
            collectionRef.get().then(function(collection){
                let noResults = true;
                collection.forEach(function(doc){
                    let post_title = doc.id;
                    let post_title_lc = post_title.toLowerCase();
                    let author_username_lc = doc.data().author_username.toLowerCase();
                    let post_text_lc = doc.data().post_text.toLowerCase();
                    let category_name = doc.data().category.toLowerCase();
                    if (post_title_lc.includes(search_input_lc) || author_username_lc.includes(search_input_lc) || post_text_lc.includes(search_input_lc) || category_name.includes(search_input_lc)){
                        //console.log(doc.id, " => ", doc.data().author_username, doc.data().comments, doc.data().date, doc.data().post_text);
                        x.state.search_results[x.state.num_search_results] = post_title;
                        x.setState({num_search_results: x.state.num_search_results+1, done_loading: true})
                        noResults = false;
                    }   
                })
                //After iterating through all in the collection, if none matches, then print no results found.
                if (noResults){
                    document.getElementById("error_message3").innerHTML = "No results found.";
                }
            }).catch((error)=>{
                let errorMessage = error;
                console.log(errorMessage);
            })
        }
        else{
            document.getElementById("error_message3").innerHTML = "Please enter a search.";
        }
    }


    handleClick = (e) =>{
        let title = e.target.id;
        this.props.updateDisplayPosts(title);
    }

    render(){
      return(
          <div>
            <h2>Search for a post!</h2>
            <input name="search_input" value={this.state.search_input} onChange={this.handleChange} type="text"/>
            <button onClick={this.searchPressed}>Search</button>
            <p id = "error_message3"></p>
            <ol id ="display_search_results">
                    {this.state.done_loading ? this.state.search_results.map(i =>{
                    return <li><a id = {i} onClick = {this.handleClick}>{i}</a></li>
                }): null}
            </ol>
          </div>
      )
    }
  }

export default Search;