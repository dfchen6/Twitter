//
//  TweetCell.swift
//  Twitter
//
//  Created by Difan Chen on 2/19/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var retweeLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet.userName as! String
            tweetLabel.text = tweet.text as! String
            profileImageView.setImageWithURL(tweet.user.profileURL!)
            screenNameLabel.text = "@" + (tweet.user.screenName as! String)
            retweeLabel.text = String(tweet.retweetCount)
            favoritesLabel.text = String(tweet.favoriteCount)
            timeLabel.text = tweet.timeElapsed()
            if (tweet.liked != nil && tweet.liked!) {
                favoritesLabel.textColor = UIColor.redColor()
                favoriteButton.setImage(UIImage(named: "favorite_on"), forState: .Normal)
            } else {
                favoritesLabel.textColor = UIColor.grayColor()
                favoriteButton.setImage(UIImage(named: "favorite"), forState: .Normal)
            }
            if (tweet.retweeted != nil && tweet.retweeted!) {
                retweeLabel.textColor = UIColor(red:0.1, green:0.72, blue:0.6, alpha:1.0)
                retweetButton.setImage(UIImage(named: "retweet_on"), forState: .Normal)
            } else {
                retweeLabel.textColor = UIColor.grayColor()
                retweetButton.setImage(UIImage(named: "retweet"), forState: .Normal)
            }
            
            selectionStyle = .None
            profileImageView.layer.cornerRadius = 6
            profileImageView.clipsToBounds = true
            
            // Add tap gesture to profile image
            let tapImage = UITapGestureRecognizer(target: self, action: "profileTapped")
            tapImage.numberOfTapsRequired = 1
            profileImageView.addGestureRecognizer(tapImage)
            profileImageView.userInteractionEnabled = true
        }
    }
    
    func profileTapped() {
        print("Print my profile image")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    @IBAction func favoriteButton(sender: AnyObject) {
        if (tweet.liked!) {
            tweet.unfavorite({ (tweet, error) -> () in
                if let tweet = tweet {
                    self.tweet = tweet
                }
            })
        } else {
            tweet.favorite({ (tweet, error) -> () in
                if let tweet = tweet {
                    self.tweet = tweet
                }
            })
        }
    }
    
    @IBAction func retweetButton(sender: AnyObject) {
        if (tweet.retweeted!) {
            tweet.unretweet({ (tweet, error) -> () in
                if let tweet = tweet {
                    self.tweet = tweet
                }
            })
        } else {
            tweet.retweet({ (tweet, error) -> () in
                if let tweet = tweet {
                    self.tweet = tweet
                }
            })
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
