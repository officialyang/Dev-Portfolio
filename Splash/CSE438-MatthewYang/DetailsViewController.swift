//
//  DetailsViewController.swift
//  CSE438-MatthewYang
//
//  Created by Brandon Lum on 12/1/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class DetailsViewController: UIViewController {//, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var imageView: UIImageView!
    var count = 0.0
    var totalStar3Value = 0.0
    var totalStar4Value = 0.0
    var totalStar5Value = 0.0
    var passedTitle = ""

    var passedLat: Double = 0
    var passedLong: Double = 0
    
    var markedFavBool: Bool = false
    
    var isBathroom = false
    var documentID = ""
    
    @IBOutlet weak var desc: UITextView!
    
    @IBOutlet weak var readReviewsButton: UIButton!
    //@IBOutlet weak var markAsFavorite: UIButton!
    @IBOutlet weak var writeReviewButton: UIButton!
    
    @IBOutlet weak var star3: StarBar!
    @IBOutlet weak var star4: StarBar!
    @IBOutlet weak var star5: StarBar!
    
//    @IBAction func markAsFavoritePressed(_ sender: Any) {
//        if !markedFavBool{
//        let alert = UIAlertController(title: "Favorite", message: "This location has been marked as a favorite!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            switch action.style{
//            case .default:
//                print("default")
//
//            case .cancel:
//                print("cancel")
//
//            case .destructive:
//                print("destructive")
//
//
//            }}))
//        self.present(alert, animated: true, completion: nil)
//            markedFavBool = true
//            //ADD FAVORITES TO FIREBASE HERE
//        }
//        else{
//            let alert = UIAlertController(title: "Favorite", message: "You already marked this location as a favorite!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//
//                case .cancel:
//                    print("cancel")
//
//                case .destructive:
//                    print("destructive")
//
//
//                }}))
//            self.present(alert, animated: true, completion: nil)
//            markedFavBool = true
//        }
//
//    }
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var cleanlinessLabel: UILabel!
    @IBOutlet weak var crowdednessLabel: UILabel!
    
    @IBOutlet weak var firstStar: StarBar!
    @IBOutlet weak var secondStar: StarBar!
    @IBOutlet weak var thirdStar: StarBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = passedTitle
        desc.allowsEditingTextAttributes = false
        desc.isEditable = false
        loadPin()
        star3.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star4.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star5.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        
        if self.title?.prefix(8) == "Bathroom"{
            isBathroom = true
        }
        else{
            isBathroom = false
        }
        
        if isBathroom{
            firstStar.alpha = 1
            secondStar.alpha = 1
            thirdStar.alpha = 1
            overallLabel.alpha = 1
            cleanlinessLabel.alpha = 1
            crowdednessLabel.alpha = 1
        }
        else{
            firstStar.alpha = 1
            secondStar.alpha = 0
            thirdStar.alpha = 0
            cleanlinessLabel.alpha = 0
            crowdednessLabel.alpha = 0
        }
    }
    
    func loadPin(){
        //Create a ref to the pins collection
        let db = Firestore.firestore()
        let ref = db.collection("pins")
        

        ref.whereField("long", isEqualTo: passedLong).whereField("lat", isEqualTo: passedLat).getDocuments {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    for element in document.data() {
                        if element.key == "description" {
                            self.desc.text = element.value as! String
                        }
                        else if element.key == "detail" {
                            // might add later
                        }
                        else if element.key == "object" {
                            // might add later
                        }
                    }
                }
            }
        }
    }
    
//    @IBAction func rateAndReview(_ sender: UIButton) {
//        print("rateAndReview pressed")
//        self.performSegue(withIdentifier: "toReviewScreen", sender: self)
//    }
    @IBAction func rateandReviewPressed(_ sender: Any) {
        print("rateAndReview pressed")
        self.performSegue(withIdentifier: "toReviewScreen", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        let vc = (segue.destination as? WriteReviewViewController)
//        vc?.isBathroom = isBathroom
//        vc?.documentID = documentID
        if segue.identifier == "toReviewScreen" {
            let vc = (segue.destination as! WriteReviewViewController)
            vc.isBathroom = isBathroom
            vc.documentID = documentID
        }
        if segue.identifier == "readReviewScreen" {
            let vc2 = (segue.destination as! ReviewsViewController)
            vc2.documentID = documentID
            vc2.isBathroom = isBathroom
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        retrieveRatings()
    }
    func retrieveRatings() {
        self.count = 0
        self.totalStar3Value = 0
        self.totalStar4Value = 0
        self.totalStar5Value = 0
        if isBathroom {
            db.collection("reviewsBathroom").whereField("documentID", isEqualTo: documentID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        print("document.data(): \(document.data())")
                        self.count += 1
                        for element in document.data() {
                            
                            print("self.count: \(self.count)")
                            print("element: \(element)")
                            if element.key == "overall" {
                                //                                self.star3.animateValue(to: CGFloat(element.value as! Double))
                                self.totalStar3Value += element.value as! Double
                                print("self.totalStar3Value: \(self.totalStar3Value)")
                            }
                            else if element.key == "cleanliness" {
                                //                                self.star4.animateValue(to: CGFloat(element.value as! Double))
                                self.totalStar4Value += element.value as! Double
                                print("self.totalStar4Value: \(self.totalStar4Value)")
                            }
                            else if element.key == "crowdedness" {
                                //                                self.star5.animateValue(to: CGFloat(element.value as! Double))
                                self.totalStar5Value += element.value as! Double
                                print("self.totalStar5Value: \(self.totalStar5Value)")
                            }
                        }
                    }
                    //                    self.count = 0
                }
                print(self.count)
                print("total3/self.count: \(self.totalStar3Value / self.count)")
                print("total4/self.count: \(self.totalStar4Value / self.count)")
                print("total5/self.count: \(self.totalStar5Value / self.count)")
                if (self.count != 0){
                    self.star3.animateValue(to: CGFloat(self.totalStar3Value / self.count))
                    self.star4.animateValue(to: CGFloat(self.totalStar4Value / self.count))
                    self.star5.animateValue(to: CGFloat(self.totalStar5Value / self.count))
                }
            }
            
            
        } else {
            db.collection("reviewsWaterFountain").whereField("documentID", isEqualTo: documentID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        self.count += 1
                        for element in document.data() {
                            
                            print(self.count)
                            if element.key == "overall" {
                                //                                self.star3.animateValue(to: CGFloat(element.value as! Double))
                                self.totalStar3Value += element.value as! Double
                            }
                        }
                    }
                    //self.count = 0
                }
                if self.count != 0{
                self.star3.animateValue(to: CGFloat(self.totalStar3Value / self.count))
                self.star4.animateValue(to: CGFloat(self.totalStar4Value / self.count))
                self.star5.animateValue(to: CGFloat(self.totalStar5Value / self.count))
                }
            }
            
            
        }
    }
    
    @IBAction func readReviewsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "readReviewScreen", sender: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

