//
//  TwitterClient.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"),
        consumerKey: "jYNgcaFzafUAQYLRYpHxPLYsb",
        consumerSecret: "iRn6cbSrUeVy3wvQoWLJeXHHvV4zs6n88vBgPqowfgprCOppeM")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: {
                (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            },
            failure: {
                (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: requestToken,
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                self.currentAccount({ (user: User) -> () in
                    self.loginSuccess?()
                    }, failure: { (error: NSError) -> () in
                        self.loginFailure?(error)
                })
        }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            print(userDictionary)
            let user = User(userDict: userDictionary)
            user.userDict = userDictionary
            User.currentUser = user
            success(user)
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
        }
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "twitterdemo://oauth"),
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("I got the token")
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
            }) { (error:NSError!) -> Void in
                print("error: \(error.localizedDescription)")
        }
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }

}
