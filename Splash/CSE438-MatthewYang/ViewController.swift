//
//  ViewController.swift
//  Splash
//
//  Created by Alex Appel on 11/5/18.
//  Copyright © 2018 Alex Appel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController {

//    @IBOutlet weak var quoteLabel: UILabel!
//    @IBOutlet weak var btn: UIButton!
//    @IBOutlet weak var fetchBtn: UIButton!
//    var docRef: DocumentReference!
    
//
//    @IBAction func save(_ sender: Any) {
//        let dataToSave: [String: Any] = ["name": "Simon", "password": "myPassword"]
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("Oh no! Got an error: \(error.localizedDescription)")
//            } else {
//                print("Data has been saved!")
//            }
//        }
//    }
//
//    @IBAction func fetch(_ sender: Any) {
//        docRef.getDocument { (docSnapshot, error) in
//            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
//            let myData = docSnapshot.data()
//            let latestQuote = myData?["name"] as? String ?? ""
//            let quoteAuthor = myData?["password"] as? String ?? "(none)"
//            self.quoteLabel.text = "\(latestQuote)\" -- \(quoteAuthor)"
//
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if let user = Auth.auth().currentUser {
//            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
//        }
//    }
    
    @IBOutlet weak var loggedInLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    func sendToLogin() {
//        let loginVC = LoginViewController()
//        navigationController?.pushViewController(loginVC, animated: true)
        print("sending to login")
        self.performSegue(withIdentifier: "toLoginScreen", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("logged out")
            sendToLogin()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            print("logged in as \(String(describing: Auth.auth().currentUser?.displayName!))")
            loggedInLabel.text = "Logged in as \(String(describing: Auth.auth().currentUser?.displayName))"

        } else {
            // No user is signed in.
            // ...
            print("not logged in")
            sendToLogin()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        let date = Date()
//        let dataToSave: [String: Any] = ["name": firebaseAuth.currentUser?.displayName ?? "user not found", "date": date, "location": "someLocation", "review": "some review goes here"]
//        docRef.setData(dataToSave) { (error) in
//            if let error = error {
//                print("Oh no! Got an error: \(error.localizedDescription)")
//            } else {
//                print("Data has been saved!")
//            }
//        }
//        var ref: DocumentReference? = nil
//        ref = db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        let database = Firestore.firestore()
        
        let name = firebaseAuth.currentUser?.displayName
        
        var ref: DocumentReference? = nil
        ref = database.collection("reviews").addDocument(data: [
            "name": name ?? "undefined",
            "date": date,
            "location": "someLocation",
            "type": "restroom",
            "crowdedness": 3,
            "cleanliness": 4,
            "overall": 4,
            "review": "some review goes here"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        
//        if Auth.auth().currentUser != nil {
//            // User is signed in.
//            // ...
//            print("logged in as \(String(describing: Auth.auth().currentUser?.displayName!))")
//            loggedInLabel.text = "Logged in as \(String(describing: Auth.auth().currentUser?.displayName))"
//
//        } else {
//            // No user is signed in.
//            // ...
//            print("not logged in")
//            sendToLogin()
//        }
    }
//        docRef = Firestore.firestore().document("users/userData")
        
        
//        let actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.url = URL(string: "https://www.example.com")
//        // The sign-in operation has to always be completed in the app.
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//        actionCodeSettings.setAndroidPackageName("com.example.android",
//                                                 installIfNotAvailable: false, minimumVersion: "12")
//
//        var email = "alex.appel97@gmail.com"
//
//        Auth.auth().sendSignInLink(toEmail:email,
//            actionCodeSettings: actionCodeSettings) { error in
//            // ...
//            if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
//                return
//            }
//            // The link was successfully sent. Inform the user.
//            // Save the email locally so you don't need to ask the user for it again
//            // if they open the link on the same device.
//            UserDefaults.standard.set(email, forKey: "Email")
//            self.showMessagePrompt("Check your email for link")
//            // ...
//        }
        
//    func showMessagePrompt() {
//        print("showMessagePrompt()")
//        return
//    }
//
}

