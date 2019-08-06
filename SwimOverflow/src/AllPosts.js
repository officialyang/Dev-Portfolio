import React, { Component } from 'react';
import fire from './config/Fire';

class AllPosts extends Component{
    constructor(props){
      super(props);
      this.state = {
          post_titles: new Array(0),
          loaded: false, 
          num_titles:0,
      }
    }

    displayPosts = () =>{
        let x = this;
        let collectionRef = fire.firestore().collection('posts').orderBy("date", "desc");
        collectionRef.get().then(function(collection){
            collection.forEach(function(doc){
                let postTitle = doc.id;
                x.state.post_titles[x.state.num_titles] = postTitle;
                x.setState({num_titles: x.state.num_titles+1, loaded: true})
            })
 
        }).catch((error)=>{
            let errorMessage = error;
            console.log(errorMessage);
        })
    }

    handleClick = (e) =>{
        this.props.updateDisplayPosts(e.target.id);
    }

    render(){
      return(
      <div>
          {!this.state.loaded ? this.displayPosts():null}
          <h2>All Posts</h2>
          <ol id = "display_all_posts">
            {this.state.post_titles.map(i =>{
                return <li><a id = {i} onClick = {this.handleClick}>{i}</a></li>
            })}
          </ol>
      </div>
      )
    }
  }

export default AllPosts;