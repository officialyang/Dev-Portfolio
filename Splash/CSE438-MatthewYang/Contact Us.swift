//
//  Contact Us.swift
//  CSE438-MatthewYang
//
//  Created by Matthew Yang on 11/26/18.
//  Copyright © 2018 Matthew Yang. All rights reserved.
//

import UIKit

class Contact_Us: UITableViewController {
    @IBOutlet weak var email: UITableViewCell!
    @IBOutlet weak var facebook: UITableViewCell!
    @IBOutlet weak var twitter: UITableViewCell!
    @IBOutlet weak var instagram: UITableViewCell!
    @IBOutlet weak var leaveReview: UITableViewCell!
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //EMAIL TAPPED
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(emailTapped(tapGestureRecognizer:)))
        email.isUserInteractionEnabled = true
        email.addGestureRecognizer(tapGestureRecognizer)
        
        //FACEBOOK TAPPED
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(facebookTapped(tapGestureRecognizer:)))
        facebook.isUserInteractionEnabled = true
        facebook.addGestureRecognizer(tapGestureRecognizer2)
        
        //TWITTER TAPPED
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(twitterTapped(tapGestureRecognizer:)))
        twitter.isUserInteractionEnabled = true
        twitter.addGestureRecognizer(tapGestureRecognizer3)
        
        //INSTAGRAM TAPPED
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(instagramTapped(tapGestureRecognizer:)))
        instagram.isUserInteractionEnabled = true
        instagram.addGestureRecognizer(tapGestureRecognizer4)
        
        //LEAVE US A REVIEW TAPPED
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(leaveReviewTapped(tapGestureRecognizer:)))
        leaveReview.isUserInteractionEnabled = true
        leaveReview.addGestureRecognizer(tapGestureRecognizer5)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func emailTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let url = URL(string: "https://stackoverflow.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func facebookTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let url = URL(string: "https://facebook.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func twitterTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let url = URL(string: "https://twitter.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func instagramTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let url = URL(string: "https://instagram.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func leaveReviewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        guard let url = URL(string: "https://google.com") else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section ==  0{
            return 4
        }
        else if section == 1{
            return 1
        }
        return 0
    }

}
