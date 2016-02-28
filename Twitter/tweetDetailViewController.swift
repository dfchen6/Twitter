//
//  tweetDetailViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/27/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class tweetDetailViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var likeNumberLabel: UILabel!
    @IBOutlet weak var reTweetNumberLabel: UILabel!
    var tweet: Tweet!
    
    override func viewDidLoad() {
        nameLabel.text = tweet.user.name as! String
        screenNameLabel.text = tweet.user.screenName as! String
        tweetLabel.text = tweet.text as! String
        likeNumberLabel.text = String(tweet.favoriteCount)
        reTweetNumberLabel.text = String(tweet.retweetCount)
        profileImageView.setImageWithURL(tweet.user.profileURL!)
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
