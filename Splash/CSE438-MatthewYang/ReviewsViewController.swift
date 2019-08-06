//
//  ReviewViewController.swift
//  CSE438-MatthewYang
//
//  Created by labuser on 11/27/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ReviewsViewController: UIViewController {

    let db = Firestore.firestore()

    @IBOutlet weak var reviewsLabel: UILabel!
  //  @IBOutlet weak var writeReview: UIButton!
    @IBOutlet weak var star: StarBar!
   
    @IBOutlet weak var review1Title: UILabel!
    @IBOutlet weak var review1User: UILabel!
    @IBOutlet weak var review1Desc: UITextView!
    @IBOutlet weak var review1Up: UIButton!
    @IBOutlet weak var review1Down: UIButton!
    @IBOutlet weak var review1UpVal: UILabel!
    @IBOutlet weak var review1DownVal: UILabel!
    @IBOutlet weak var star2: StarBar!
    @IBOutlet weak var review2Title: UILabel!
    @IBOutlet weak var review2Label: UILabel!
    @IBOutlet weak var review2Desc: UITextView!
    @IBOutlet weak var review2Up: UIButton!
    @IBOutlet weak var review2Down: UIButton!
    @IBOutlet weak var review2UpVal: UILabel!
    @IBOutlet weak var review2DownVal: UILabel!
 //   @IBOutlet weak var moreReviews: UIButton! //for the tableview of all the reviews
    
    var isBathroom = false
    var documentID = ""
    
    
    var reviewTitleArr = ["Usable... Barely", "Best Day of My Life"]
    var reviewUserArr = ["panda3027", "simba_420"]
    var reviewDateArr = ["11/05/18", "11/05/18"]
    var reviewDescArr = ["Went quickly inbetween classes. Person in the stall next to me was singing Hakuna Matata was was off key. Toilet paper was brittle and I think I saw someone brushing their teeth with their finger.", "Was having an ok day but I saw I got a good grade on a midterm and a hot air vent was blowing on my backside. I even sang a song from the Lion King to celebrate this glorious day."]
    var reviewThumbUpArr = [15, 5]
    var reviewThumbDownArr = [7, 2]
    var reviewRatingArr = [3.0, 5.0]
    let pickerChoices = ["Popular", "Newest",  "Oldest", "Top Rated","Lowest Rated"]
    var thumbsup1bool = false
    var thumbsdown1bool = false
    var thumbsup2bool = false
    var thumbsdown2bool = false
    
    var count = 0

    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1 // one column
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerChoices.count
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerChoices[row]
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let chosenSort = pickerChoices[row]
//        if(chosenSort==pickerChoices[0]){//if popular chosen
//
//        }//if
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //picker
//        sortPicker.dataSource=self
//        sortPicker.delegate=self
        
        //thumb buttons
        review1Up.layer.cornerRadius = 0.5 * review1Up.bounds.size.width
        review1Down.layer.cornerRadius = 0.5 * review1Down.bounds.size.width
        review1Up.setImage(UIImage(named: "thumbsup2.png")?.withRenderingMode(.alwaysOriginal), for: [])
        review1Down.setImage(UIImage(named: "thumbsdown2.png")?.withRenderingMode(.alwaysOriginal), for: [])
        //2
        review2Up.layer.cornerRadius = 0.5 * review2Up.bounds.size.width
        review2Down.layer.cornerRadius = 0.5 * review2Down.bounds.size.width
        review2Up.setImage(UIImage(named: "thumbsup2.png")?.withRenderingMode(.alwaysOriginal), for: [])
        review2Down.setImage(UIImage(named: "thumbsdown2.png")?.withRenderingMode(.alwaysOriginal), for: [])
        
        //thumb button values
        review1UpVal.textColor = UIColor.green
        review1DownVal.textColor = UIColor.red
        review1UpVal.text = String(reviewThumbUpArr[0])
        review1DownVal.text = String(reviewThumbDownArr[0])
        review1Desc.isEditable = false
        //need to pull data from database
        review1Title.text = reviewTitleArr[0]
        review1User.text = "by: " + reviewUserArr[0] + " (" + reviewDateArr[0] + ")"
        review1Desc.text = reviewDescArr[0]
        //2
        review2UpVal.textColor = UIColor.green
        review2DownVal.textColor = UIColor.red
        //need to pull data from database
        review2UpVal.text = String(reviewThumbUpArr[1])
        review2DownVal.text = String(reviewThumbDownArr[1])
        review2Desc.isEditable = false
        review2Title.text = reviewTitleArr[1]
        review2Label.text = "by: " + reviewUserArr[1] + " (" + reviewDateArr[1] + ")"
        review2Desc.text = reviewDescArr[1]
        
        // Do any additional setup after loading the view.
        star.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        star2.color = UIColor(red: 255.0/255.0, green: 205.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        //star.color = UIColor(red: 255, green: 175, blue: 55, alpha: 1.0)
        star.animateValue(to: CGFloat(reviewRatingArr[0]/5.0))
        star2.animateValue(to: CGFloat(reviewRatingArr[1]/5.0))
    }
    
    
    

    
    
    @IBAction func thumbUp1(_ sender: Any) {
        thumbsup1bool = !thumbsup1bool
        thumbsdown1bool = false
        changethumbsup1()
        changethumbsdown1()
    }
    
    @IBAction func thumbDown1(_ sender: Any) {
        thumbsdown1bool = !thumbsdown1bool
        thumbsup1bool = false
        changethumbsdown1()
        changethumbsup1()
    }
    
    @IBAction func thumbUp2(_ sender: Any) {
        thumbsup2bool = !thumbsup2bool
        thumbsdown2bool = false
        changethumbsup2()
        changethumbsdown2()
    }
    @IBAction func thumbDown2(_ sender: Any) {
        thumbsdown2bool = !thumbsdown2bool
        thumbsup2bool = false
        changethumbsdown2()
        changethumbsup2()
    }
    
    
    
    func changethumbsup1(){
        //need to send value to database
        if (thumbsup1bool){
            review1Up.setImage(UIImage(named: "thumbsupgold.png")?.withRenderingMode(.alwaysOriginal), for: [])
            //reviewThumbUpArr[0] = reviewThumbUpArr[0]+1
            review1UpVal.text = String(reviewThumbUpArr[0]+1)
            
        }
        else{
            review1Up.setImage(UIImage(named: "thumbsup2.png")?.withRenderingMode(.alwaysOriginal), for: [])
            //reviewThumbUpArr[0] = reviewThumbUpArr[0]-1
            review1UpVal.text = String(reviewThumbUpArr[0])
        }
        
    }
    func changethumbsdown1(){
        //need to send value to database
        if (thumbsdown1bool){
            review1Down.setImage(UIImage(named: "thumbsdowngold.png")?.withRenderingMode(.alwaysOriginal), for: [])
            review1DownVal.text = String(reviewThumbDownArr[0]+1)
        }
        else{
            review1Down.setImage(UIImage(named: "thumbsdown2.png")?.withRenderingMode(.alwaysOriginal), for: [])
            review1DownVal.text = String(reviewThumbDownArr[0])
            
        }
        
    }
    
    
    func changethumbsup2(){
        //need to send value to database
        if (thumbsup2bool){
            review2Up.setImage(UIImage(named: "thumbsupgold.png")?.withRenderingMode(.alwaysOriginal), for: [])
            //reviewThumbUpArr[0] = reviewThumbUpArr[0]+1
            review2UpVal.text = String(reviewThumbUpArr[1]+1)
            
        }
        else{
            review2Up.setImage(UIImage(named: "thumbsup2.png")?.withRenderingMode(.alwaysOriginal), for: [])
            //reviewThumbUpArr[0] = reviewThumbUpArr[0]-1
            review2UpVal.text = String(reviewThumbUpArr[1])
        }
        
    }
    func changethumbsdown2(){
        //need to send value to database
        if (thumbsdown2bool){
            review2Down.setImage(UIImage(named: "thumbsdowngold.png")?.withRenderingMode(.alwaysOriginal), for: [])
            review2DownVal.text = String(reviewThumbDownArr[1]+1)
        }
        else{
            review2Down.setImage(UIImage(named: "thumbsdown2.png")?.withRenderingMode(.alwaysOriginal), for: [])
            review2DownVal.text = String(reviewThumbDownArr[1])
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveReviews()
    }
    
    func retrieveReviews() {
        print("inside retrieveReviews")
        if isBathroom {
            
            db.collection("reviewsBathroom").whereField("documentID", isEqualTo: documentID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        if self.count == 0 {
                            print("document.data(): \(document.data())")
                            for element in document.data() {
                                print("element: \(element)")
                                if element.key == "reviewTitle" {
                                    self.review1Title.text = element.value as! String
                                }
                                else if element.key == "username" {
                                    self.review1User.text = element.value as! String
                                }
                                else if element.key == "likes" {
                                    self.reviewThumbUpArr[0] = element.value as! Int
                                    self.review1UpVal.text = String(self.reviewThumbUpArr[0])
                                }
                                else if element.key == "dislikes" {
                                    self.reviewThumbDownArr[0] = element.value as! Int
                                    self.review1DownVal.text = String(self.reviewThumbDownArr[0])
                                }
                                else if element.key == "overall" {
                                    self.star.animateValue(to: CGFloat(element.value as! Double))
                                }
                                else if element.key == "review" {
                                    self.review1Desc.text = element.value as! String
                                }
                            }//for element in data
                            self.count += 1
                        }
                        else if self.count == 1 {
                            print("document.data(): \(document.data())")
                            for element in document.data() {
                                print("element: \(element)")
                                if element.key == "reviewTitle" {
                                    self.review2Title.text = element.value as! String
                                }
                                else if element.key == "username" {
                                    self.review2Label.text = element.value as! String
                                }
                                else if element.key == "likes" {
                                    self.reviewThumbUpArr[1] = element.value as! Int
                                    self.review2UpVal.text = String(self.reviewThumbUpArr[1])
                                }
                                else if element.key == "dislikes" {
                                    self.reviewThumbDownArr[1] = element.value as! Int
                                    self.review2DownVal.text = String(self.reviewThumbDownArr[1])
                                }
                                else if element.key == "overall" {
                                    self.star2.animateValue(to: CGFloat(element.value as! Double))
                                }
                                else if element.key == "review" {
                                    self.review2Desc.text = element.value as! String
                                }
                            }//for element in data
                            self.count = 0
                        }
                        
                    }//for doc in query
                    
                    
                }//else
            }//getDocuments
        } else {
            db.collection("reviewsWaterFountain").whereField("documentID", isEqualTo: documentID).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    for document in querySnapshot!.documents {
                        for element in document.data() {
                            if element.key == "reviewTitle" {
                                self.review1Title.text = element.value as! String
                            }
                            else if element.key == "username" {
                                self.review1User.text = element.value as! String
                            }
                            else if element.key == "likes" {
                                self.reviewThumbUpArr[0] = element.value as! Int
                            }
                            else if element.key == "dislikes" {
                                self.reviewThumbDownArr[0] = element.value as! Int
                            }
                            else if element.key == "overall" {
                                self.star.animateValue(to: CGFloat(element.value as! Double))
                            }
                            else if element.key == "review" {
                                self.review1Desc.text = element.value as! String
                            }
                        }//for element in data
                    }//for doc in query
                    
                    
                }//else
            }//getDocuments
        }
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
