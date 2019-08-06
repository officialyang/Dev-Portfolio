import React, { Component } from 'react';
import fire from './config/Fire';
 
import './App.css';
 
class ConversationList extends Component{
    constructor(props){
        super(props);
        this.state = {
            conversations: props.conversations,
            doc_ids: props.doc_ids,
            index: -1,
        }
    }
 
    handleClick = (e) =>{
        e.preventDefault();
        let otherUser = document.getElementById(e.target.id).innerHTML;
        let position = this.state.conversations.indexOf(otherUser);
        let doc_id = this.state.doc_ids[position];
        this.props.setRefreshed();
        this.props.pickConversation(otherUser,doc_id);
    }
 
    render(){
        return(
            <div>
                <ul>
                    {this.state.conversations.map(i =>{
                        return <li><a id = {i} onClick = {this.handleClick}>{i}</a></li>
                    })}
                </ul>
            </div>
        )
    }
}
 
class Conversations extends Component{
    constructor(props){
        super(props);
        this.state = {
            thisUser: props.username,
            hasConversationOpen: false,
            otherUser : "",
            conversationID : "",
            conversations: [],
            doc_ids: [],
            numConversations: 0,
            finishedLoading: false,
            justRefreshed: false,
        }
    }
 
    setRefreshed = () =>{
        this.setState({justRefreshed: !this.state.justRefreshed});
    }
 
    loadConversations = () =>{
            let collectionRef = fire.firestore().collection('messages');
            let x=this;
            collectionRef.get().then(function(collection){
                document.getElementById('conversations').innerHTML = "";
                let finishedLoading = x.state.finishedLoading;
                if (!finishedLoading){
                collection.forEach(function(doc){
                    let user1 = doc.data().user1;
                    let user2 = doc.data().user2;
                    let conversationID = doc.id;
                    
                    if(user1 === x.state.thisUser || user2 === x.state.thisUser){
                        if (user1 === x.state.thisUser){
                            x.state.conversations[x.state.numConversations] = user2;
                            x.state.doc_ids[x.state.numConversations] = conversationID;                        }
                        else{
                            x.state.conversations[x.state.numConversations] = user1;
                            x.state.doc_ids[x.state.numConversations] = conversationID;
                        }
 
                        x.setState({numConversations: x.state.numConversations+1})
                    }
 
                });
            }
                x.setState({finishedLoading:true})
 
            }).catch((error)=>{
                let errorMessage = error;
                console.log("error retrieving messages collection: ", errorMessage);
            });
       
    }
 
    loadExisting = (e) =>{
        let otherUser = document.getElementById(e.target.id).innerHTML;
        let conversationID = e.target.id;
        this.pickConversation(otherUser,conversationID);
    }
 
    pickConversation = (other, conversationID) => {
        if (this.state.justRefreshed){
            this.setState({thisUser: this.state.thisUser, hasConversationOpen: false, otherUser: other, conversationID:conversationID});
        }
        else{
            this.setState({thisUser: this.state.thisUser, hasConversationOpen: true, otherUser: other, conversationID:conversationID});
        }
    }
 
    checkForExistingConversation = (e) => {
        e.preventDefault();
        //check if user already has conversation with this person
        if (this.state.thisUser === "guest"){
            document.getElementById("error-message4").innerHTML = "Only logged in users can message other users";
        }
        else{
            let messagesCollectionRef = fire.firestore().collection('messages');
            let x = this;
            messagesCollectionRef.get().then(function(collection){
                let foundConvo = false;
                collection.forEach(function(doc){
                    let user1 = doc.data().user1;
                    let user2 = doc.data().user2;
                    if((user1 == x.state.thisUser && user2 == x.state.otherUser) ||
                        (user2 == x.state.thisUser && user1 == x.state.otherUser)){
                            //conversation exists
                            foundConvo = true;
                            x.pickConversation(x.state.otherUser, doc.id);
                           
                        }
                });
                if(!foundConvo){
                    x.newConversation();
                }
            });
        }
    }
 
    newConversation = () => {
        //check if user exists
            let userCollectionRef = fire.firestore().collection('users');
            let x = this;
            userCollectionRef.get().then(function(collection){
                let userExists = false;
               
                collection.forEach(function(doc){
                    let user = doc.data().username;
                    if(user == x.state.otherUser){
                        userExists = true;
                    }
                });
                if(!userExists){
                    //TODO write error message or something
                    alert("user does not exist");
                }
                else{
                    //create conversation
                    fire.firestore().collection("messages").doc().set({
                        messages: {}, user1: x.state.thisUser, user2: x.state.otherUser
                    }).then(function(){
                        //join conversation
                        x.loadConversations();
                       
                        x.pickConversation(x.state.otherUser, x.state.conversationID);
                    }).catch((error)=>{
                        console.log("error while creating conversation: ",error);
                    });
                }
 
            }).catch((error)=>{
                let errorMessage = error;
                console.log("error retrieving users collection: ",errorMessage);
            });
       
         
    }
 
