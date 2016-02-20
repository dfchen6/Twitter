//
//  Tweet.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: String
    var user: User
    var userName: NSString?
    var text: NSString?
    var createDate: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var retweeted: Bool?
    var liked: Bool?
    
    init(tweetDict: NSDictionary) {
        id = tweetDict["id_str"] as! String
        text = tweetDict["text"] as? String
        retweetCount = (tweetDict["retweet_count"] as? Int) ?? 0
        favoriteCount = (tweetDict["favorite_count"] as? Int) ?? 0
        let timeStampString = tweetDict["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EE MM d HH:mm:ss Z y"
            createDate = formatter.dateFromString(timeStampString)
        }
        userName = tweetDict["user"]!["name"] as? String
        let user = User(userDict: tweetDict["user"] as! NSDictionary)
        self.user = user
        retweeted = tweetDict["retweeted"] as? Bool
        liked = tweetDict["favorited"] as? Bool
    }
    
    func timeElapsed() -> String {
        let timeElapsedInSeconds = createDate?.timeIntervalSinceNow
        let time = abs(NSInteger(timeElapsedInSeconds!))
        if (time > 24 * 60 * 24) {
            return String(time / (24 * 60 * 24)) + "d"
        } else if (time > 60 * 60) {
            return String(time / (60 * 60)) + "h"
        } else {
            return String(time / 60) + "m"
        }
    }
    
    class func tweetsWithArray(tweetDicts: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dict in tweetDicts {
            let tweet = Tweet(tweetDict: dict)
            tweets.append(tweet)
        }
        return tweets
    }
    
    func favorite(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST(
            "1.1/favorites/create.json?id=\(id)",
            parameters: nil,
            progress: nil,
            success: { (_: NSURLSessionDataTask, _: AnyObject?) -> Void in
                self.liked = true
                self.favoriteCount++
                completion(tweet: self, error: nil)
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func unfavorite(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST(
            "1.1/favorites/destroy.json?id=\(id)",
            parameters: nil,
            success: { (_: NSURLSessionDataTask, response: AnyObject?) -> Void in
                self.liked = false
                self.favoriteCount--
                completion(tweet: self, error: nil)
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func retweet(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST(
            "1.1/statuses/retweet/\(id).json",
            parameters: nil,
            progress: nil,
            success: { (_: NSURLSessionDataTask, _: AnyObject?) -> Void in
                self.retweeted = true
                self.retweetCount++
                completion(tweet: self, error: nil)
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }
    
    func unretweet(completion: (tweet: Tweet?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.POST(
            "1.1/statuses/unretweet/\(id).json",
            parameters: nil,
            progress: nil,
            success: { (_: NSURLSessionDataTask, _: AnyObject?) -> Void in
                self.retweeted = false
                self.retweetCount--
                completion(tweet: self, error: nil)
            },
            failure: { (_: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweet: nil, error: error)
            }
        )
    }


}
