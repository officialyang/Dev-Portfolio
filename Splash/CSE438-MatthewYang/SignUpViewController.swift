//
//  SignUpViewController.swift
//  Splash
//
//  Created by Alex Appel on 11/11/18.
//  Copyright © 2018 Alex Appel. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let database = Firestore.firestore()
    
    
    @IBAction func handleSignUp(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        
        
        // Create user
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                // Change user display name
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges { (error) in
                    if error == nil {
                        print("User display name changed!")
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                
            } else {
//                                print("Error creating user: \(error!.localizedDescription)")
//                
//                                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
//                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                                    switch action.style{
//                                    case .default:
//                                        print("default")
//
//                                    case .cancel:
//                                        print("cancel")
//
//                                    case .destructive:
//                                        print("destructive")
//
//                
//                                    }}))
//                                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        var ref: DocumentReference? = nil
        ref = database.collection("userData").addDocument(data: [
            "profileName": fullName,
            "email": email.lowercased(),
            "username": username.lowercased()
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
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

