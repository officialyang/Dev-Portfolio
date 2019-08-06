//
//  Accounts.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/24/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//
// Help from: https://stackoverflow.com/questions/25510081/how-to-allow-user-to-pick-the-image-with-swift

import UIKit
import Firebase
import FirebaseStorage

class Accounts: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameOfUser: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    static var image = UIImage()
    
    let db = Firestore.firestore()
    
    var imagePicker:UIImagePickerController? = UIImagePickerController()
    
    public func setImage (profileImage2:UIImage){
        Accounts.image = profileImage2
        profileImage.image = Accounts.image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(profileImage2: Accounts.image)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        imagePicker?.delegate = self
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            let username = user.displayName
            let email = user.email
            var nameOfUser = ""
            var documentID = ""
            
            db.collection("userData").whereField("email", isEqualTo: email!.lowercased()).whereField("username", isEqualTo: username!.lowercased()).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        documentID = document.documentID
                        for element in document.data() {
                            print(element)
                            if (element.key == "profileName") {
                                nameOfUser = element.value as! String

                                self.username.text = username
                                self.nameOfUser.text = nameOfUser
                                self.email.text = email
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
                        print("Error: \(error)")
                    } else {
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                    }
                }
            }
        }
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker?.sourceType = .savedPhotosAlbum
            
            imagePicker?.allowsEditing = true
            self.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func uploadImageToFirebase(data: NSData) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            let username = user.displayName
            let email = user.email
            var documentID = ""
            
            db.collection("userData").whereField("email", isEqualTo: email!.lowercased()).whereField("username", isEqualTo: username!.lowercased()).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        documentID = document.documentID
                    }
                }
                
                let storage = Storage.storage()
                let storageRef = storage.reference()
                
                // Create a reference to the image
                let userProfileRef = storageRef.child("userProfiles/\(documentID).jpg")
                
                // Upload the image to the userProfiles folder
                let uploadTask = userProfileRef.putData(data as Data, metadata: nil) { metadata, error in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    storageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        print("downloadURL: \(downloadURL)")
                    }
                }
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("the picker is \(picker)")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImage.image = image
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        uploadImageToFirebase(data: imageData! as NSData)
        
        imagePicker?.dismiss(animated: true, completion: nil)
        //pickImageCallback?(image)
        
    }
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        //print ("hey")
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//
//        profileImage.image = image
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAccount(_ sender: Any) {
        Accounts.image = profileImage.image!
        SideMenu.accountImage = profileImage.image!
        self.dismiss(animated: true, completion: nil)
    }
    
}
