//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
//            for tweet in tweets {
//                print(tweet.text)
//            }
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        if self.tweets == nil {
            return 0
        } else {
            return tweets!.count
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        print("logout")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    }
    
    
}

