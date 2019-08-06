//
//  ViewController.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/5/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, SWRevealViewControllerDelegate{
    
    
    let db = Firestore.firestore()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var toiletFilter: UIButton!
    @IBOutlet weak var fountainFilter: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    //RGB Values: R-89, G-174, B-254
    let themeColor = UIColor.init(red: 0.35, green: 0.682, blue: 0.996078, alpha: 1)
    let buttonColor1 = UIColor.init(red: 0.35, green: 0.682, blue: 0.996078, alpha: 0.3)
    let buttonColor2 = UIColor.init(red: 0.35, green: 0.682, blue: 0.996078, alpha: 0.0)
    var currentLatitude = 38.6485577
    var currentLongitude = -90.311407
    var currentLocation: CLLocation!
    let locManager = CLLocationManager()
    var toilet = true
    var fountain = true
    var once = false
    

    var addingAnnotation = CustomAnnotation(title: "", sub: "", coordinate: CLLocationCoordinate2D(), object: "")
    var isAddingPin = false
    var addingTitle = ""
    var addingSub = ""
    var addingLoc = CLLocationCoordinate2D()
    var addingObject = ""
    
    var selectedAnnotation = CustomAnnotation(title: "", sub: "", coordinate: CLLocationCoordinate2D(), object: "")
