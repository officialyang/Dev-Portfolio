//
//  CustomMenuBar.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/24/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SideMenu: UITableViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    
    static var accountImage: UIImage!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
 
        
        let user = Auth.auth().currentUser
        if let user = user {
            let username = user.displayName
            let email = user.email
            var nameOfUser = ""
            var documentID = ""
            
            print(email!)
            db.collection("userData").whereField("email", isEqualTo: email!.lowercased()).whereField("username", isEqualTo: username!.lowercased()).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        documentID = document.documentID
                        for element in document.data() {
                            if (element.key == "profileName") {
                                nameOfUser = element.value as! String
                                self.profileName.text = nameOfUser
                                self.profileUsername.text = username
                            }
                        }
                    }
                }
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                
                // Create a reference to the image
                let userProfileRef = storageRef.child("userProfiles/\(documentID).jpg")
                
                // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                let downloadTask = userProfileRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                    if let error = error {
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                        Accounts.image = image!
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toAccount"){
           let destination = segue.destination as? Accounts
            //pass image to the next view
            destination?.setImage(profileImage2: profileImage.image!)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        profileImage.image = Accounts.image
    }
}
