//
//  User.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: NSString?
    var screenName: NSString?
    var profileURL: NSURL?
    var tagLine: NSString?
    var userDict: NSDictionary?
    var followerCount: Int!
    var followingCount: Int!
    let userDidLoginNotification = "userDidLoginNotification"
    let userDidLogoutNotification = "userDidLogoutNotification"
    var backgroundURL: NSURL?
    
    init(userDict: NSDictionary) {
        print(userDict)
        name = userDict["name"] as? String
        screenName = userDict["screen_name"] as? String
        let profileImageURL = userDict["profile_image_url"] as? String
        let bgURL = userDict["profile_banner_url"] as? String
        if let bgURL = bgURL {
            backgroundURL = NSURL(string: bgURL)
        }
        if let profileImageURL = profileImageURL {
            profileURL = NSURL(string: profileImageURL)
        }
        tagLine = userDict["description"] as? String
        followerCount = userDict["followers_count"] as! Int
        followingCount = userDict["friends_count"] as! Int
    }
        
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey("currentUserData") as? NSData
                if let data = data {
                    let dict = try! NSJSONSerialization.JSONObjectWithData(data, options:[]) as! NSDictionary
                    _currentUser = User(userDict: dict)
                }
        }
        return _currentUser
        }
        set(user) {
            _currentUser = user
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.userDict!, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: "currentUserData")
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "currentUserData")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
