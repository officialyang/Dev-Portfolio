import firebase from 'firebase';

  const config = {
    apiKey: "AIzaSyBNy2BVbCmdYOFTi0YT07XzhSNzojdEA68",
    authDomain: "swimoverflow.firebaseapp.com",
    databaseURL: "https://swimoverflow.firebaseio.com",
    projectId: "swimoverflow",
    storageBucket: "swimoverflow.appspot.com",
    messagingSenderId: "165244594053"
  };
  const fire = firebase.initializeApp(config);
  export default fire;
