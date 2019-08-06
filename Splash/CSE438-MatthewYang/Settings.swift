//
//  Settings.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/26/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Settings: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch (section){
        case 0: return 1
        case 1: return 1
        //case 2: return 1
        //case 3: return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Log out user if "Sign out" is selected
        if indexPath.section == 2 {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Logged out")
                sendToLogin()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    // Send user to login screen
    func sendToLogin() {
        self.performSegue(withIdentifier: "toLoginScreen", sender: nil)
    }
}
