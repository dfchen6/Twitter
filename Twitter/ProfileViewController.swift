//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/23/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var numOfFollowersLabel: UILabel!
    @IBOutlet weak var numOfFollowingLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = User.currentUser
        }

        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = user.name as? String
        profileImageView.setImageWithURL(user.profileURL!)
        screenNameLabel.text = user.screenName as? String
        numOfFollowersLabel.text = String(user.followerCount)
        numOfFollowingLabel.text = String(user.followingCount)
        backGroundImageView.setImageWithURL(user.backgroundURL!)
        
        TwitterClient.sharedInstance.userTimeline(["screen_name": user.screenName!], success: { (tweets: [Tweet]?) -> () in
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
                print(tweets)
            }
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets == nil {
            return 0
        } else {
            return tweets!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
}
