//
//  FiltersViewController.swift
//  CSE438-MatthewYang
//
//  Created by labuser on 11/13/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    let themeColor = UIColor.white/* UIColor.init(red: 0.35, green: 0.682, blue: 0.996078, alpha: 1)*/
    
    @IBOutlet weak var filtersText: UILabel!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    
   /* @IBOutlet weak var overallLabel: UILabel!
    @IBOutlet weak var cleanlinessLabel: UILabel!
    @IBOutlet weak var crowdednessLabel: UILabel!
    @IBOutlet weak var overallSlider: UISlider!
    @IBOutlet weak var cleanlinessSlider: UISlider!
    @IBOutlet weak var crowdednessSlider: UISlider!
    @IBOutlet weak var val1: UILabel!
    @IBOutlet weak var val2: UILabel!
    @IBOutlet weak var val3: UILabel!
    
    var overallFilter = 1.0
    var cleanlinessFilter = 1.0
    var crowdednessFilter = 1.0*/
    
    static var maleSelected: Bool = true
    static var femaleSelected: Bool = true
    static var neutralSelected: Bool = true
    
    override func viewDidLoad() {
    maleButton.layer.cornerRadius = 0.5 * maleButton.bounds.size.width
        if FiltersViewController.maleSelected {
            maleButton.backgroundColor = themeColor
        }
    femaleButton.layer.cornerRadius = 0.5 * maleButton.bounds.size.width
        if FiltersViewController.femaleSelected{
            femaleButton.backgroundColor = themeColor
        }
    neutralButton.layer.cornerRadius = 0.5 * maleButton.bounds.size.width
        if FiltersViewController.neutralSelected{
            neutralButton.backgroundColor = themeColor
        }
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background1.png")!)
       /* val1.text = String(overallFilter)
        val2.text = String(cleanlinessFilter)
        val3.text = String(crowdednessFilter)*/
        view.addBackground()
    }
    @IBAction func maleButtonPress(_ sender: Any) {
        FiltersViewController.maleSelected = !FiltersViewController.maleSelected
        
        if (FiltersViewController.maleSelected){
            maleButton.backgroundColor = themeColor
//            femaleButton.backgroundColor = UIColor.clear
//            femaleSelected = false
//            neutralButton.backgroundColor = UIColor.clear
//            neutralSelected = false
        }
        else{
            maleButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func femaleButtonPress(_ sender: Any) {
        FiltersViewController.femaleSelected = !FiltersViewController.femaleSelected
        if (FiltersViewController.femaleSelected){
            femaleButton.backgroundColor = themeColor
//            maleButton.backgroundColor = UIColor.clear
//            maleSelected = false
//            neutralButton.backgroundColor = UIColor.clear
//            neutralSelected = false
        }
        else{
            femaleButton.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func neutralButtonPress(_ sender: Any) {
        FiltersViewController.neutralSelected = !FiltersViewController.neutralSelected
        if (FiltersViewController.neutralSelected){
            neutralButton.backgroundColor = themeColor
//            femaleButton.backgroundColor = UIColor.clear
//            femaleSelected = false
//            maleButton.backgroundColor = UIColor.clear
//            maleSelected = false
        }
        else{
            neutralButton.backgroundColor = UIColor.clear
        }
    }
    /*
    @IBAction func slider1(_ sender: UISlider) {
        overallFilter = Double(5*Int(sender.value*10))/10.0
        val1.text = String(overallFilter)
    }
    
    @IBAction func slider2(_ sender: UISlider) {
        cleanlinessFilter = Double(5*Int(sender.value*10))/10.0
        val2.text = String(cleanlinessFilter)
    }
    
    @IBAction func silder3(_ sender: UISlider) {
        crowdednessFilter = Double(5*Int(sender.value*10))/10.0
        val3.text = String(crowdednessFilter)
    }
    */
    
    
    }



//from https://stackoverflow.com/questions/27153181/how-do-you-make-a-background-image-scale-to-screen-size-in-swift/41581146#41581146
extension UIView {
    func addBackground(imageName: String = "Background1.png", contentMode: UIViewContentMode = .scaleAspectFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}

