//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/22/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import QQPlaceholderTextView

class NewTweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    var isReply = true
    var replayID: String = ""
    var responseText: String = ""
    
    @IBOutlet weak var counterTextField: UILabel!
    var remainCharacter = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isReply = true
        tweetTextView.delegate = self
        tweetTextView.placeholder = "What's happening?"
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSendButton(sender: AnyObject) {
        if remainCharacter >= 0 {
            let tweetContent = tweetTextView.text
            TwitterClient.sharedInstance.tweet(tweetContent, params: nil, completion: { (id) -> () in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    func textViewDidChange(textView: UITextView) { //
        let tweetLen = textView.text.characters.count
        remainCharacter = 140 - tweetLen
        print(remainCharacter)
        counterTextField.text = String(remainCharacter)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