//    var images:[UIImage] = []

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        revealViewController()?.delegate = self
        self.locManager.requestWhenInUseAuthorization()
        self.mapView.delegate = self
        mapView.register(CustomAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //Toilet and water fountain filters
        toiletFilter.layer.cornerRadius = 0.5*toiletFilter.bounds.size.width
        fountainFilter.layer.cornerRadius = 0.5*fountainFilter.bounds.size.width
 
        toiletFilter.backgroundColor = buttonColor1
        fountainFilter.backgroundColor = buttonColor1
        warningLabel.alpha = 0.0
        warningLabel.lineBreakMode = .byWordWrapping
        warningLabel.numberOfLines = 2
        
        
        if CLLocationManager.locationServicesEnabled(){
            self.locManager.delegate = self
            self.locManager.desiredAccuracy = kCLLocationAccuracyBest
        
            self.locManager.startUpdatingLocation()
        }
    
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: false)
    
    //ANOTATIONS
        
        // DELETE THIS LATER
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "DUC Bathroom"
//        annotation.subtitle = "SIMON ROCKS"
//        mapView.addAnnotation(annotation)
    
        let washULocation: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: currentLatitude, longitude: currentLongitude)
    
        let currentLocView = MKMapCamera.init(lookingAtCenter: washULocation, fromDistance: 100, pitch: 100, heading: 100)
        mapView.setCamera(currentLocView, animated: false)
    
        
        sideMenus()

        loadPins()
       

    }//viewdidload
    
    //toilet and fountain button presses
    @IBAction func toiletTouch(_ sender: Any) {
        toiletTouch1()
    }
    @IBAction func fountainTouch(_ sender: Any) {
        fountainTouch1()
    }
    
    func toiletTouch1(){
        
        toilet = !toilet
        
        if (toilet){
            toiletFilter.backgroundColor = buttonColor1
            warningLabel.alpha = 0.0
            if !fountain {
                displayFilteredPins(object: "Bathroom")
            }
            else {
                loadPins()
            }
            
        }
        else{
            
            toiletFilter.backgroundColor = buttonColor2
            
            
            
            if (!fountain){
                warningLabel.alpha = 1.0
                mapView.removeAnnotations(mapView.annotations)
            }
            else {
                displayFilteredPins(object: "Water Fountain")
            }
        }
        
        
    }
    
    func fountainTouch1(){
        
        fountain = !fountain
        
        
        if (fountain){
            fountainFilter.backgroundColor = buttonColor1
            warningLabel.alpha = 0.0
            
            if !toilet {
                displayFilteredPins(object: "Water Fountain")
            }
            else {
                loadPins()
            }
            
        }
        else{
            fountainFilter.backgroundColor = buttonColor2
            
            
            if (!toilet){
                warningLabel.alpha = 1.0
                mapView.removeAnnotations(mapView.annotations)
            }
            else {
                displayFilteredPins(object: "Bathroom")
            }
        }
    }
    
    
    func displayFilteredPins(object: String) {
        
        // First remove all pins
        mapView.removeAnnotations(mapView.annotations)
        
        
        // Retrieve only the desired pins
        db.collection("pins").whereField("object", isEqualTo: object).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var latitudeChanged: Bool = false
                    var longitudeChanged: Bool = false
                    var buildingChanged: Bool = false
                    var pinDescriptionChanged: Bool = false
                    var detailChanged: Bool = false
                    var objectChanged: Bool = false
                    
                    var longitude: Double = 0.0
                    var latitude: Double = 0.0
                    var building = ""
                    var pinDescription = ""
                    var detail = ""
                    var object = ""
                    
                    for element in document.data() {
                        if element.key == "long" {
                            longitude = element.value as! Double
                            longitudeChanged = true
                        }
                        else if element.key == "lat" {
                            latitude = element.value as! Double
                            latitudeChanged = true
                        }
                        else if element.key == "building" {
                            building = element.value as! String
                            buildingChanged = true
                        }
                        else if element.key == "description" {
                            pinDescription = element.value as! String
                            pinDescriptionChanged = true
                        }
                        else if element.key == "detail" {
                            detail = element.value as! String
                            detailChanged = true
                        }
                        else if element.key == "object" {
                            object = element.value as! String
                            objectChanged = true
                        }
                        
                        if (longitudeChanged && latitudeChanged && buildingChanged && pinDescriptionChanged && detailChanged && objectChanged) {
                            let location = CLLocationCoordinate2D.init(latitude: Double(latitude), longitude: Double(longitude))
                            latitudeChanged = false
                            longitudeChanged = false
                            buildingChanged = false
                            pinDescriptionChanged = false
                            detailChanged = false
                            objectChanged = false
                            
                            
                            let annotation = CustomAnnotation(title: object + " " + detail + " " + building, sub: pinDescription, coordinate: location, object: object)
                            self.mapView.addAnnotation(annotation)
                            
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    func loadPins() {
        // Load pins from firestore database
        db.collection("pins").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    var latitudeChanged: Bool = false
                    var longitudeChanged: Bool = false
                    var buildingChanged: Bool = false
                    var pinDescriptionChanged: Bool = false
                    var detailChanged: Bool = false
                    var objectChanged: Bool = false
                    
                    var longitude: Double = 0.0
                    var latitude: Double = 0.0
                    var building = ""
                    var pinDescription = ""
                    var detail = ""
                    var object = ""
                    
                    for element in document.data() {
                        if element.key == "long" {
                            longitude = element.value as! Double
                            longitudeChanged = true
                        }
                        else if element.key == "lat" {
                            latitude = element.value as! Double
                            latitudeChanged = true
                        }
                        else if element.key == "building" {
                            building = element.value as! String
                            buildingChanged = true
                        }
                        else if element.key == "description" {
                            pinDescription = element.value as! String
                            pinDescriptionChanged = true
                        }
                        else if element.key == "detail" {
                            detail = element.value as! String
                            detailChanged = true
                        }
                        else if element.key == "object" {
                            object = element.value as! String
                            objectChanged = true
                        }
                        

                        if (longitudeChanged && latitudeChanged && buildingChanged && pinDescriptionChanged && detailChanged && objectChanged) {
                            let location = CLLocationCoordinate2D.init(latitude: Double(latitude), longitude: Double(longitude))
                            latitudeChanged = false
                            longitudeChanged = false
                            buildingChanged = false
                            pinDescriptionChanged = false
                            detailChanged = false
                            objectChanged = false
                            
                            let annotation = CustomAnnotation(title: object + " " + detail + " " + building, sub: pinDescription, coordinate: location, object: object)
                            self.mapView.addAnnotation(annotation)

                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    func displayGender(gender: String) {
        // Retrieve only the desired pins
        db.collection("pins").whereField("detail", isEqualTo: gender).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var latitudeChanged: Bool = false
                    var longitudeChanged: Bool = false
                    var buildingChanged: Bool = false
                    var pinDescriptionChanged: Bool = false
                    var detailChanged: Bool = false
                    var objectChanged: Bool = false
                    
                    var longitude: Double = 0.0
                    var latitude: Double = 0.0
                    var building = ""
                    var pinDescription = ""
                    var detail = ""
                    var object = ""
                    
                    for element in document.data() {
                        if element.key == "long" {
                            longitude = element.value as! Double
                            longitudeChanged = true
                        }
                        else if element.key == "lat" {
                            latitude = element.value as! Double
                            latitudeChanged = true
                        }
                        else if element.key == "building" {
                            building = element.value as! String
                            buildingChanged = true
                        }
                        else if element.key == "description" {
                            pinDescription = element.value as! String
                            pinDescriptionChanged = true
                        }
                        else if element.key == "detail" {
                            detail = element.value as! String
                            detailChanged = true
                        }
                        else if element.key == "object" {
                            object = element.value as! String
                            objectChanged = true
                        }
                        
                        if (longitudeChanged && latitudeChanged && buildingChanged && pinDescriptionChanged && detailChanged && objectChanged) {
                            let location = CLLocationCoordinate2D.init(latitude: Double(latitude), longitude: Double(longitude))
                            latitudeChanged = false
                            longitudeChanged = false
                            buildingChanged = false
                            pinDescriptionChanged = false
                            detailChanged = false
                            objectChanged = false
                            
                            
                            let annotation = CustomAnnotation(title: object + " " + detail + " " + building, sub: pinDescription, coordinate: location, object: object)
                            self.mapView.addAnnotation(annotation)
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if FiltersViewController.maleSelected && !FiltersViewController.femaleSelected && !FiltersViewController.neutralSelected {
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Men's")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if FiltersViewController.femaleSelected && !FiltersViewController.maleSelected && !FiltersViewController.neutralSelected{
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Women's")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if FiltersViewController.neutralSelected && !FiltersViewController.maleSelected && !FiltersViewController.femaleSelected {
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Neutral")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if (FiltersViewController.maleSelected && FiltersViewController.femaleSelected) && !FiltersViewController.neutralSelected {
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Men's")
            displayGender(gender: "Women's")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if (FiltersViewController.femaleSelected && FiltersViewController.neutralSelected) && !FiltersViewController.maleSelected {
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Women's")
            displayGender(gender: "Neutral")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if (FiltersViewController.maleSelected && FiltersViewController.neutralSelected) && !FiltersViewController.femaleSelected {
            mapView.removeAnnotations(mapView.annotations)
            displayGender(gender: "Men's")
            displayGender(gender: "Neutral")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        else if (!FiltersViewController.maleSelected && !FiltersViewController.femaleSelected && !FiltersViewController.neutralSelected) {
            mapView.removeAnnotations(mapView.annotations)
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
            
            toiletFilter.backgroundColor = buttonColor2
            toilet = false
            
            warningLabel.alpha = 1.0
        }
        else if (FiltersViewController.maleSelected && FiltersViewController.femaleSelected && FiltersViewController.neutralSelected) {
            displayGender(gender: "Men's")
            displayGender(gender: "Women's")
            displayGender(gender: "Neutral")
            fountainFilter.backgroundColor = buttonColor2
            fountain = false
        }
        
        if(isAddingPin) {
            
            addingAnnotation = CustomAnnotation(title: addingTitle, sub: addingSub, coordinate: addingLoc, object: addingObject)
            mapView.addAnnotation(addingAnnotation)
            
            
        }
        isAddingPin = false //Deleted all details?
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if !once{
            let userLocation = locations.last
            currentLocation = userLocation //maybe this works?
            let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 200, 200)
            self.mapView.setRegion(viewRegion, animated: false)
            once = true
        }
    }
    
    
    @objc func sideMenus(){
        if revealViewController() != nil{
            navigationItem.leftBarButtonItem?.target = self.revealViewController()
            navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = 300
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    @objc func toPinSelection(){
        performSegue(withIdentifier: "SegueMapToPin", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if(segue.identifier == "SegueMapToPin") {
            let vc = (segue.destination as! SelectPinDetailsViewController)
            vc.location = currentLocation.coordinate
        }//if map to selecting pin details
        if(segue.identifier == "SegueMapToDetails"){
            let vc = (segue.destination as? DetailsViewController)
            
            //pass param to pin detials vc
            vc?.passedTitle = selectedAnnotation.title!
            vc?.passedLong = selectedAnnotation.coordinate.longitude
            vc?.passedLat = selectedAnnotation.coordinate.latitude
            
            var documentID = ""
            db.collection("pins").whereField("long", isEqualTo: selectedAnnotation.coordinate.longitude).whereField("lat", isEqualTo: selectedAnnotation.coordinate.latitude).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        documentID = document.documentID
                        vc?.documentID = documentID
                        for element in document.data() {
                            if element.key == "object" && element.value as! String == "Bathroom" {
                                vc?.isBathroom = true
                            }
                            else if element.key == "object" && element.value as! String == "Water Fountain" {
                                vc?.isBathroom = false
                            }
                        }
                    }
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    
                    // Create a reference to the image
                    let userProfileRef = storageRef.child("pinPhotos/\(documentID).jpg")
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    let downloadTask = userProfileRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
                        if let error = error {
                            // Uh-oh, an error occurred!
                        } else {
                            // Data for pin photo is returned
                            let image = UIImage(data: data!)
                            vc?.imageView.image = image!
                        }
                    }
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("PIN PRESSED")
        selectedAnnotation = view.annotation as! CustomAnnotation
        performSegue(withIdentifier: "SegueMapToDetails", sender: self)
    }
    
    @IBAction func sosButtonPressed(_ sender: Any) {
        let user = mapView.userLocation.coordinate
        let userLat = user.latitude as Double
        let userLong = user.longitude as Double
        var lat: Double = 0
        var long: Double = 0
        var minDistance: Double = 100000 //large number on purpose
        var minLat: Double = 0
        var minLong: Double = 0
        var holdAnnotation = CustomAnnotation(title: " ", sub: " ", coordinate: CLLocationCoordinate2D(), object: " ")
        var holdDesc = ""
        var holdBuilding = ""
        var holdDetail = ""
        var holdObject = ""
        
        db.collection("pins").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    for element in document.data() {
                        if element.key == "long" {
                            long = element.value as! Double
                        }
                        else if element.key == "lat" {
                            lat = element.value as! Double
                        }
                        else if element.key == "building" {
                           holdBuilding = element.value as! String
                        }
                        else if element.key == "description" {
                            holdDesc = element.value as! String
                        }
                        else if element.key == "detail" {
                            holdDetail = element.value as! String
                        }
                        else if element.key == "object" {
                            holdObject = element.value as! String
                        }
                        let distance = self.calculateDistance(xCoord: lat, xCoordUser: userLat, yCoord: long, yCoordUser: userLong)
                        if distance < minDistance{
                            minDistance = distance
                            minLat = lat
                            minLong = long
                        }
                    }//for element in data
                }//for doc in query
                let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: minLat, longitude: minLong)
                let viewRegion = MKCoordinateRegionMakeWithDistance((location), 200, 200)
                self.mapView.setRegion(viewRegion, animated: true)
                
                /**
                holdAnnotation = CustomAnnotation(title: holdObject + " " + holdDetail + " " + holdBuilding, sub: holdDesc, coordinate: location, object: holdObject)
                self.mapView.addAnnotation(holdAnnotation)
                self.mapView.selectAnnotation(holdAnnotation, animated: true)
        **/
                
            }//else
        }//getDocuments
        
        
    }//sosbuttonPressed
    
    
    func calculateDistance(xCoord: Double, xCoordUser: Double, yCoord: Double, yCoordUser: Double) -> Double{
        //Helper method for SOSPressed()
        //FORMULA: sqrt((x1-x2)^2 + (y1-y2)^2)
        var xDifference: Double = abs(xCoordUser - xCoord)
        var yDifference: Double = abs(yCoordUser - yCoord)
        xDifference = xDifference*xDifference
        yDifference = yDifference*yDifference
        return (xDifference+yDifference).squareRoot()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
