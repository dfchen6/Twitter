//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var tweetAmount = 20
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav!.barTintColor = UIColor(red:0.11, green:0.63, blue:0.95, alpha:1.0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width,InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Set up Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                self.errorAlert(error.localizedDescription)
                print(error.localizedDescription)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets == nil {
            return 0
        } else {
            return tweets!.count
        }
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you want to sign out of Twitter?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {(action:UIAlertAction!) in
            print("cancel")
        }
        let signoutAction = UIAlertAction(title: "Sign out", style: UIAlertActionStyle.Default) {(action:UIAlertAction!) in
            TwitterClient.sharedInstance.logout()
        }
        alert.addAction(cancelAction)
        alert.addAction(signoutAction)
        self.presentViewController(alert, animated: true, completion: nil)
        print("logout")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        // Add tap gesture recognizer
        let tapProfile = UITapGestureRecognizer(target: self, action: "profileSegue:")
        tapProfile.numberOfTapsRequired = 1
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.userInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapProfile)
        
        cell.replyButton.tag = indexPath.row
        cell.replyButton.addTarget(self, action: "replyButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func replyButtonPressed(sender: UIButton!) {
        performSegueWithIdentifier("ComposeSegue", sender: sender)
        print("reply")
    }
    
    
    func profileSegue(sender: UITapGestureRecognizer!) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sender.view!.tag, inSection: 0)) as! TweetCell
        let user = cell.tweet?.user
        let profileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("profileView") as! ProfileViewController
        profileViewController.user = user
        self.navigationController!.pushViewController(profileViewController, animated:true)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimelineWithParams(["count": tweetAmount],
            success: { (tweets: [Tweet]?) -> () in
                if let tweets = tweets {
                    self.tweets = tweets
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }) { (error: NSError) -> () in
                self.errorAlert(error.localizedDescription)
                print(error.localizedDescription)
        }
    }
    
    func loadMoreData() {
        print("Fetch more tweets")
        tweetAmount += 20
        TwitterClient.sharedInstance.homeTimelineWithParams(["count": tweetAmount],
            success: { (tweets: [Tweet]?) -> () in
                if let tweets = tweets {
                    self.tweets = tweets
                    self.isMoreDataLoading = false
                    self.tableView.reloadData()
                }
            }) { (error: NSError) -> () in
                self.errorAlert(error.localizedDescription)
                print(error.localizedDescription)
        }
        loadingMoreView!.stopAnimating()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func errorAlert(message: String) {
        let title = "Error"
        let okText = "OK"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okayButton)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            if let destination = segue.destinationViewController as? tweetDetailViewController {
                destination.tweet = tweet
            }
        }
        if segue.identifier == "ComposeSegue" {
            print("prepare for segue")
//            let replyButton = sender as! UIButton
//            let nc = segue.destinationViewController as! UINavigationController
//            let vc = nc.topViewController as! NewTweetViewController
//            let tweet = tweets![replyButton.tag]
//            vc.isReply = true
//            vc.replayID = tweet.id
//            vc.responseText = "@" + ((tweet.user.screenName)! as String) + " "
        }
    }
    
}

