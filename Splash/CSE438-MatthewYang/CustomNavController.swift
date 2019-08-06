//
//  CustomNavController.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/9/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CustomNavController: UINavigationController {
    
    func sendToLogin() {
        //        let loginVC = LoginViewController()
        //        navigationController?.pushViewController(loginVC, animated: true)
        print("sending to login")
        self.performSegue(withIdentifier: "toLoginScreen", sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            print("logged in as \(String(describing: Auth.auth().currentUser?.displayName!))")
            //            loggedInLabel.text = "Logged in as \(String(describing: Auth.auth().currentUser?.displayName))"
            
        } else {
            // No user is signed in.
            // ...
            print("not logged in")
            sendToLogin()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
    }
}
