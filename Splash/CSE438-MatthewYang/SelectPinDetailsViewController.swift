//
//  SelectPinDetailsViewController.swift
//  CSE438-MatthewYang
//
//  Created by Brandon Lum on 11/11/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseStorage

class SelectPinDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let themeColor = UIColor.init(red: 0.35, green: 0.682, blue: 0.996078, alpha: 1)
    
    let firebaseAuth = Auth.auth()
    let database = Firestore.firestore()
    
    var imageData: Data?
    
    var maleSelected: Bool = false
    var femaleSelected: Bool = false
    var neutralSelected: Bool = false
    var isBathroom = true
    var imageUploaded: Bool = false
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func uploadImagePressed(_ sender: Any) {
        let myAlert = UIAlertController(title: "Select Image From", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){(action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let cameraRollAction = UIAlertAction(title: "Photo Library", style : .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            uploadOrSuccessImage.image = UIImage(named:"Checkmark.png")
            uploadOrChangeButton.setTitle("Image Uploaded", for: .normal)
            
            self.imageData = UIImageJPEGRepresentation(image, 0.1)
            imageUploaded = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var uploadOrSuccessImage: UIImageView!
    @IBOutlet weak var uploadOrChangeButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!
    var correctlyFilled: Bool = false
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    
    @IBAction func malePressed(_ sender: Any) {
        maleButton.layer.cornerRadius = 0.5 * maleButton.bounds.size.width
        if !maleSelected{
            detail = "Cold"
            if isBathroom{
                detail = "Men's"
            }
            maleSelected = true
            femaleSelected = false
            neutralSelected = false
            neutralButton.backgroundColor = UIColor.white
            femaleButton.backgroundColor = UIColor.white
            maleButton.backgroundColor = themeColor
        }
        else{
            maleSelected = false
            maleButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func femalePressed(_ sender: Any) {
        femaleButton.layer.cornerRadius = 0.5 * femaleButton.bounds.size.width
        if !femaleSelected{
            detail = "Medium"
            if isBathroom{
                detail = "Women's"
            }
            femaleSelected = true
            neutralSelected = false
            maleSelected = false
            femaleButton.backgroundColor = themeColor
            maleButton.backgroundColor = UIColor.white
            neutralButton.backgroundColor = UIColor.white
        }
        else{
            femaleSelected = false
            femaleButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func neutralPressed(_ sender: Any) {
        neutralButton.layer.cornerRadius = 0.5 * neutralButton.bounds.size.width
        if !neutralSelected{
            detail = "Warm"
            if isBathroom{
                detail = "Neutral"
            }
            neutralSelected = true
            femaleSelected = false
            maleSelected = false
            neutralButton.backgroundColor = themeColor
            femaleButton.backgroundColor = UIColor.white
            maleButton.backgroundColor = UIColor.white
        }
        else{
            neutralSelected = false
            neutralButton.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var segCon: UISegmentedControl!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var floorPicker: UIPickerView!
    @IBOutlet weak var selectPinLocationButton: UIButton!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var descri: UILabel!
    @IBOutlet weak var descrip: UITextView!
    
    
    //defaults
    var object: String = "Bathroom" // bathroom or water fountain
    var floor: String = "5th Floor" // floor
    var building: String = "Building Name" // building name / location
    var detail: String = "" //gender or temp
    var otherOption: Bool = false //shower/bottle
    var lat = 0
    var long = 0
    
    
    var location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    
    var detailsArray = ["Men's", "Women's", "Neutral"]
    let genderArray = ["Men's", "Women's", "Neutral"]
    let tempArray = ["Cold", "Room Temp.", "Hot"]
    let floorArray = ["5th Floor", "4th Floor", "3rd Floor", "2nd Floor", "1st Floor", "0th Floor", "-1st Floor", "-2nd Floor", "-3rd Floor", "-4th FLoor"]//0th or ground?
    let placeholderText = "Description here"
    
    @IBAction func objectSelected(_ sender: Any) {
        
        if(segCon.selectedSegmentIndex == 0){
            isBathroom = true
            detailsArray = genderArray
            optionButton.setTitle("Shower", for: .normal)
            object = "Bathroom"
            maleButton.setImage(UIImage(named:"Male.png"), for: .normal)
            femaleButton.setImage(UIImage(named:"Female.png"), for: .normal)
            neutralButton.setImage(UIImage(named:"Neutral.png"), for: .normal)
        }
        else {
            isBathroom = false
            detailsArray = tempArray
            optionButton.setTitle("Bottle Filler", for: .normal)
            object = "Water Fountain"
            maleButton.setImage(UIImage(named:"snowflake.png"), for: .normal)
            femaleButton.setImage(UIImage(named:"glass.png"), for: .normal)
            neutralButton.setImage(UIImage(named:"coffee-cup.png"), for: .normal)
        }
        
        //self.picker.reloadAllComponents() //reloads picker with data
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return detailsArray.count;
        }
        else{
            return floorArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return detailsArray[row];
        }
        else {
            return floorArray[row];
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            detail = detailsArray[row];//changes global varibales
        }
        if(pickerView.tag == 1) {
            floor = floorArray[row];
        }
    }
    
    //from stack overflow
    @IBAction func optionButtonCheckBox(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
                sender.isSelected = !sender.isSelected
                sender.transform = .identity
            }, completion: nil)
        }
        otherOption = !otherOption;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    @IBAction func selectPinLocationButtonPressed(_ sender: Any) {
        if (buildingTextField.text == "" || descrip.text == "" || descrip.text == "Description" || (!maleSelected && !femaleSelected && !neutralSelected) || !imageUploaded){
            //Should not update Firebase
            errorMessage.alpha = 1
            correctlyFilled = false
        }
        else{
            correctlyFilled = true
            errorMessage.alpha = 0
            //Everything is filled out correctly. Update Firebase.
            self.performSegue(withIdentifier: "SeguePinSelectionToMap", sender: self)
            var ref: DocumentReference? = nil
            ref = database.collection("pins").addDocument(data: [
                "building": building,
                "object": object,
                "lat": location.latitude,
                "long": location.longitude,
                "floor": floor,
                "detail": detail,
                "otherOption": otherOption,
                "description": descrip.text!,
                "pinLoaded": false
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            // Upload photo to Firebase
            let storage = Storage.storage()
            let storageRef = storage.reference()
            
            // Create a reference to the image
            let pinPhotosRef = storageRef.child("pinPhotos/\(ref!.documentID).jpg")
            
            // Upload the image to the userProfiles folder
            let uploadTask = pinPhotosRef.putData(self.imageData! as Data, metadata: nil) { metadata, error in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!){
        if segue.identifier == "SeguePinSelectionToMap"{
            print("pin to map button pressed; location = ")
            print(location)
            print(object)
            
            // IF READ AND WRITE TO DATABSE CHANGE TO DISMISS??
            
            let vc = segue.destination as! MapViewController
            
            //            let newAnnotation = MKPointAnnotation()
            //            newAnnotation.coordinate = location
            //            print(location)
            //            newAnnotation.title = (object+" "+detail+" "+building)
            //            print((object+" "+detail+" "+building))
            //            newAnnotation.subtitle = (floor)
            
            let newAnnotation = CustomAnnotation(title: object+" "+detail+" "+building, sub: floor, coordinate: location, object: object)
            vc.addingAnnotation = newAnnotation
            
            vc.addingLoc = location
            vc.addingSub = floor
            vc.addingTitle = (object+" "+detail+" "+building)
            vc.addingObject = object
            
            vc.isAddingPin = true
        }
    }
    
    
    @IBAction func getBuildingName(_ sender: Any) {
        building = buildingTextField.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        maleButton.setBackgroundImage(UIImage(), for: .normal)
        femaleButton.setBackgroundImage(UIImage(), for: .normal)
        neutralButton.setBackgroundImage(UIImage(), for: .normal)
        
        maleButton.setImage(UIImage(named:"Male.png"), for: .normal)
        femaleButton.setImage(UIImage(named:"Female.png"), for: .normal)
        neutralButton.setImage(UIImage(named:"Neutral.png"), for: .normal)
        
        floorPicker.delegate = self
        floorPicker.dataSource = self
        
        descrip.text = "Description"
        descrip.textColor = UIColor.lightGray
        descrip.returnKeyType = .done
        descrip.delegate = self
        optionButton.setImage(UIImage(named:"Checkmarkempty"), for: .normal)
        optionButton.setImage(UIImage(named:"Checkmark"), for: .selected)
        
        errorMessage.alpha = 0
    }
    
    
    //from https://www.youtube.com/watch?v=k6KBEspZxm8
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