    checkForAllowableConversation = (e) =>{
        e.preventDefault();

        if (this.state.thisUser === "guest"){
            document.getElementById("error-message4").innerHTML = "Only logged in users can message other users";
        }

        else if(this.state.otherUser === "guest" || this.state.otherUser === this.state.thisUser || this.state.otherUser === ""){
            //bad
            document.getElementById("error-message4").innerHTML = "Cannot create conversation with yourself or a guest.";
            //alert("cannot create conversation with guest or yourself");
            this.setState({otherUser:""});
        }
        else{
            this.checkForExistingConversation(e);
        }
    }
 
    handleChange = (e) => {
        this.setState({[e.target.name]: e.target.value});
    }

    componentDidMount() {
        this.interval = setInterval(() => this.loadConversations(), 1000);
        //Every 10 seconds, refresh the page to get most recent update
      }

    componentWillUnmount() {
        clearInterval(this.interval);
    }
 
    render(){
        return(
            <div>
                <h2>Messages</h2>
                {/* {this.loadConversations()} */}
                <form>
                    <label>New Conversation with:</label>  
                    <input type = "text" id = "requestedUser" name="otherUser"value = {this.state.otherUser} onChange = {this.handleChange}/>
                    <button type = "submit" onClick = {this.checkForAllowableConversation}>Begin</button>
                </form>
                <ul id = "conversations"></ul>
                <p id = "error-message4"></p>
                {this.state.finishedLoading ? <ConversationList conversations = {this.state.conversations} doc_ids={this.state.doc_ids} pickConversation={this.pickConversation} setRefreshed={this.setRefreshed}/>: null}
                {(this.state.hasConversationOpen)?(<Messages username={this.state.thisUser} otherUser={this.state.otherUser} conversationID={this.state.conversationID}/>):(null)}
            </div>
        )
    }
}
 
class Messages extends Component{
    constructor(props){
        super(props);
        this.state = {
            msg: "",
            otherUser: props.otherUser,
            thisUser: props.username,
            conversationID: props.conversationID,
            messages: new Array (0),
            isLoaded: false,
        }
    }
 
    loadMessages = () =>{
        if (this.state.conversationID !== "" && this.state.conversationID !== null){
            let conversationDocRef = fire.firestore().collection("messages").doc(this.state.conversationID);
            let x = this;
            conversationDocRef.get().then(function(doc){
                let messages = doc.data().messages;
                document.getElementById("chat").innerHTML ="";

                x.setState({messages:messages});
                for(let i=0; i<Object.keys(messages).length; i=i+2){
                    let author = messages[i];
                    let msg = messages[i+1];
                    document.getElementById("chat").innerHTML = "<p>" + author + ": " + msg + "</p>" + document.getElementById("chat").innerHTML;
                }
            }).catch((error)=>{
                console.log("messages loading error: ", error);
            })
        }
    }
 
    writeMessage = (e) =>{
        e.preventDefault();
        let conversationDocRef = fire.firestore().collection("messages").doc(this.state.conversationID);
        let x = this;
        let messagesLength = Object.keys(this.state.messages).length;

        if(messagesLength<0 || messagesLength==null){
            messagesLength=0;
        }
        let messages = this.state.messages;

        messages[messagesLength] = x.state.thisUser;
        messages[messagesLength+1] = x.state.msg;

        conversationDocRef.update({
            messages:messages
        }).then(function(doc){
            x.loadMessages();
        });

        this.setState({msg:""});
 
    }

    componentDidMount() {
        this.interval = setInterval(() => this.loadMessages(), 500);
        //Every 10 seconds, refresh the page to get most recent update
      }

    componentWillUnmount() {
        clearInterval(this.interval);
    }
 
    handleChange = (e) =>{
        this.setState({[e.target.name]: e.target.value});
    }
 
    render(){
        return(
            <div>
                {/* {this.loadMessages()} */}
                <h2>Conversation with {this.state.otherUser}</h2>
                <p id = "messages"></p>
                <form>
                    <label>Type a message:
                        <input type = "text" name = "msg" id= "msg" value = {this.state.msg} onChange = {this.handleChange}/>
                        <button type = "submit" onClick = {this.writeMessage}>Send</button>
                    </label>
                    <div id = "chat"></div>
 
                </form>
               
               
            </div>
 
        )
    }
 
 
 
}
 
export default Conversations;