import React, { Component } from 'react';
import fire from './config/Fire';

class Popular extends Component{
    constructor(props){
      super(props);
      this.state = {
          categories: [],
          top_posts: [],
          test_arr: ['hey', 'yo'],
          loadedCategories: false,
          loadedTopPosts: false,
          loadedTopPosts2: false,
          indexer: 0,
      }
    }

    loadCategories = () =>{
        let collectionRef = fire.firestore().collection('categories').orderBy("totalviews", "desc").limit(5);
        let x = this;
        collectionRef.get().then(function(collection){
            let i=0;
            collection.forEach(function(doc){
                if (x.state.categories.length === 5){
                    x.setState({loadedCategories: true})
                }
                else{
                    let newArray = x.state.categories.concat(doc.id);
                    x.setState({categories: newArray})

                    // let postsCollectionRef = fire.firestore().collection("posts").where("category", "==", doc.id).orderBy("views", "desc").limit(3);
                    // postsCollectionRef.get().then(function(collection){
                    //     collection.forEach(function(doc){
                    //         let array = x.state.categories[i].concat(doc.id);
                    //         x.setState({categories:array});
                    //     })
                    // });
                }
                i = i+1;
            })
            
            //console.log("LOAD CATEGORIES", x.state.categories);
        })
    }

    loadTopPosts = () =>{
        this.setState({loadedTopPosts: true}) //call this right away to ensure that loadTopPosts() is only called once.
        let x = this;
        let categoryArray = this.state.categories;

        categoryArray.forEach(function(category){
            console.log("CATEGORY: ", category);
            let collectionRef = fire.firestore().collection('posts').where("category", "==", category).orderBy("views", "desc").limit(2);
            
            collectionRef.get().then(function(collection){
                console.log("Collection: ", collection);
                if (collection.size === 1){
                    collection.forEach(function(data){
                        let tempArray = [category, data.id];
                        // counter+=1;
                        let newArray = x.state.top_posts;
                        newArray.push(tempArray);
                        x.setState({top_posts:newArray})
                        //console.log(x.state.top_posts);
                        console.log("go here?3");
                    })
                }
                else if (collection.size === 2){
                    console.log("go here?4");
                    let innerArray = [category];
                    // counter+=1;
                    collection.forEach(function(data){
                        innerArray.push(data.id);
                        if (Object.keys(innerArray).length === 2){
                            let newArray = x.state.top_posts;
                            newArray.push(innerArray);
                            x.setState({top_posts:newArray})
                            console.log("go here?5");
                        }
                    })
                }
                else{ //size is 0
                    let tempArray = [category];
                    // counter+=1;
                    let newArray = x.state.top_posts;
                    newArray.push(tempArray);
                    x.setState({top_posts:newArray})
                }   
                x.setState({loadedTopPosts2: true})

                console.log("TOP POSTS: ",x.state.top_posts);
        })
    })
        // counter =0;
    }

    handleClick = (e) =>{
        let title = e.target.id;
        this.props.updateDisplayPosts(title);
    }

    parseTopPosts = () =>{
        let indexer = this.state.indexer;
        this.setState({indexer: indexer+1}) //increment indexer
        if (this.state.indexer === 5){
            this.setState({indexer: 0, loadedTopPosts2:false});
            return;
        }
        let indexOf = this.state.top_posts.indexOf(indexer);
        console.log(indexOf);
        if (typeof this.state.top_posts[indexOf+1] === "string" && indexOf !==-1){ 
            console.log("go here1");
            if (typeof this.state.top_posts[indexOf+2] === "string"){
                console.log("go here2");
                return (<div><li><a>{this.state.top_posts[indexOf+1]}</a></li>
                <li><a>{this.state.top_posts[indexOf+2]}</a></li></div>);
            }
            else{
                console.log("go here3");
                return <li><a>{this.state.top_posts[indexOf+1]}</a></li>;
            }
        }
        else{
            console.log("go here4");
            //no top posts...
            return;
        } 
    }

    increaseIndexer = () =>{
        this.setState({indexer: this.state.indexer+1})
        return this.state.indexer;
    }

    render(){
        // let indexer = this.increaseIndexer();
      return(
        <div>
            {!this.state.loadedCategories ? this.loadCategories(): null}
            {(this.state.loadedCategories && !this.state.loadedTopPosts) ? this.loadTopPosts():null}
              <h2>Popular Right Now</h2>
              
              {(this.state.loadedCategories && this.state.loadedTopPosts2) ? this.state.top_posts.map(i =>{ 
                  let subArray = i.slice(1);
                    let j = subArray.map(cell => <li><a id = {cell} onClick = {this.handleClick}>{cell}</a></li>);
                  return <div><h3>{i.slice(0,1)}</h3><div>{j}</div></div>;
              }): null}
                    {/* return (<div>
                        <h3>{i}</h3>
                        <ul> */}
                        {/* {(this.state.loadedCategories && this.state.loadedTopPosts2) ?  */}
                            {/* {this.state.top_posts[indexer]} */}
                            {/* {(this.state.loadedCategories && this.state.loadedTopPosts2) ? this.increaseIndexer(): null} */}
                            {/* // [2].map(j=>{
                            //     return(<li><a>{j}</a></li>)
                            // })} */}
                            {/* : null} */}
                    {/* </ul></div>
              )}): null} */}
              
            </div>
      )
    }
  }

export default Popular;