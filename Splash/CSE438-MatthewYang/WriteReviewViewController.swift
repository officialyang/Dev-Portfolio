//
//  WriteReviewViewController.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 12/2/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WriteReviewViewController: UIViewController, UITextViewDelegate {

    
    @IBOutlet weak var crowdednessLabel: UILabel!
    @IBOutlet weak var cleanlinessLabel: UILabel!
    @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var star3: StarBar!
    @IBOutlet weak var A1star: UIButton!
    @IBOutlet weak var A2star: UIButton!
    @IBOutlet weak var A3star: UIButton!
    @IBOutlet weak var A4star: UIButton!
    @IBOutlet weak var A5star: UIButton!
    @IBOutlet weak var bar1pic: UIImageView!
    @IBOutlet weak var bar2pic: UIImageView!
    @IBOutlet weak var star4: StarBar!
    @IBOutlet weak var star5: StarBar!
    @IBOutlet weak var B1star: UIButton!
    @IBOutlet weak var B2star: UIButton!
    @IBOutlet weak var B3star: UIButton!
    @IBOutlet weak var B4star: UIButton!
    @IBOutlet weak var B5star: UIButton!
    @IBOutlet weak var C1star: UIButton!
    @IBOutlet weak var C2star: UIButton!
    @IBOutlet weak var C3star: UIButton!
    @IBOutlet weak var C4star: UIButton!
    @IBOutlet weak var C5star: UIButton!
