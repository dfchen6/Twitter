//
//  LoginViewController.swift
//  Twitter
//
//  Created by Difan Chen on 2/18/16.
//  Copyright © 2016 Difan Chen. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.login({ () -> () in
            print("I have logged in")
            self.performSegueWithIdentifier("loginToHome", sender: nil)
        }) { (error: NSError) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