//
//    @IBOutlet var rateBtn: UIButton!
//    @IBOutlet var rateAndReviewBtn: UIButton!
    @IBOutlet weak var submitRating: UIButton!
    @IBOutlet weak var submitReview: UIButton!
    @IBOutlet weak var reviewDesc: UITextView!
    @IBOutlet weak var reviewTitle: UITextField!
    
    @IBOutlet weak var starBar1: StarBar!
    @IBOutlet weak var starBar2: StarBar!
    @IBOutlet weak var starBar3: StarBar!
    
    let firebaseAuth = Auth.auth()
    let database = Firestore.firestore()
    
    var documentID = ""

    var Astarval = CGFloat(1.0/5.0)
    var Bstarval = CGFloat(1.0/5.0)
    var Cstarval = CGFloat(1.0/5.0)
    
    var isBathroom = false //needs to get passed from previous view
    var colorAlpha = CGFloat(0.8)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.bringSubview(toFront: A1star)
        view.bringSubview(toFront: A2star)
        view.bringSubview(toFront: A3star)
        view.bringSubview(toFront: A4star)
        view.bringSubview(toFront: A5star)
        view.bringSubview(toFront: B1star)
        view.bringSubview(toFront: B2star)
        view.bringSubview(toFront: B3star)
        view.bringSubview(toFront: B4star)
        view.bringSubview(toFront: B5star)
        view.bringSubview(toFront: C1star)
        view.bringSubview(toFront: C2star)
        view.bringSubview(toFront: C3star)
        view.bringSubview(toFront: C4star)
        view.bringSubview(toFront: C5star)
        star3.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star3.animateValue(to: Astarval)
        star4.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star4.animateValue(to: Astarval)
        star5.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star5.animateValue(to: Astarval)
        reviewDesc.text = ""
        reviewDesc.textColor = UIColor.lightGray
 
        reviewDesc.text = "Write Review"
        reviewDesc.textColor = UIColor.lightGray
        reviewDesc.returnKeyType = .done
        reviewDesc.delegate = self
        
        if !isBathroom{
            cleanlinessLabel.text = ""
            bar2pic.alpha = 0
            star5.alpha = 0
            crowdednessLabel.alpha = 0
            star4.color = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 204.0/255.0, alpha: colorAlpha)
            star4.alpha = 0
            //starBar2?.alpha = 0
            //starBar1?.alpha = 0
            //starBar3?.alpha = 0
        }
        
    }
    
    @IBAction func A1(_ sender: Any) {
        Astarval = 1.0/5.0
        star3.animateValue(to: Astarval)
    }
    @IBAction func A2(_ sender: Any) {
        Astarval = 2.0/5.0
        star3.animateValue(to: Astarval)
    }
    @IBAction func A3(_ sender: Any) {
        Astarval = 3.0/5.0
        star3.animateValue(to: Astarval)
        //view.bringSubview(toFront: star3)
        //view.bringSubview(toFront: bar1pic)
        //view.bringSubview(toFront: A1star)
    }
    @IBAction func A4(_ sender: Any) {
        Astarval = 4.0/5.0
        star3.animateValue(to: Astarval)
    }
    @IBAction func A5(_ sender: Any) {
        Astarval = 5.0/5.0
        star3.animateValue(to: Astarval)
    }
    
    //should probably make bathroom temp a slider
    @IBAction func B1(_ sender: Any) {
        Bstarval = 1.0/5.0
        star4.animateValue(to: Bstarval)
        if !isBathroom{
                    star4.color = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 204.0/255.0, alpha: colorAlpha)
        }
    }
    @IBAction func B2(_ sender: Any) {
        Bstarval = 2.0/5.0
         if !isBathroom{
        star4.color = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: colorAlpha)
        }
        star4.animateValue(to: Bstarval)
    }
    @IBAction func B3(_ sender: Any) {
        Bstarval = 3.0/5.0
         if !isBathroom{
        star4.color = UIColor(red: 255/255.0, green: 255.0/255.0, blue: 75.0/255.0, alpha: colorAlpha)
        }
        star4.animateValue(to: Bstarval)
    }
    @IBAction func B4(_ sender: Any) {
        Bstarval = 4.0/5.0
        star4.animateValue(to: Bstarval)
         if !isBathroom{
        star4.color = UIColor(red: 255.0/255.0, green: 80.0/255.0, blue: 0.0/255.0, alpha: colorAlpha)
        }
    }
    @IBAction func B5(_ sender: Any) {
        Bstarval = 5.0/5.0
         if !isBathroom{
        star4.color = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: colorAlpha)
        }
        star4.animateValue(to: Bstarval)
    }
    
    @IBAction func C1(_ sender: Any) {
        Cstarval = 1.0/5.0
        star5.animateValue(to: Cstarval)
    }
    @IBAction func C2(_ sender: Any) {
        Cstarval = 2.0/5.0
        star5.animateValue(to: Cstarval)
    }
    @IBAction func C3(_ sender: Any) {
        Cstarval = 3.0/5.0
        star5.animateValue(to: Cstarval)
    }
    @IBAction func C4(_ sender: Any) {
        Cstarval = 4.0/5.0
        star5.animateValue(to: Cstarval)
    }
    @IBAction func C5(_ sender: Any) {
        Cstarval = 5.0/5.0
        star5.animateValue(to: Cstarval)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if textView.text == "Write Review" {
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
            textView.text = "Write Review"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //funcs here to send review or rating to firebase
    //will have to pull previous rating, modify, and reput in firebase?

    @IBAction func a(sender: AnyObject) {
        print("rating")
        if isBathroom {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsBathroom").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "cleanliness": Bstarval,
                "crowdedness": Cstarval
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsWaterFountain").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    @IBAction func b(sender: AnyObject) {
        print("ratingandreview")
        if isBathroom {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsBathroom").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "cleanliness": Bstarval,
                "crowdedness": Cstarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsWaterFountain").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
    }
    
    
    @IBAction func rate(sender: UIButton) {
        print("rating")
        
    }
    
    
    @IBAction func rateAndReview(sender: AnyObject) {
        print("ratingandreview")

    }
    @IBAction func rateObject(_ sender: Any) {
        print("rate")
        if isBathroom {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsBathroom").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "cleanliness": Bstarval,
                "crowdedness": Cstarval
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsWaterFountain").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func reviewObject(_ sender: Any) {
        print("review")
        if isBathroom {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsBathroom").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "cleanliness": Bstarval,
                "crowdedness": Cstarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        } else {
            var ref: DocumentReference? = nil
            ref = database.collection("reviewsWaterFountain").addDocument(data: [
                "documentID": documentID,
                "overall": Astarval,
                "reviewTitle": reviewTitle.text!,
                "review": reviewDesc.text!
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
}
